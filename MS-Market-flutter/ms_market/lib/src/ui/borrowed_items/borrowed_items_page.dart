

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ms_market/src/bloc/profile_bloc/bloc.dart';
import 'package:ms_market/src/models/borrow_request.dart';
import 'package:ms_market/src/resources/services/graphql_client.dart';
import 'package:ms_market/src/ui/borrowed_items/borrowed_item_card.dart';
import 'package:ms_market/src/ui/common/no_results_placeholder.dart';
import 'package:ms_market/src/ui/common/slide_page_transition.dart';
import 'package:ms_market/src/ui/common/snack_bar.dart';
import 'package:ms_market/src/ui/foreign_item/foreign_item_page.dart';
import 'package:ms_market/src/utils/colors.dart';

class BorrowedItemsPage extends StatefulWidget {

  State<BorrowedItemsPage> createState() => _BorrowedItemsPageState();
}

class _BorrowedItemsPageState extends State<BorrowedItemsPage> {
  List<BorrowRequest> _borrowed;

  _defaultFetchEvent({bool refresh = false}) {
    return ProfileFetchBorrowedItems(
      limit: 100, 
      statuses: [BorrowStatus.ACCEPTED, BorrowStatus.BORROWED, BorrowStatus.CREATED, BorrowStatus.DECLINED],
      forceRefresh: refresh
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (context) => ProfileBloc(client: GraphqlClientService.client)
        ..add(_defaultFetchEvent()),
      
      child: Scaffold(
        appBar: AppBar(
          title: Text("Wypożyczone przedmioty", style: TextStyle(color: Colors.grey[600])),
          centerTitle: true,
        ),
        backgroundColor: darkAccentColor,
        body: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileFetchedBorrowedItems) {
              setState(() {
                _borrowed = state.borrowed;
              });
            }
            if (state is ProfileError) {
              showErrorSnackbar(context, state.error);
            }
            if (state is ProfileUpdateBorrowRequestLoading) {
              showLoadingSnackbar(context, "Trwa anulowywanie wypożyczenia");
            }
            if (state is ProfileUpdatedBorrowRequestStatus) {
              showSuccessSnackbar(context, "Anulowano prośbę o wypożyczenie");
              setState(() {
                final toUpdate = _borrowed.firstWhere((v) => v.id == state.request.id, orElse: () => null);
                toUpdate.status = state.request.status;
              });
            }

          },
          child: Builder(builder: (context) => _body(context))
        )
      )
    );
  }

  Widget _body(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading || _borrowed == null) {
          return Center(child: CircularProgressIndicator());
        }
        return _borrowedItemsList(context);
      },
    );
  }

  Widget _borrowedItemsList(BuildContext context) {
    if (_borrowed == null || _borrowed.isEmpty) {
      return NoResultsPlaceholderRefreshable(
        message: "Brak przedmiotów",
        subMessage: "Ale jak byś czegoś potrzebował to nie bój się poszukać",
        onRefresh: () async {
          BlocProvider.of<ProfileBloc>(context).add(_defaultFetchEvent(refresh: true));
          return null;
        },
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<ProfileBloc>(context).add(_defaultFetchEvent(refresh: true));
          return null;
        },
        child: ListView.builder(
          itemCount: _borrowed.length,
          itemBuilder: (context, idx) {
            return GestureDetector(
              onLongPress: () {
                // user can only cancel created status
                if (_borrowed[idx].status == BorrowStatus.CREATED) {
                  final bloc = BlocProvider.of<ProfileBloc>(context);
                  _cancelRequestDialog(() {
                    bloc.add(ProfileUpdateBorrowRequestStatus(borrowRequestId: _borrowed[idx].id, borrowStatus: BorrowStatus.CANCELED));
                  });

                }
              },
              onTap: () {
                Navigator.of(context).push(
                  SlideLeftRoute(
                    page: ForeignItemPage(itemId: _borrowed[idx].item.id)
                  )
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: BorrowedItemCard(borrowRequest: _borrowed[idx])
              ),
            );
          },
        ),
      ),
    );
  }

  _cancelRequestDialog(void Function() onSuccess) {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        backgroundColor: darkAccentColor,
        title: Text("Czy chcesz odwołać prośbę o wypożyczenie?"),
        actions: <Widget>[
          FlatButton(
            child: Text("Anuluj"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text("Kontynuuj"),
            onPressed: (){
              onSuccess();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
  }

}