import 'dart:async';

import 'package:expert/src/managers/session_manager.dart';
import 'package:expert/src/managers/token_manager.dart';
import 'package:expert/src/pages/home_page.dart';
import 'package:expert/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'expert/pages/list_students.dart';
import 'home_page.dart';
import 'student/Pages/list_experts.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    redirectToPage();
  }

  void redirectToPage() async {
    Widget nextPage = HomePage();
    final token = await TokenManager.getInstance().getToken();
    final session = await SessionManager.getInstance();
    final role = session.getRole();
    if (token != null && role != null) {
      if (role == "U") {
        nextPage = ExpertoList();
      } else {
        nextPage = StudentList();
      }
    }

    Timer(
        Duration(seconds: 3),
        () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => nextPage),
              (Route<dynamic> route) => false,
            ));
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return Scaffold(
      body: Align(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: responsive.hp(30),
            ),
            Image.asset(
              'assets/expert2.png',
              color: Colors.green,
            ),
            SizedBox(
              height: responsive.hp(6),
            ),
            SpinKitRipple(color: Colors.green),
            SizedBox(
              height: responsive.hp(20),
            ),
          ],
        ),
      ),
    );
  }
}
