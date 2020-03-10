import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ms_market/src/utils/colors.dart';
import 'package:ms_market/src/bloc/auth_bloc/bloc.dart';

class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: darkAccentColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            _createHeader(),
            _createDrawerItem(
                icon: Icons.account_circle, text: "Twój profil", onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/profile');
                }),
            _createDrawerItem(
                icon: Icons.list, text: "Twoje przedmioty", onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/owner-items');
                }),
            _createDrawerItem(
                icon: Icons.group_add, text: "Prośby o wypożyczenie", onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed("/borrow-requests");
                }),
            _createDrawerItem(
                icon: Icons.layers, text: "Wypożyczone przedmioty", onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed("/borrowed-items");
               }),
            _createDrawerItem(
              icon: Icons.search,
              text: "Szukaj przedmiotów",
              onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed("/search-items");
              },
            ),
            Divider(),
            Align(
              alignment: Alignment.bottomCenter,
              child: _createDrawerItem(
              icon: Icons.exit_to_app,
              text: "Wyloguj się",
              onTap: () {
                Navigator.of(context).pop();
                BlocProvider.of<AuthBloc>(context).add(AuthLogout());
                Navigator.of(context).pushReplacementNamed("/login");
              },
            ),
            )
          ],
        ),
      ),
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill, image: AssetImage('assets/drawer.jpg'))),
        child: Stack(children: <Widget>[
          Positioned(
              bottom: 12.0,
              left: 16.0,
              child: Text("MS Market",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500))),
        ]));
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
