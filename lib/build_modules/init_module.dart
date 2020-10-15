import 'dart:async';

import 'package:expert/build_modules/expert_module/init_expert.dart';
import 'package:expert/build_modules/researcher_module/init_researcher.dart';
import 'package:flutter/material.dart';

class InitModule extends StatefulWidget {
  @override
  _InitModuleState createState() => _InitModuleState();
}

class _InitModuleState extends State<InitModule> {
  bool isSelecion = false;
  Timer _timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(top: 200),
                child: Column(
              children: [
                Container(
                  child: Hero(
                    tag: "logo",
                    child: Image.asset("assets/logo_v2.png", width: 100,),
                  ),
                  margin: EdgeInsets.only(bottom: 10),
                ),
                Container(
                  child: Text(
                    "Juicio de Experto",
                    style: TextStyle(
                        color: Colors.pink[900],
                        fontWeight: FontWeight.bold,
                        letterSpacing: 6,
                        fontSize: 30),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "Te da la bienvenida.\n Elije la rama a la que perteneces para continuar.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            )),
            Visibility(
              visible: isSelecion,
              child: CircularProgressIndicator(),
            ),
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: OutlineButton.icon(
                      highlightedBorderColor: Colors.amber,
                      padding: EdgeInsets.all(20),
                      icon: Icon(
                        Icons.supervised_user_circle,
                        color: Colors.pink[900],
                      ),
                      label: Text(
                        "Experto",
                        style: TextStyle(color: Colors.pink[900]),
                      ),
                      onPressed: () {
                        setState(() {
                          isSelecion = true;
                        });
                        _timer = new Timer(const Duration(milliseconds: 400), () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      InitExpertModule()));
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: OutlineButton.icon(
                      highlightedBorderColor: Colors.amber,
                      padding: EdgeInsets.all(20),
                      icon: Icon(
                        Icons.featured_play_list,
                        color: Colors.pink[900],
                      ),
                      label: Text(
                        "Investigador",
                        style: TextStyle(color: Colors.pink[900]),
                      ),
                      onPressed: () {
                        setState(() {
                          isSelecion = true;
                        });
                        _timer = new Timer(const Duration(milliseconds: 400), () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      InitResearcherModule()));
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
