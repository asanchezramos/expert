import 'package:expert/src/api/auth_api_provider.dart';
import 'package:expert/src/managers/session_manager.dart';
import 'package:expert/src/pages/expert/pages/results_page.dart';
import 'package:expert/src/pages/student/Pages/results_page.dart';
import 'package:expert/src/utils/responsive.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({Key? key, required this.texto}) : super(key: key);

  final String texto;

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return Container(
      alignment: Alignment.center,
      height: responsive.hp(20),
      width: double.infinity,
      color: Colors.green,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(
                  child: ElevatedButton(
                    // splashColor: Colors.green[300],
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(18),
                    //   side: BorderSide(color: Colors.black),
                    // ),
                    onPressed: () {
                      AuthApiProvider.logout(context);
                    },
                    child: Text(
                      "Cerrar sesión",
                      style: TextStyle(
                          fontSize: responsive.ip(1.5),
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                ElevatedButton(
                  // splashColor: Colors.green[300],
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(18),
                  //   side: BorderSide(color: Colors.black),
                  // ),
                  onPressed: () async {
                    Widget nextPage;
                    SessionManager? session =
                        await SessionManager.getInstance();
                    if (session != null) {
                      final role = session.getRole();
                      if (role == "E") {
                        nextPage = ResultStudentPage();
                      } else {
                        nextPage = ResultExpertPage();
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => nextPage),
                      );
                    }
                  },
                  child: Text(
                    "Resultados",
                    style: TextStyle(
                        fontSize: responsive.ip(1.5),
                        fontWeight: FontWeight.w900),
                  ),
                ),
              ]),
          SizedBox(
            height: responsive.hp(2.0),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '$texto',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: responsive.ip(2.5),
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Header2 extends StatelessWidget {
  const Header2({Key? key, required this.texto}) : super(key: key);

  final String texto;

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return Container(
      alignment: Alignment.center,
      height: responsive.hp(20),
      width: double.infinity,
      color: Colors.green,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
            SizedBox(
              child: ElevatedButton(
                // splashColor: Colors.green[300],
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.circular(18),
                //   side: BorderSide(color: Colors.black),
                // ),
                onPressed: () {
                  AuthApiProvider.logout(context);
                },
                child: Text(
                  "Cerrar sesión",
                  style: TextStyle(
                      fontSize: responsive.ip(1.5),
                      fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ]),
          SizedBox(
            height: responsive.hp(2.0),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '$texto',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: responsive.ip(2.5),
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
