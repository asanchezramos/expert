import 'dart:io';

import 'package:expert/src/api/auth_api_provider.dart';
import 'package:expert/src/managers/file_picker_manager.dart';
import 'package:expert/src/models/requests/sign_up_request.dart';
import 'package:expert/src/utils/responsive.dart';
import 'package:flutter/material.dart';

class RegisterExpertPage extends StatefulWidget {
  const RegisterExpertPage({Key key}) : super(key: key);

  @override
  _RegisterExpertPageState createState() => _RegisterExpertPageState();
}

class _RegisterExpertPageState extends State<RegisterExpertPage> {
  Future<String> imageFilePath;
  pickImageFromGallery() {
    setState(() {
      imageFilePath = FilePickerManager.pickImageFromGallery();
    });
  }

  Widget _buildLogo(String path) {
    return Container(
      width: 100.0,
      height: 100.0,
      margin: EdgeInsets.only(top: 30.0),
      child: InkWell(
        onTap: () {
          pickImageFromGallery();
        },
        child: CircleAvatar(
          radius: 30.0,
          backgroundImage: AssetImage(path),
          backgroundColor: Colors.grey,
        ),
      ),
    );
  }

  Widget _logo() {
    return FutureBuilder<String>(
      future: imageFilePath,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return _buildLogo(snapshot.data);
        } else if (snapshot.error != null) {
          return const Text(
            'No se pudo abrir la galería',
            textAlign: TextAlign.center,
          );
        } else {
          return _buildLogo('assets/teacher.png');
        }
      },
    );
  }

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
                  height: responsive.hp(3.0),
                ),
                _logo(),
                SizedBox(
                  height: responsive.hp(4.0),
                ),
                FormExpertRegister(imageFilePath: imageFilePath),
                SizedBox(
                  height: responsive.hp(5.0),
                ),
                ReturnLoginExpert(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class Logo extends StatelessWidget {
//   const Logo({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final Responsive responsive = Responsive.of(context);
//     return Container(
//       height: responsive.hp(20.0),
//       width: double.infinity,
//       child: Image(
//         image: AssetImage('assets/teacher.png'),
//       ),
//     );
//   }
// }

class FormExpertRegister extends StatefulWidget {
  final Future<String> imageFilePath;
  const FormExpertRegister({Key key, this.imageFilePath}) : super(key: key);

  @override
  _FormExpertRegisterState createState() => _FormExpertRegisterState();
}

class _FormExpertRegisterState extends State<FormExpertRegister> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  final TextEditingController _specialty = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  bool isBusy = false;

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return Form(
      key: _form,
      child: Container(
        constraints: BoxConstraints(maxWidth: 280, minWidth: 280),
        child: Column(
          children: <Widget>[
            Text(
              'Registro Experto',
              style: TextStyle(
                  fontWeight: FontWeight.w400, fontSize: responsive.ip(2.5)),
            ),
            SizedBox(
              height: responsive.hp(2.5),
            ),
            TextFormField(
              controller: _email,
              validator: (val) {
                if (val.isEmpty) return 'Este campo es requerido';
                return null;
              },
              decoration: InputDecoration(
                // border: InputBorder.none,
                hintText: 'CORREO',
              ),
            ),
            SizedBox(
              height: responsive.hp(0),
            ),
            TextFormField(
              controller: _fullName,
              validator: (val) {
                if (val.isEmpty) return 'Este campo es requerido';
                return null;
              },
              decoration: InputDecoration(
                  // border: InputBorder.none,
                  hintText: 'NOMBRE Y APELLIDO'),
            ),
            TextFormField(
              controller: _specialty,
              validator: (val) {
                if (val.isEmpty) return 'Este campo es requerido';
                return null;
              },
              decoration: InputDecoration(
                  // border: InputBorder.none,
                  hintText: 'ESPECIALIDAD'),
            ),
            TextFormField(
              controller: _phone,
              validator: (val) {
                if (val.isEmpty) return 'Este campo es requerido';
                return null;
              },
              decoration: InputDecoration(
                  // border: InputBorder.none,
                  hintText: 'NUMERO TELEFÓNICO'),
            ),
            SizedBox(
              height: responsive.hp(0),
            ),
            TextFormField(
              controller: _pass,
              validator: (val) {
                if (val.isEmpty) return 'Este campo es requerido';
                return null;
              },
              obscureText: true,
              decoration: InputDecoration(
                  // border: InputBorder.none,
                  hintText: 'CONTRASEÑA'),
            ),
            SizedBox(
              height: responsive.hp(0),
            ),
            TextFormField(
              controller: _confirmPass,
              obscureText: true,
              validator: (val) {
                if (val.isEmpty) return 'Este campo es requerido';
                if (val != _pass.text) return 'Not Match';
                return null;
              },
              decoration: InputDecoration(
                  // border: InputBorder.none,
                  hintText: 'REPETIR CONTRASEÑA'),
            ),
            SizedBox(
              height: responsive.hp(5.0),
            ),
            InkWell(
              onTap: () async {
                if (_form.currentState.validate() && !isBusy) {
                  setState(() {
                    isBusy = true;
                  });
                  final auth = AuthApiProvider();
                  final imageFilePath = await widget.imageFilePath;
                  final request = SignUpRequest(
                    email: _email.text,
                    fullName: _fullName.text,
                    specialty: _specialty.text,
                    phone: _phone.text,
                    password: _pass.text,
                    file: imageFilePath != null ? File(imageFilePath) : null,
                    role: 'E',
                  );
                  final success = await auth.register(context, request);
                  setState(() {
                    isBusy = false;
                  });
                  if (success) {
                    Navigator.pop(context);
                  }
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
                        'Registrar',
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

class ReturnLoginExpert extends StatelessWidget {
  const ReturnLoginExpert({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Ya tengo una cuenta, '),
        InkWell(
            onTap: () {
              Navigator.pushNamed(context, 'LoginExpertPage');
            },
            child: Text(
              'Iniciar Sesión',
              style: TextStyle(fontWeight: FontWeight.w900),
            ))
      ],
    );
  }
}
