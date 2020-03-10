

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ms_market/src/bloc/foreign_item_bloc/bloc.dart';
import 'package:ms_market/src/models/item/item.dart';
import 'package:ms_market/src/resources/repositories/user_repository.dart';
import 'package:ms_market/src/resources/services/graphql_client.dart';
import 'package:ms_market/src/ui/common/item_reviews_screen.dart';
import 'package:ms_market/src/ui/common/mode.dart';
import 'package:ms_market/src/ui/common/slide_page_transition.dart';
import 'package:ms_market/src/ui/common/snack_bar.dart';
import 'package:ms_market/src/ui/foreign_item/foreign_item_details_screen.dart';
import 'package:ms_market/src/ui/foreign_item/rate_item_page.dart';

class ForeignItemPage extends StatefulWidget {
  final String itemId;

  ForeignItemPage({@required this.itemId});

  State<ForeignItemPage> createState() => _ForeignItemPageState();

}

class _ForeignItemPageState extends State<ForeignItemPage> with SingleTickerProviderStateMixin  {
  
  Item _item;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
  }

   @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    print("changed index");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ForeignItemBloc>(
      create: (context) => ForeignItemBloc(client: GraphqlClientService.client)
        ..add(ForeignItemFetchById(itemId: widget.itemId)),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text("Przedmiot", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: Colors.black,
          brightness: Brightness.dark,
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              color: Colors.black54
            ),
            tabs: _tabs()
          )
        ),
        backgroundColor: Colors.black,
        floatingActionButton: Builder(builder: (context) => _floatingActionButton(context)),
        body: BlocListener<ForeignItemBloc, ForeignItemState>(
          listener: (context, state) {
            if (state is ForeignItemFetchedOne) {
              setState(() {
                _item = state.item;
              });
            }
            if (state is ForeignItemRated) {
              showSuccessSnackbar(context, "Oceniono przedmiot!");
              // go refresh the screen 
              if (_item != null) {
                BlocProvider.of<ForeignItemBloc>(context)
                  .add(ForeignItemFetchById(itemId: _item.id, forceRefresh: true));
              }
            }
            if (state is ForeignItemBorrowRequestCreated) {
              showSuccessSnackbar(context, "Wysłano prośbę o wypożyczenie przedmiotu");
            }
            if (state is ForeignItemError) {
              showErrorSnackbar(context, state.error);
            }
          },
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              _detailsBuilder(),
              _ratingBuilder()
            ],
          )
        )

      )
    );
  }

  _tabs() => [
      Tab(
        child: Align(
          alignment: Alignment.center,
          child: Text("Informacje")
        )
      ),
      Tab(
        child: Align(
          alignment: Alignment.center,
          child: Text("Opinie")
        )
      ),
    ];

  Widget _detailsBuilder() {
    return BlocBuilder<ForeignItemBloc, ForeignItemState>(
      builder: (context, state) {
        if (state is ForeignItemLoading || _item == null) {
          return Center(
            child: CircularProgressIndicator()
          );
        }
        return RefreshIndicator(
          child: ForeignItemDetailsScreen(item: _item),
          onRefresh: () async {
            BlocProvider.of<ForeignItemBloc>(context).add(ForeignItemFetchById(itemId: widget.itemId, forceRefresh: true));
            return null;
          },
        );
      },
    );
  }

  Widget _ratingBuilder() {
    return BlocBuilder<ForeignItemBloc, ForeignItemState>(
      builder: (context, state) {
        if (state is ForeignItemLoading || _item == null) {
          return Center(
            child: CircularProgressIndicator()
          );
        }
        return ItemReviewsScreen(ratings: _item.ratings);

      },
    );
  }


  Widget _floatingActionButton(context) {
    if (_tabController?.index == 0) {
      return _borrowFloatingActionButton(context);
    }
    return _reviewFloatingActionButton(context);
  } 

  Widget _reviewFloatingActionButton(context) {
    return FloatingActionButton(
      tooltip: "Dodaj opinię",
      child: Icon(Icons.note),
      onPressed: () async {
        // search for 
        final currentUser = await UserRepository(client: GraphqlClientService.client.value).getMeInfo();
        final rating = _item?.ratings?.firstWhere((rating) => rating.user.id == currentUser.id, orElse: () => null);
        
        Mode mode = Mode.create; 
        if (rating != null) {
          mode = Mode.edit;
        }

        final bloc = BlocProvider.of<ForeignItemBloc>(context);

        Navigator.of(context).push(
          SlideLeftRoute(
            page: RateItemPage(
              bloc: bloc, 
              itemId: widget.itemId,
              mode: mode,
              rating: rating,
            )
          )
        );
      },
    );
  }

  Widget _borrowFloatingActionButton(context) {
    return FloatingActionButton(
      tooltip: "Wypożycz przedmiot",
      child: Icon(Icons.send),
      onPressed: () async {
        if (_item != null) {
          BlocProvider.of<ForeignItemBloc>(context).add(ForeignItemCreateBorrowRequest(itemId: _item.id));
        }

      }
    );

  }
}