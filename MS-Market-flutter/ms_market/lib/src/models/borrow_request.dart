import 'package:ms_market/src/models/item/item.dart';
import 'package:ms_market/src/models/user.dart';

enum BorrowStatus {
  ACCEPTED,
  BORROWED,
  CANCELED,
  CREATED,
  DECLINED,
  RETURNED
}

BorrowStatus parseBorrowStatus(String value) {
  return BorrowStatus.values.firstWhere(
    (status) => status.toString().contains(value),
    orElse: () => null
  );
}

String formatBorrowStatus(BorrowStatus status) {
  if (status == null) {
    return null;
  }
  // enums strings are of format BorrowStatus.ACCEPTED;
  return status.toString().split(".")[1];
}

extension RedableBorrowStatus on BorrowStatus {
  String readable() {
    switch (this) {
      case BorrowStatus.ACCEPTED: return "Zaakceptowano";
      case BorrowStatus.BORROWED: return "Wypożyczono";
      case BorrowStatus.CANCELED: return "Anulowano";
      case BorrowStatus.CREATED: return "Stworzono";
      case BorrowStatus.DECLINED: return "Odrzucono";
      case BorrowStatus.RETURNED: return "Zwrócono";
      default: return "status nieznany";
    }
  }

  String action() {
    switch (this) {
      case BorrowStatus.ACCEPTED: return "Zaakceptuj";
      case BorrowStatus.BORROWED: return "Wypożycz";
      case BorrowStatus.CANCELED: return "Anuluj";
      case BorrowStatus.CREATED: return "Stworzono";
      case BorrowStatus.DECLINED: return "Odrzuć";
      case BorrowStatus.RETURNED: return "Zwróć przedmiot";
      default: return "nieznana akcja";
    }
  }
}

class BorrowRequest {
  String id;
  String itemId;
  String userId;
  DateTime createdAt;
  DateTime updatedStatusAt;
  BorrowStatus status;
  User user;
  Item item;

  BorrowRequest(
      {this.id,
      this.itemId,
      this.userId,
      this.createdAt,
      this.updatedStatusAt,
      this.status,
      this.user,
      this.item});
  
    static final keys = [ 
      'id',
      'itemId',
      'userId',
      'createdAt',
      'updatedStatusAt',
      'status',
      'user',
      'item'
    ];

  BorrowRequest.fromJson(Map<String, dynamic> json) {

    id = json['id'];
    itemId = json['itemId'];
    userId = json['userId'];
    status = parseBorrowStatus(json['status'] as String);

    if (json['createdAt'] != null) {
      createdAt = DateTime.parse(json['createdAt']);

    }
    if (json['updatedStatusAt'] != null) {
      updatedStatusAt = DateTime.parse(json['updatedStatusAt']);
    }
    if (json['user'] != null) {
      user = User.fromJson(json['user']);
    }
    if (json['item'] != null) {
      item = Item.fromJson(json['item']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['itemId'] = this.itemId;
    data['userId'] = this.userId;
    data['createdAt'] = this.createdAt?.toIso8601String();
    data['updatedStatusAt'] = this.updatedStatusAt?.toIso8601String();
    data['status'] = formatBorrowStatus(this.status);
    data['user'] = this.user?.toJson();
    data['item'] = this.item?.toJson();
    return data;
  }
}