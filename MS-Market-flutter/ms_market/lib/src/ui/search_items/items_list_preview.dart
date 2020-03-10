

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ms_market/src/models/item_search/dormitory_search_result.dart';
import 'package:ms_market/src/resources/services/dormitories.dart';
import 'package:ms_market/src/ui/common/item_card.dart';
import 'package:ms_market/src/ui/common/slide_page_transition.dart';
import 'package:ms_market/src/ui/foreign_item/foreign_item_page.dart';
import 'package:ms_market/src/utils/colors.dart';

class ItemsListPreview extends StatelessWidget {
  final DormitorySearchResult result;

  ItemsListPreview({@required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DormitoriesService.instance.findByName(result.dormitory).fullname, style: TextStyle(color: Colors.grey[600])),
        centerTitle: true,
      ),
      backgroundColor: darkAccentColor,
      body: Container(
        padding: EdgeInsets.all(10),
        child: _itemsList()
      )
    );
  }

  Widget _itemsList() {
    return ListView.builder(
      itemCount: result.results.length,
      itemBuilder: (context, idx) => 
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              SlideLeftRoute(page: ForeignItemPage(itemId: result.results[idx].item.id))
            );
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            child: ItemCard(item: result.results[idx].item)
          ),
        ),
    );
  }
}