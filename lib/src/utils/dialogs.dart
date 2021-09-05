
import 'package:flutter/cupertino.dart';

class Dialogs {
  static void alert(BuildContext context,
      {String title = "", String message = ""}) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            content: Container(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                message,
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15),
              ),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Aceptar'),
              )
            ],
          );
        });
  }
  static Future<bool> confirm(BuildContext context,
      {String title = "", String message = ""}) {
    return showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            content: Container(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                message,
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15),
              ),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('Cancelar'),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('Aceptar'),
              )
            ],
          );
        });
  }
}
