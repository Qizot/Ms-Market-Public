

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ms_market/src/ui/home/home_drawer.dart';
import 'package:ms_market/src/ui/home/tabs/contact_screen.dart';
import 'package:ms_market/src/ui/home/tabs/news_screen.dart';
import 'package:ms_market/src/ui/home/tabs/welcome_screen.dart';
import 'package:ms_market/src/utils/colors.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: HomeDrawer(),
        backgroundColor: Theme.of(context).accentColor.withAlpha(60),
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          bottom: TabBar(
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Theme.of(context).accentColor,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              color: darkAccentColor
            ),
            tabs: _tabs()
          )
        ),
        body: TabBarView(
          children: <Widget>[
            WelcomeScreen(),
            NewsScreen(),
            ContactScreen(),
          ],
        )
      )
    );
  }

  _tabs() => [
    Tab(
      child: Align(
        alignment: Alignment.center,
        child: Text("Witaj")
      )
    ),
    Tab(
      child: Align(
        alignment: Alignment.center,
        child: Text("Aktualności")
      )
    ),
    Tab(
      child: Align(
        alignment: Alignment.center,
        child: Text("Kontakt")
      )
    ),
  ];

  
}