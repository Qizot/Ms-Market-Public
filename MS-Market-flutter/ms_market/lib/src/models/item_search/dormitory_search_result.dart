
import 'package:ms_market/src/models/item_search/item_search_result.dart';

class DormitorySearchResult {
  String dormitory;
  List<ItemSearchResult> results;

  DormitorySearchResult({this.dormitory, this.results});

  DormitorySearchResult.fromJson(Map<String, dynamic> json) {
    dormitory = json['dormitory'];
    if (json['results'] != null) {
      results = new List<ItemSearchResult>();
      json['results'].forEach((v) {
        results.add(ItemSearchResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dormitory'] = this.dormitory;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}