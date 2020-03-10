

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ms_market/src/models/borrow_request.dart';
import 'package:ms_market/src/ui/owner_items/simple_borrow_request_card.dart';

class ItemHistoryScreen extends StatelessWidget {
  final List<BorrowRequest> requests;

  ItemHistoryScreen({this.requests}) {
    requests.sort((a, b) => b.updatedStatusAt.compareTo(a.updatedStatusAt));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: _body()
    );
  }

  Widget _body() {
    if (requests.length == 0) {
      return Center(child: Text("Brak historii", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30)));
    }
    return ListView.builder(
      itemCount: requests.length,
      itemBuilder: (context, idx) {
        return SimpleBorrowRequestCard(request: requests[idx]);
      }
    );
  }
}