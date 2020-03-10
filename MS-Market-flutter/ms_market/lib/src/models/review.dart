

import 'package:ms_market/src/models/item/item.dart';
import 'package:ms_market/src/models/item/rating.dart';

class Review {
  String id;
  Item item;
  Rating rating;

  Review({this.id, this.item, this.rating});

  Review.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['item'] != null) {
      item = Item.fromJson(json['item']);
    }
    if (json['rating'] != null) {
      rating = Rating.fromJson(json['rating']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['item'] = this.item?.toJson();
    data['rating'] = this.rating?.toJson();
    return data;
  }
}