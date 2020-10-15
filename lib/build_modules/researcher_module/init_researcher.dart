import 'dart:async';

import 'package:expert/build_modules/init_module.dart';
import 'package:expert/build_modules/researcher_module/home_researcher.dart';
import 'package:expert/build_modules/researcher_module/register_researcher.dart';
import 'package:expert/src/api/auth_api_provider.dart';
import 'package:expert/src/models/requests/login_request.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InitResearcherModule extends StatefulWidget {
  @override
  _InitResearcherModuleState createState() => _InitResearcherModuleState();
}

class _InitResearcherModuleState extends State<InitResearcherModule> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  bool isBusy = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Investigador",
          style: TextStyle(color: Colors.pink[900]),
        ),
        leading: BackButton(
          color: Colors.pink[900],
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => InitModule()));
          },
        ),
        actions: [
          Container(
            child: Hero(
              tag: "logo",
              child: Image.asset(
                "assets/logo_v2.png",
                width: 45,
              ),
            ),
            padding: EdgeInsets.only(right: 10),
          )
        ],
      ),
      body: GestureDetector(
        onTap: () {
          final FocusScopeNode focus = FocusScope.of(context);
          if (!focus.hasPrimaryFocus && focus.hasFocus) {
            FocusManager.instance.primaryFocus.unfocus();
          }
        },
        child: Form(
          key: _form,
          child: ListView(
            padding: EdgeInsets.only(left: 15, right: 15),
            children: [
              Container(
                padding: EdgeInsets.only(top: 40, bottom: 40, left: 20, right: 20),
                child: RichText(
                  text: TextSpan(text: "¡Hola investigador!",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.pink[900]),

                      children: [
                        TextSpan(text:
                        " inicia sesión con tu usuario y contraseña para acceder a multiples opciones",
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 20,
                              color: Colors.black),
                        )
                      ]),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  decoration: InputDecoration(
                    labelText: "Usuario",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  controller: _pass,
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  decoration: InputDecoration(
                    labelText: "Contraseña",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                height: 50,
                child: OutlineButton(
                  color: Colors.amber,
                  highlightedBorderColor: Colors.amber,
                  focusColor: Colors.amber,
                  hoverColor: Colors.amber,
                  highlightColor: Colors.amber,
                  textColor: Colors.pink[900],
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Iniciar sesión"),
                        Visibility(
                          visible: isBusy,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                          ),
                        ),
                        Visibility(
                          visible: isBusy,
                          child: Container(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () async {
                    if (_form.currentState.validate() && !isBusy) {
                      setState(() {
                        isBusy = true;
                      });
                      final auth = AuthApiProvider();
                      final request = LoginRequest(
                        email: _email.text,
                        password: _pass.text,
                      );
                      final success = await auth.loginStudent(context, request);
                      setState(() {
                        isBusy = false;
                      });
                      if (success) {

                        FocusScope.of(context).unfocus();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => HomeResearcherModule()));

                      }
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                height: 50,
                child: FlatButton(
                  child: Text(
                    "¿Olvidaste tu contraseña?",
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                  onPressed: () {

                  },
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_front),
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => RegisterResearcherModule()));

        },
      ),
    );
  }
}
