import 'package:expert/src/api/auth_api_provider.dart';
import 'package:expert/src/models/requests/login_request.dart';
import 'package:expert/src/utils/responsive.dart';
import 'package:flutter/material.dart';

import 'list_students.dart';

class LoginExpertPage extends StatelessWidget {
  const LoginExpertPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: responsive.hp(4.0),
                ),
                Logo(),
                SizedBox(
                  height: responsive.hp(7.0),
                ),
                FormExpert(),
                SizedBox(
                  height: responsive.hp(6.0),
                ),
                RegisterLogin(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Logo extends StatelessWidget {
  const Logo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return Container(
      height: responsive.hp(25.0),
      width: double.infinity,
      child: Image(
        image: AssetImage('assets/teacher.png'),
      ),
    );
  }
}

class FormExpert extends StatefulWidget {
  const FormExpert({Key key}) : super(key: key);

  @override
  _FormExpertState createState() => _FormExpertState();
}

class _FormExpertState extends State<FormExpert> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  bool isBusy = false;

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return Form(
      key: _form,
      child: Container(
        constraints: BoxConstraints(maxWidth: 300, minWidth: 300),
        child: Column(
          children: <Widget>[
            Text(
              'Iniciar sesión - Experto',
              style: TextStyle(
                  fontWeight: FontWeight.w400, fontSize: responsive.ip(2.5)),
            ),
            SizedBox(
              height: responsive.hp(4),
            ),
            TextFormField(
              controller: _email,
              validator: (val) {
                if (val.isEmpty) return 'Este campo es requerido';
                return null;
              },
              decoration: InputDecoration(
                  // border: InputBorder.none,
                  hintText: 'CORREO'),
            ),
            SizedBox(
              height: responsive.hp(2.0),
            ),
            TextFormField(
              controller: _pass,
              obscureText: true,
              validator: (val) {
                if (val.isEmpty) return 'Este campo es requerido';
                return null;
              },
              decoration: InputDecoration(
                  // border: InputBorder.none,
                  hintText: 'CONTRASEÑA'),
            ),
            SizedBox(
              height: responsive.hp(6.0),
            ),
            InkWell(
              onTap: () async {
                if (_form.currentState.validate() && !isBusy) {
                  setState(() {
                    isBusy = true;
                  });
                  final auth = AuthApiProvider();
                  final request = LoginRequest(
                    email: _email.text,
                    password: _pass.text,
                  );
                  final success = await auth.loginExpert(context, request);
                  setState(() {
                    isBusy = false;
                  });
                  if (success) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => StudentList()),
                        (Route<dynamic> route) => false);
                  }
                } else {
                  return null;
                }
              },
              child: Container(
                alignment: Alignment.center,
                height: responsive.hp(6),
                width: responsive.wp(80),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.green[700]),
                child: isBusy
                    ? SizedBox(
                        child: CircularProgressIndicator(
                            strokeWidth: 2, backgroundColor: Colors.white),
                        height: 20.0,
                        width: 20.0,
                      )
                    : Text(
                        'Ingresar',
                        style: TextStyle(
                            color: Colors.white, fontSize: responsive.ip(2)),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RegisterLogin extends StatelessWidget {
  const RegisterLogin({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Si no tienes cuenta, regístrate. '),
        InkWell(
            onTap: () {
              Navigator.pushNamed(context, 'RegisterExpertPage');
            },
            child: Text(
              'Aquí',
              style: TextStyle(fontWeight: FontWeight.w900),
            ))
      ],
    );
  }
}
