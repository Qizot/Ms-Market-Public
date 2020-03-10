

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ms_market/src/utils/colors.dart';

void showErrorSnackbar(BuildContext context, String message) {
  Scaffold.of(context).hideCurrentSnackBar();
  Scaffold.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.red,
    )
  );
}

void showSuccessSnackbar(BuildContext context, message) {
  Scaffold.of(context).hideCurrentSnackBar();
  Scaffold.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.green,
    )
  );
}

void showLoadingSnackbar(BuildContext context, String message) {
  Scaffold.of(context).hideCurrentSnackBar();
  Scaffold.of(context).showSnackBar(
    SnackBar(
      backgroundColor: darkAccentColor,
      content: Row(
        children: <Widget>[
          Text(message, style: TextStyle(color: Colors.white)),
          SizedBox(width: 10),
          SizedBox(height: 15, width: 15, child: CircularProgressIndicator(strokeWidth: 3))
        ],
      )
    )
  );
}