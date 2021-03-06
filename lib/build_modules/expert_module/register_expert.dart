import 'dart:io';

import 'package:expert/build_modules/expert_module/combo_especialidad.dart';
import 'package:expert/build_modules/expert_module/init_expert.dart';
import 'package:expert/src/api/auth_api_provider.dart';
import 'package:expert/src/managers/file_picker_manager.dart';
import 'package:expert/src/models/requests/sign_up_request.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterExpertModule extends StatefulWidget {
  @override
  _RegisterExpertModuleState createState() => _RegisterExpertModuleState();
}

class _RegisterExpertModuleState extends State<RegisterExpertModule> {
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _speciality = TextEditingController();
  final TextEditingController _firstPass = TextEditingController();
  final TextEditingController _lastPass = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  String _siglas = "";
  bool isBusy = false;
  Future<String> imageFilePathAux;
  pickImageFromGallery() {
    setState(() {
      imageFilePathAux = FilePickerManager.pickImageFromGallery();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Regístrate Experto"),
          centerTitle: true,
          leading: BackButton(
            color: Colors.white,
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => InitExpertModule()));
            },
          ),
        ),
        body: GestureDetector(
          onTap: () {
            final FocusScopeNode focus = FocusScope.of(context);
            if (!focus.hasPrimaryFocus && focus.hasFocus) {
              FocusManager.instance.primaryFocus.unfocus();
            }
          },
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Form(
              key: _form,
              child: ListView(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child:FutureBuilder<String>(
                      future: imageFilePathAux,
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.data != null) {
                          return  Center(
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  backgroundImage: AssetImage(snapshot.data),
                                  backgroundColor: Colors.grey,
                                  radius: 50,
                                  //child: Image.asset("assets/programmer.png"),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: IconButton(
                                    icon: Icon(Icons.camera_alt, color: Colors.pink[900],),
                                    onPressed: () {
                                      pickImageFromGallery();

                                    },
                                  ),
                                )
                              ],
                            ),
                          );
                        } else if (snapshot.error != null) {
                          return const Text(
                            'No se pudo abrir la galería',
                            textAlign: TextAlign.center,
                          );
                        } else {
                          return  Center(
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.amber,
                                  child: Text(
                                    _siglas,
                                    style: TextStyle(fontSize: 40),
                                  ),
                                  radius: 50,
                                  //child: Image.asset("assets/programmer.png"),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: IconButton(
                                    icon: Icon(Icons.camera_alt, color: Colors.pink[900],),
                                    onPressed: () {
                                      pickImageFromGallery();

                                    },
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: _firstName,
                      validator: (val) {
                        if (val.isEmpty) return 'Este campo es requerido';
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: "Nombres",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value){
                        String fistLetter = "" ;
                        String lastLetter = "";
                        List<String> aa = value.split(" ");
                        if(aa.length > 0){
                          fistLetter = aa[0].substring(0,1).toUpperCase();
                        }
                        List<String> bb = _lastName.text.split(" ");
                        if(bb.length > 0){
                          lastLetter = bb[0].substring(0,1).toUpperCase();
                        }
                        String oChars = "$fistLetter$lastLetter";
                        print(oChars);
                        setState(() {
                          _siglas =oChars;
                        });
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: _lastName,
                      validator: (val) {
                        if (val.isEmpty) return 'Este campo es requerido';
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: "Apellidos",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value){
                        String fistLetter = "" ;
                        String lastLetter = "";
                        List<String> aa = _firstName.text.split(" ");
                        if(aa.length > 0){
                          fistLetter = aa[0].substring(0,1).toUpperCase();
                        }
                        List<String> bb = value.split(" ") ;
                        print(bb);
                        if(bb.length > 0){
                          lastLetter = bb[0].substring(0,1).toUpperCase();
                        }
                        String oChars = "$fistLetter$lastLetter" ;
                        print(oChars);
                        setState(() {
                          _siglas =oChars;
                        });
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: _email,
                      validator: (val) {
                        if (val.isEmpty) return 'Este campo es requerido';
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      decoration: InputDecoration(
                        labelText: "Correo",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: _speciality,
                      validator: (val) {
                        if (val.isEmpty) return 'Este campo es requerido';
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      readOnly: true,
                      textCapitalization: TextCapitalization.none,
                      decoration: InputDecoration(
                        labelText: "Especialidad",
                        suffixIcon: Icon(Icons.keyboard_arrow_down),
                        border: OutlineInputBorder(),
                      ),
                      onTap: () {

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => WpComboEspecialidad())).then((value) {
                           if(value != null) {
                             setState(() {
                               _speciality.text = value;
                             });
                           }
                        });

                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: _phone,
                      validator: (val) {
                        if (val.isEmpty) return 'Este campo es requerido';
                        return null;
                      },
                      keyboardType: TextInputType.phone,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      decoration: InputDecoration(
                        labelText: "Celular",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: _firstPass,
                      validator: (val) {
                        if (val.isEmpty) return 'Este campo es requerido';
                        return null;
                      },
                      keyboardType: TextInputType.visiblePassword,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      decoration: InputDecoration(
                        labelText: "Contraseña",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: _lastPass,
                      validator: (val) {
                        if (val.isEmpty) return 'Este campo es requerido';
                        return null;
                      },
                      keyboardType: TextInputType.visiblePassword,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      decoration: InputDecoration(
                        labelText: "Repetir contraseña",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    height: 50,
                    child: FlatButton(
                      color: Colors.pink[900],
                      textColor: Colors.amber,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Iniciar sesión", style: TextStyle(fontSize: 18),),
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
                          final imageFilePath = await imageFilePathAux;
                          final request = SignUpRequest(
                            email: _email.text,
                            name: _firstName.text,
                            fullName: _lastName.text,
                            specialty: _speciality.text,
                            phone: _phone.text,
                            password: _firstPass.text,
                            file: imageFilePath != null ? File(imageFilePath) : null,
                            role: 'E',
                          );
                          print(request.toJson());

                          final success = await auth.register(context, request);
                          setState(() {
                            isBusy = false;
                          });
                          if (success) {

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => InitExpertModule()));
                          }
                        }

                      },
                    ),
                  ),
                ],
              ),
            )
          ),
        )
    );
  }
}
