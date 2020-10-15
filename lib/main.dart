import 'package:expert/build_modules/init_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //systemNavigationBarColor: Colors.blue, // navigation bar color
    statusBarColor: Colors.pink[900], // status bar color
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        theme: ThemeData(
          primaryIconTheme: IconThemeData(
            color: Colors.pink[900],
          ),
          primaryColor: Colors.pink[900],
          accentColor: Colors.amber,
        ),
        debugShowCheckedModeBanner: false,
        title: 'Juicio de experto',
        home:  InitModule(),
      ),
    );
  }
}
