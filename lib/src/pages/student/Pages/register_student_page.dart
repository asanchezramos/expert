import 'dart:io';

import 'package:expert/src/api/auth_api_provider.dart';
import 'package:expert/src/managers/file_picker_manager.dart';
import 'package:expert/src/models/requests/sign_up_request.dart';
import 'package:expert/src/utils/responsive.dart';
import 'package:flutter/material.dart';

class RegisterStudentPage extends StatefulWidget {
  const RegisterStudentPage({Key? key}) : super(key: key);

  @override
  _RegisterStudentPageState createState() => _RegisterStudentPageState();
}

class _RegisterStudentPageState extends State<RegisterStudentPage> {
  Future<String?>? imageFilePath;
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
    return FutureBuilder<String?>(
      future: imageFilePath,
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return _buildLogo(snapshot.data!);
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
                  height: responsive.hp(2.0),
                ),
                _logo(),
                SizedBox(
                  height: responsive.hp(6.5),
                ),
                FormStudentRegister(imageFilePath: imageFilePath),
                SizedBox(
                  height: responsive.hp(3.5),
                ),
                ReturnLoginStudent(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return Container(
      height: responsive.hp(25.0),
      width: double.infinity,
      child: Image(
        image: AssetImage('assets/programmer.png'),
      ),
    );
  }
}

class FormStudentRegister extends StatefulWidget {
  final Future<String?>? imageFilePath;
  const FormStudentRegister({Key? key, this.imageFilePath}) : super(key: key);

  @override
  _FormStudentRegisterState createState() => _FormStudentRegisterState();
}

class _FormStudentRegisterState extends State<FormStudentRegister> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _specialty = TextEditingController();
  final TextEditingController _fullName = TextEditingController();
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
              'Registro Estudiante',
              style: TextStyle(
                  fontWeight: FontWeight.w400, fontSize: responsive.ip(2.5)),
            ),
            SizedBox(
              height: responsive.hp(2.5),
            ),
            TextFormField(
              controller: _email,
              validator: (val) {
                if (val!.isEmpty) return 'Este campo es requerido';
                return null;
              },
              decoration: InputDecoration(
                  // border: InputBorder.none,
                  hintText: 'CORREO'),
            ),
            TextFormField(
              controller: _fullName,
              validator: (val) {
                if (val!.isEmpty) return 'Este campo es requerido';
                return null;
              },
              decoration: InputDecoration(
                  // border: InputBorder.none,
                  hintText: 'NOMBRE Y APELLIDOS'),
            ),
            TextFormField(
              controller: _specialty,
              validator: (val) {
                if (val!.isEmpty) return 'Este campo es requerido';
                return null;
              },
              decoration: InputDecoration(
                  // border: InputBorder.none,
                  hintText: 'CARRERA'),
            ),
            TextFormField(
              controller: _phone,
              validator: (val) {
                if (val!.isEmpty) return 'Este campo es requerido';
                return null;
              },
              decoration: InputDecoration(
                  // border: InputBorder.none,
                  hintText: 'TELÉFONO'),
            ),
            SizedBox(
              height: responsive.hp(0),
            ),
            TextFormField(
              controller: _pass,
              validator: (val) {
                if (val!.isEmpty) return 'Este campo es requerido';
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
                if (val!.isEmpty) return 'Este campo es requerido';
                if (val != _pass.text) return 'Not Match';
                return null;
              },
              decoration: InputDecoration(
                  // border: InputBorder.none,
                  hintText: 'REPETIR CONTRASEÑA'),
            ),
            SizedBox(
              height: responsive.hp(6.0),
            ),
            InkWell(
              onTap: () async {
                if (_form.currentState!.validate() && !isBusy) {
                  setState(() {
                    isBusy = true;
                  });
                  final imageFilePath = await widget.imageFilePath;
                  final auth = AuthApiProvider();
                  final request = SignUpRequest(
                    email: _email.text,
                    password: _confirmPass.text,
                    fullName: _fullName.text,
                    phone: _phone.text,
                    specialty: _specialty.text,
                    role: 'U',
                  );
                  if (imageFilePath != null) {
                    request.file = File(imageFilePath);
                  }
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

class ReturnLoginStudent extends StatelessWidget {
  const ReturnLoginStudent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Ya tengo una cuenta, '),
        InkWell(
            onTap: () {
              Navigator.pushNamed(context, 'LoginStudentPage');
            },
            child: Text(
              'Iniciar Sesión',
              style: TextStyle(fontWeight: FontWeight.w900),
            ))
      ],
    );
  }
}
