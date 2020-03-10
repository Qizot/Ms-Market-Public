import 'package:ms_market/src/models/item/item.dart';
import 'package:ms_market/src/models/user.dart';

enum RatingValue {
  ONE,
  TWO,
  THREE,
  FOUR,
  FIVE,
}

RatingValue parseRatingValue(String value) {
  return RatingValue.values.firstWhere(
    (status) => status.toString().contains(value),
    orElse: () => null
  );
}

String formatRatingValue(RatingValue status) {
  if (status == null) {
    return null;
  }
  // enums strings are of format BorrowStatus.ACCEPTED;
  return status.toString().split(".")[1];
}

extension Number on RatingValue {
  int value() {
    switch (this) {
      case RatingValue.ONE: return 1;
      case RatingValue.TWO: return 2;
      case RatingValue.THREE: return 3;
      case RatingValue.FOUR: return 4;
      case RatingValue.FIVE: return 5;
      default: return 0;
    }
  }
}

RatingValue convertToRatingValue(int value) {
  switch (value) {
    case 1: return RatingValue.ONE;
    case 2: return RatingValue.TWO;
    case 3: return RatingValue.THREE;
    case 4: return RatingValue.FOUR;
    case 5: return RatingValue.FIVE;
    default: return null;
  }
}

class Rating {
  String id;
  String description;
  String itemId;
  String userId;
  User user;
  Item item;
  RatingValue value;

  Rating({this.id, this.description, this.itemId, this.userId, this.value});

  Rating.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    itemId = json['itemId'];
    userId = json['userId'];
    if (json['user'] != null) {
      user = User.fromJson(json['user']);
    }
    if (json['item'] != null) {
      item = Item.fromJson(json['item']);
    }
    value = parseRatingValue(json['value']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['itemId'] = this.itemId;
    data['userId'] = this.userId;
    data['user'] = this.user?.toJson();
    data['item'] = this.item?.toJson();
    data['value'] = formatRatingValue(this.value);
    return data;
  }
}