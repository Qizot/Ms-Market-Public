import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:ms_market/src/models/borrow_request.dart';

class SimpleBorrowRequestCard extends StatelessWidget {
  final BorrowRequest request;

  SimpleBorrowRequestCard({this.request}): assert(request != null);

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text("Wypożyczenie", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20))
          ),
          SizedBox(height: 10),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Użytkownik: ", 
                  style: TextStyle(fontWeight: FontWeight.w600)
                ),
                TextSpan(
                  text: '${request.user.name} ${request.user.surname}'
                )
              ]
            )
          ),
          SizedBox(height: 10),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Status: ", 
                  style: TextStyle(fontWeight: FontWeight.w600)
                ),
                TextSpan(
                  text: request.status.readable()
                )
              ]
            )
          ),
          SizedBox(height: 10),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Ostatnia aktualizacja statusu: ", 
                  style: TextStyle(fontWeight: FontWeight.w600)
                ),
                TextSpan(
                  text: DateFormat.yMMMMd("pl_PL").format(request.updatedStatusAt)
                )
              ]
            )
          ),
        ],
      )
    );
  }
}