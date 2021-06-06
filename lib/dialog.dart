import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AppDialog {
  static validationDialog(BuildContext context, String message) {
    Alert(
      context: context,
      // style: alertStyle,
      type: AlertType.warning,
      title: "Pankaj",
      desc: message,
      buttons: [
        DialogButton(
          child: Text(
            "Ok",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Color.fromRGBO(0, 179, 134, 1.0),
          radius: BorderRadius.circular(0.0),
        ),
      ],
    ).show();
  }
}
