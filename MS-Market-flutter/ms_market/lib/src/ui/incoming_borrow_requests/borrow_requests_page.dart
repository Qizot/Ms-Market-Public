

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ms_market/src/bloc/profile_bloc/bloc.dart';
import 'package:ms_market/src/models/borrow_request.dart';
import 'package:ms_market/src/resources/services/graphql_client.dart';
import 'package:ms_market/src/ui/common/no_results_placeholder.dart';
import 'package:ms_market/src/ui/common/snack_bar.dart';
import 'package:ms_market/src/ui/incoming_borrow_requests/borrow_request_card.dart';
import 'package:ms_market/src/ui/incoming_borrow_requests/update_borrow_status_dialog.dart';
import 'package:ms_market/src/utils/colors.dart';

class BorrowRequestsPage extends StatefulWidget {

  State<BorrowRequestsPage> createState() => _BorrowRequestsPageState();
}

class _BorrowRequestsPageState extends State<BorrowRequestsPage> {
  
  List<BorrowRequest> _requests;
  List<BorrowRequest> _filteredRequests;
  List<BorrowStatus> _allowedStatuses = [BorrowStatus.ACCEPTED, BorrowStatus.CREATED, BorrowStatus.BORROWED];
  int _defaultLimit = 100;
  TextEditingController _searchItemName;

  @override
  void initState() { 
    super.initState();
    _searchItemName = TextEditingController()..addListener(_filterRequests);
  }

  _filterRequests() {
    if (_requests == null) return;
    setState(() {
      _filteredRequests = _requests?.where(
        (v) => v.item.name
          .toLowerCase()
          .contains(
            _searchItemName.text.toLowerCase()))?.toList();
    });
  }

  _unfocusSearchBar() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
  
  ProfileEvent defaultFetch({bool forceRefresh = false}) =>
    ProfileFetchIncomingBorrowRequests(limit: _defaultLimit, statuses: _allowedStatuses, forceRefresh: forceRefresh);


  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (context) => ProfileBloc(client: GraphqlClientService.client)
        ..add(defaultFetch()),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Prośby o wypożyczenie", style: TextStyle(color: Colors.grey[600])),
          centerTitle: true,
        ),
        backgroundColor: darkAccentColor,
        body: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileFetchedIncomingBorrowRequests) {
              setState(() {
                _requests = state.requests;
                _requests.sort((a, b) => b.updatedStatusAt.compareTo(a.updatedStatusAt));
              });
              _filterRequests();
            }
            if (state is ProfileError) {
              Scaffold.of(context).hideCurrentSnackBar();
              showErrorSnackbar(context, state.error);
            }
            if (state is ProfileUpdatedBorrowRequestStatus) {
              Scaffold.of(context).hideCurrentSnackBar();
              final request = _requests.firstWhere((v) => v.id == state.request.id, orElse: () => null);
              request.status = state.request.status;
            }
            if (state is ProfileUpdateBorrowRequestLoading) {
              showLoadingSnackbar(context, "Trwa aktualizowanie statusu...");
            }
          },
          child: Builder(builder: (context) => _body(context))
        )
      ),
    );
  }

  Widget _body(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<ProfileBloc>(context),
      builder: (context, state) {
        if (state is ProfileLoading || _requests == null) {
          return Center(child: CircularProgressIndicator());
        }
        return Column(
          children: <Widget>[
            _searchBar(),
            Expanded(
              child: GestureDetector(
                onTap: () => _unfocusSearchBar(),
                child: _borrowRequestsList(context)
              )
            ),
          ],
        );
      },
    );
  }

  Widget _searchBar() {
    return Container(
      margin: EdgeInsets.all(8),
      child: TextField(
        controller: _searchItemName,
        decoration: InputDecoration(
            hintText: "Wyszukaj przedmiot...",
            suffixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)))),
      ),
    );
  }


  _showUpdateStatusModal(BuildContext context, BorrowRequest request) {
    final bloc = BlocProvider.of<ProfileBloc>(context);

    showDialog(context: context, builder: (context) => 
      UpdateBorrowStatusDialog(
        request: request,
        onAccept: (status) {
            bloc.add(ProfileUpdateBorrowRequestStatus(
              borrowRequestId: request.id, 
              borrowStatus: status
            )
          );
        },
      )
    );
  }

  Widget _borrowRequestsList(BuildContext context) {
    final requests = _filteredRequests;
    if (requests.isEmpty) {
      return NoResultsPlaceholderRefreshable(
        message: "Brak wypożyczeń",
        onRefresh: () async {
          BlocProvider.of<ProfileBloc>(context).add(defaultFetch(forceRefresh: true));
          return null;
        },
      );
    }
    return RefreshIndicator(
      onRefresh: () async {
        BlocProvider.of<ProfileBloc>(context).add(defaultFetch(forceRefresh: true));
        return null;
      },
      child: ListView.builder(
        itemCount: requests.length ??= 0,
        itemBuilder: (contextWithoutBloc, idx) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: GestureDetector(
              onTap: () {
                _unfocusSearchBar();
                _showUpdateStatusModal(context, requests[idx]);
              },
              child: BorrowRequestCard(request: requests[idx])
            )
          );
        },
      ),
    );
  }
}