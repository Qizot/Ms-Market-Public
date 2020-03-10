

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ms_market/src/models/user.dart';

class ProfileCard extends StatelessWidget {
  final User user;

  ProfileCard({this.user});

  @override
  Widget build(BuildContext context) {
    if (user == null) return Container();

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(Icons.account_circle, size: 75),
            _info(),
          ],
        ),
      ),
    );
  }

  _info() {
    final nameStyle = TextStyle(fontSize: 25, fontWeight: FontWeight.w600);
    final infoStyle = TextStyle(fontSize: 16, color: Colors.grey[400]);
    return Column(
      children: <Widget>[
        Text('${user.name} ${user.surname}', style: nameStyle),
        SizedBox(height: 10),
        Text(user.email, style: infoStyle),
        SizedBox(height: 10),
        Text('${user.dormitory} ${user.room}', style: infoStyle)

      ],
    );
  }

}