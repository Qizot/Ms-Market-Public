import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef void OnConfirm();

void showAlertDialog(BuildContext context, {
  @required String alertText,
  @required String descriptionText,
  @required String confirmText,
  @required String cancelText,
  @required OnConfirm onConfirm,
}) {
    // set up the buttons
    Widget continueButton = FlatButton(
      child: Text(confirmText),
      color: Colors.red,
      onPressed: () {
        onConfirm();
        Navigator.of(context).pop();
      }
    );

    Widget cancelButton = FlatButton(
      child: Text(cancelText),
      onPressed: () => Navigator.of(context).pop(),
    );

    AlertDialog alert = AlertDialog(
      title: Text(alertText),
      content: Text(descriptionText),
      actions: [
        continueButton,
        cancelButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }