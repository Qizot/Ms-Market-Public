
import 'package:flutter/material.dart';
import 'package:ms_market/src/models/dormitory.dart';
import 'package:ms_market/src/models/item_search/dormitory_search_result.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:ms_market/src/resources/services/dormitories.dart';
import 'package:ms_market/src/utils/colors.dart';

class DormitoryCard extends StatelessWidget {
  final DormitorySearchResult result;
  final Dormitory dormitory;

  DormitoryCard({@required this.result}): dormitory = DormitoriesService.instance.findByName(result.dormitory);

  String plural(int i) {
    if (i == 1)
      return "przedmiot!";
    if (2 <= i && i <= 4)
      return "przedmioty!";
    return "przedmiotów!";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      child: Card(
        color: darkAccentColor,
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(dormitory.fullname),
              subtitle: Text('Znaleziono ${result.results.length} ${plural(result.results.length)}'),
            )
          ],
        )
      ),
    );
  }
}