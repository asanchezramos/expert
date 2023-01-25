import 'package:expert/app.theme.dart';
import 'package:expert/build_modules/init_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //systemNavigationBarColor: Colors.blue, // navigation bar color  status bar color
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        theme: appThemeData[AppTheme.light],
        darkTheme: appThemeData[AppTheme.dark],
        debugShowCheckedModeBanner: false,
        title: 'Juicio de experto',
        home: InitModule(),
      ),
    );
  }
}
