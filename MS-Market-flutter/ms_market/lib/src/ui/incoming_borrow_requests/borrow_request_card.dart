

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:ms_market/src/models/borrow_request.dart';
import 'package:ms_market/src/ui/incoming_borrow_requests/helpers.dart';

class BorrowRequestCard extends StatelessWidget {
  
  final BorrowRequest request;

  BorrowRequestCard({@required this.request}) {
    assert(this.request != null);
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).accentColor,
        boxShadow: [
          BoxShadow(
          color: Colors.black,
          offset: Offset(6, 6)
          )
        ],
      ),
      child: _requestView()
    );
  }

  Widget _requestView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: Text(request.item.name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20))
        ),
        SizedBox(height: 10),
        _borrower(),
        SizedBox(height: 10),
        _status(),
        SizedBox(height: 10),
        _lastUpdate()

      ],
    );
  }

  Widget _borrower() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: "Osoba pytająca:  ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          TextSpan(text: "${request.user.name} ${request.user.surname}", style: TextStyle(color: Colors.white.withOpacity(0.2))),
        ]
      )
    );
  }


  Widget _status() {

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: "Status:  ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          TextSpan(text: "${request.status.readable()}", style: TextStyle(color: getBorrowStatusColor(request.status))),
        ]
      )
    );
  }

  Widget _lastUpdate() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: "Ostatnia zmiana statusu:  ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          TextSpan(text: "${DateFormat.yMMMMd("pl_PL").format(request.updatedStatusAt)}", style: TextStyle(color: Colors.white.withOpacity(0.2))),
        ]
      )
    );
  }
}