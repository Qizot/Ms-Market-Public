import 'package:ms_market/src/models/borrow_request.dart';

class BorrowRequestFilter {
  int limit;
  List<BorrowStatus> statuses;

  BorrowRequestFilter({this.limit, this.statuses});

  BorrowRequestFilter.fromJson(Map<String, dynamic> json) {
    limit = json['limit'];
    if (json['statuses'] != null) {
      statuses = json['statuses'].map((v) => parseBorrowStatus(v)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['limit'] = this.limit;
    if (this.statuses != null) {
      data['statuses'] = this.statuses.map((v) => formatBorrowStatus(v)).toList();
    }
    return data;
  }
}