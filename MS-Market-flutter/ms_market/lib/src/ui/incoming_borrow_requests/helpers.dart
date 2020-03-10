import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:ms_market/src/models/borrow_request.dart';

Color getBorrowStatusColor(BorrowStatus status) {
    switch(status) {
      case BorrowStatus.ACCEPTED: return Colors.green;
      case BorrowStatus.DECLINED: return Colors.red;
      case BorrowStatus.CREATED: return Colors.grey;
      case BorrowStatus.CANCELED: return Colors.grey.withOpacity(0.3);
      case BorrowStatus.BORROWED: return Colors.yellow.shade500;
      case BorrowStatus.RETURNED: return Colors.grey;
      default: return Colors.transparent;
    }
  }