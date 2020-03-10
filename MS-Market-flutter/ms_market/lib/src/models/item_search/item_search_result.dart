import 'package:ms_market/src/models/item/item.dart';

class ItemSearchResult {
  double score;
  Item item;

  ItemSearchResult({this.score, this.item});

  ItemSearchResult.fromJson(Map<String, dynamic> json) {
    score = json['score'];
    if (json['item'] != null) {
      item = Item.fromJson(json['item']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['score'] = this.score;
    data['item'] = this.item?.toJson();
    return data;
  }
}