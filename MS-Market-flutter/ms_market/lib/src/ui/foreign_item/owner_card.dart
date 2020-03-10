import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ms_market/src/models/user.dart';
import 'package:ms_market/src/resources/services/dormitories.dart';
import 'package:ms_market/src/utils/colors.dart';

class OwnerCard extends StatelessWidget {
  final User owner;

  final _headerStyle = TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 18);
  final _normalStyle = TextStyle(color: Colors.white, fontSize: 15);

  OwnerCard({@required this.owner});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: _info(),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: darkAccentColor.withAlpha(70),
            spreadRadius: 5,
            blurRadius: 10,
            offset: Offset(10, 10)
          )
        ]
      )
    );
  }

  Widget _info() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            children: [
              TextSpan(text: "Właścicielem jest:  ", style: _headerStyle),
              TextSpan(text: "${owner.name} ${owner.surname}", style: _normalStyle),
            ]
          )
        ),
        SizedBox(height: 10),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Akademik: ", 
                style: TextStyle(fontWeight: FontWeight.w600)
              ),
              TextSpan(
                text: DormitoriesService.instance.findByName(owner.dormitory).fullname
              ),
              TextSpan(text: "  "),
              TextSpan(
                text: "Pokój: ", 
                style: TextStyle(fontWeight: FontWeight.w600)
              ),
              TextSpan(
                text: owner.room
              )
            ]
          )
        ),
      ],
    );
  }
  
}