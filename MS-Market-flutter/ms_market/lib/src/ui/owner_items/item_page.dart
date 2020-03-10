
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ms_market/src/bloc/item_bloc/bloc.dart';
import 'package:ms_market/src/models/item/item.dart';
import 'package:ms_market/src/ui/common/alert_box.dart';
import 'package:ms_market/src/ui/common/item_reviews_screen.dart';
import 'package:ms_market/src/ui/common/mode.dart';
import 'package:ms_market/src/ui/common/slide_page_transition.dart';
import 'package:ms_market/src/ui/common/snack_bar.dart';
import 'package:ms_market/src/ui/owner_items/add_edit_item.dart';
import 'package:ms_market/src/ui/owner_items/item_details_screen.dart';
import 'package:ms_market/src/ui/owner_items/item_history_screen.dart';


class ItemPage extends StatefulWidget {
  final String itemId;
  final ItemBloc bloc;

  ItemPage({@required String itemId, @required ItemBloc bloc}) : itemId = itemId, bloc = bloc;
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  Item _item;

  final _actionButtonTextStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w600);

  @override
  void initState() {
    widget.bloc.add(ItemFetchItemById(id: widget.itemId));
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    return DefaultTabController(
      length: 3,
      child: _scaffold(),
    );
  }

  Widget _scaffold() {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text("Przedmiot", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: Colors.black,
          brightness: Brightness.dark,
          actions: <Widget>[
            Builder(builder: (context) => _actionButton(context))
          ],
          bottom: TabBar(
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
        body: BlocListener<ItemBloc, ItemState>(
          bloc: widget.bloc,
          listener: (context, state) {
            if (state is ItemFetchedOne) {
              setState(() {
                _item = state.item;
              });
            }
            if (state is ItemUpdated) {
              setState(() {
                _item?.merge(state.item);
              });
              showSuccessSnackbar(context, "Pomyślnie uaktualniono przedmiot!");
            }
            if (state is ItemDeleteLoading) {
              showLoadingSnackbar(context, 'Trwa usuwanie przedmiotu...');
            }
            if (state is ItemDeleted) {
              // TODO: there might be many of items to refetch but
              // I haven't find a way to clear cache of just one item
              widget.bloc.add(ItemFetchOwnerItems(forceRefresh: true));
              Navigator.of(context).popUntil(ModalRoute.withName('/owner-items'));
            }
            if (state is ItemError) {
              showErrorSnackbar(context, "Wystąpił nieoczekiwany błąd, spróbuj ponownie później!");
            }
          },

          child: TabBarView(
            children: <Widget>[
              _detailsBuilder(),
              _ratingBuilder(),
              _borrowRequestBuilder(),
            ],
          )
        ),
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
        child: Text("Recenzje")
      )
    ),
    Tab(
      child: Align(
        alignment: Alignment.center,
        child: Text("Historia")
      )
    ),
  ];

  Widget _actionButton(context) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        _showBottomActions(context);
      },
    );
  }

  _showBottomActions(BuildContext scaffoldContext) {
    showModalBottomSheet(
      context: scaffoldContext,
      builder: (context) {
        return Container(
          color: Colors.black,
          height: 150,
          padding: EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              _editButton(context),
              Divider(),
              _deleteButton(modalContext: context, scaffoldContext: scaffoldContext)
            ],
          ),
        );
      },
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(20.0),
        )));
  }

  _deleteButton({BuildContext modalContext, BuildContext scaffoldContext}) {
    return InkWell(
      onTap: () {
        Navigator.of(modalContext).pop();
        showAlertDialog(
          scaffoldContext,
          alertText: "Czy na pewno chcesz ten przedmiot?",
          descriptionText: "Czynności tej nie da się cofnąć, utracone zostaną wszystkie informacje o przedmiocie",
          confirmText: "Usuń",
          cancelText: "Anuluj",
          onConfirm: () {
            if (_item != null) {
              widget.bloc.add(ItemDelete(itemId: _item.id));
            }
          }
        );
      },
      child: Row(
        children: <Widget>[
          Icon(Icons.delete_outline, color: Colors.red, size: 32),
          SizedBox(width: 15),
          Text("Usuń przedmiot", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.red))
        ],
      ),
    );
  }

  _editButton(context) {
        return InkWell(
      onTap: () {
        if (_item != null) {
          Navigator.of(context).pushReplacement(
            SlideLeftRoute(
              page: AddEditItem(
                itemBloc: widget.bloc,
                mode: Mode.edit,
                item: _item,
              ))
            );
        }
      },
      child: Row(
        children: <Widget>[
          Icon(Icons.edit, size: 32),
          SizedBox(width: 15),
          Text("Edytuj przedmiot", style: _actionButtonTextStyle)
        ],
      ),
    );
  }


  Widget _detailsBuilder() {
    return BlocBuilder<ItemBloc, ItemState>(
      bloc: widget.bloc,
      builder: (context, state) {
      if (state is ItemLoading || _item == null) {
        return Container(
          color: Colors.black,
          child: Center(child: CircularProgressIndicator()),
        );
      }
      return RefreshIndicator(
          child: ItemDetailsScreen(item: _item),
          onRefresh: () async {
            widget.bloc.add(ItemFetchItemById(id: widget.itemId, forceRefresh: true));
            return null;
          });
    });
  }

  Widget _ratingBuilder() {
    return BlocBuilder<ItemBloc, ItemState>(
      bloc: widget.bloc,
      builder: (context, state) {
      if (state is ItemLoading || _item == null) {
        return Container(
          color: Colors.black,
          child: Center(child: CircularProgressIndicator()),
        );
      }
      return ItemReviewsScreen(ratings: _item.ratings);
    });
  }


  Widget _borrowRequestBuilder() {
    return BlocBuilder<ItemBloc, ItemState>(
      bloc: widget.bloc,
      builder: (context, state) {
      if (state is ItemLoading || _item == null) {
        return Container(
          color: Colors.black,
          child: Center(child: CircularProgressIndicator()),
        );
      }
      return ItemHistoryScreen(requests: _item.borrowRequests);
    });
  }
}
