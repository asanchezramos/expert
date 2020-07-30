import 'package:expert/src/pages/expert/pages/certificate.dart';
import 'package:expert/src/pages/expert/pages/list_students.dart';
import 'package:expert/src/pages/expert/pages/login_expert_page.dart';
import 'package:expert/src/pages/expert/pages/register_expert_page.dart';
import 'package:expert/src/pages/splash_screen.dart';
import 'package:expert/src/pages/student/Pages/expert_resp.dart';
import 'package:expert/src/pages/student/Pages/list_experts.dart';
import 'package:expert/src/pages/student/Pages/login_student_page.dart';
import 'package:expert/src/pages/student/Pages/register_student_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // CupertinoApp
      debugShowCheckedModeBanner: false,
      title: 'Cupertino App',
      home: SplashScreen(),
      routes: {
        'StudentList': (_) => StudentList(),
        'LoginExpertPage': (_) => LoginExpertPage(),
        'LoginStudentPage': (_) => LoginStudentPage(),
        'RegisterStudentPage': (_) => RegisterStudentPage(),
        'RegisterExpertPage': (_) => RegisterExpertPage(),
        'ExpertoList': (_) => ExpertoList(),
        'ExpertResp': (_) => ExpertResp(),
        'Certificate': (_) => Certificate(),
      },
    );
  }
}
