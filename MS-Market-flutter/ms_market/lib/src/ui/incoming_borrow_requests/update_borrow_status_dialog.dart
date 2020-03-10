

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ms_market/src/models/borrow_request.dart';
import 'package:ms_market/src/ui/incoming_borrow_requests/helpers.dart';
import 'package:ms_market/src/utils/colors.dart';


class UpdateBorrowStatusDialog extends StatefulWidget {
  
  final void Function(BorrowStatus) onAccept;
  final void Function() onCancel;
  final BorrowRequest request;

  UpdateBorrowStatusDialog({@required this.request, this.onAccept, this.onCancel}) {
    assert(request != null);
  }

  State<UpdateBorrowStatusDialog> createState() => _UpdateBorrowStatusDialogState();

}

class _UpdateBorrowStatusDialogState extends State<UpdateBorrowStatusDialog> {

  int _currentValue;
  List<BorrowStatus> _statuses;

  @override
  void initState() {
    _statuses = BorrowStatusHelper.getAvailableActions(widget.request.status);
    _currentValue = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: darkAccentColor,
      child: _info()
    );
  }

  Widget _info() {
    return Container(
      padding: EdgeInsets.all(20),
      height: 300,
      child: Column(children: <Widget>[
        Text("Zmień status wypożyczenia", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
        SizedBox(height: 25),
        _picker(),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: _buttons()
          )
        )

      ]),
    );
  }

  Widget _buttons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        FlatButton(
          child: Text("Anuluj", style: TextStyle(color: Colors.white.withOpacity(0.2))),
          onPressed: () {
            widget.onCancel?.call();
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text("Zmień"),
          onPressed: _statuses.length > _currentValue ? () {
            if (_statuses.length > _currentValue) {
              widget.onAccept?.call(_statuses[_currentValue]);
              Navigator.of(context).pop();

            }
          } : null
        )
      ],
    );
  }

  Widget _picker() {
    if (_statuses.isEmpty) {
      return Expanded(
        child: Center(child: Text("Brak dostępnych akcji"),)
      );
    }
    return Container(
      height: 100,
      child: CupertinoPicker(
        looping: true,
        backgroundColor: Colors.transparent,
        itemExtent: 50,
        onSelectedItemChanged: (idx) {
          setState(() {
            _currentValue = idx;
          });
        },
        children: _statuses.map((status) {
          return Text(status.action(), style: TextStyle(color: getBorrowStatusColor(status), fontSize: 30));
        }).toList()
      ),
    );
  }
}

class BorrowStatusHelper {

  // returns list of possible following actions to current status
  static List<BorrowStatus> getAvailableActions(BorrowStatus currentStatus) {
    switch (currentStatus) {
      case BorrowStatus.CREATED: return [BorrowStatus.ACCEPTED, BorrowStatus.DECLINED];
      case BorrowStatus.ACCEPTED: return [BorrowStatus.BORROWED, BorrowStatus.DECLINED];
      case BorrowStatus.DECLINED: return [BorrowStatus.ACCEPTED, BorrowStatus.CREATED];
      case BorrowStatus.BORROWED: return [BorrowStatus.RETURNED];
      case BorrowStatus.CANCELED: return [];
      case BorrowStatus.RETURNED: return [];
      default: return [];
    }
  }
}
