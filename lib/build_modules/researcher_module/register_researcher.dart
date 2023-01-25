import 'dart:io';

import 'package:expert/build_modules/researcher_module/init_researcher.dart';
import 'package:expert/build_modules/researcher_module/stikynotify.dart';
import 'package:expert/src/api/auth_api_provider.dart';
import 'package:expert/src/managers/file_picker_manager.dart';
import 'package:expert/src/models/requests/sign_up_request.dart';
import 'package:expert/src/utils/dialogs.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overlay_support/overlay_support.dart';

class RegisterResearcherModule extends StatefulWidget {
  @override
  _RegisterResearcherModuleState createState() =>
      _RegisterResearcherModuleState();
}

class _RegisterResearcherModuleState extends State<RegisterResearcherModule> {
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _email = TextEditingController(); 
  final TextEditingController _orcid = TextEditingController();
  final TextEditingController _firstPass = TextEditingController();
  final TextEditingController _lastPass = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  String _siglas = "";
  bool isBusy = false;
  File? imageFile;
  bool visibleFirstPass = false;
  bool visibleLastPass = false;
  pickImageFromGallery() async {
    PickedFile? photo =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(photo!.path);
    });
  }

  void _toggleFirstPass() {
    setState(() {
      visibleFirstPass = !visibleFirstPass;
    });
  }

  void _toggleLastPass() {
    setState(() {
      visibleLastPass = !visibleLastPass;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Regístrate Investigador"),
          centerTitle: true,
          leading: BackButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          InitResearcherModule()));
            },
          ),
        ),
        body: GestureDetector(
          onTap: () {
            final FocusScopeNode focus = FocusScope.of(context);
            if (!focus.hasPrimaryFocus && focus.hasFocus) {
              FocusManager.instance.primaryFocus!.unfocus();
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
                      child: (imageFile != null)
                          ? Center(
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: FileImage(imageFile!),
                                    backgroundColor: Colors.grey,
                                    radius: 50,
                                    //child: Image.asset("assets/programmer.png"),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.camera_alt,
                                      ),
                                      onPressed: () {
                                        pickImageFromGallery();
                                      },
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Center(
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
                                      icon: Icon(
                                        Icons.camera_alt,
                                      ),
                                      onPressed: () {
                                        pickImageFromGallery();
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: _firstName,
                        validator: (val) {
                          if (val!.isEmpty) return 'Este campo es requerido';
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        decoration: InputDecoration(
                          labelText: "Nombres",
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => {
                          if (imageFile == null)
                            {
                              setState(() {
                                _siglas = onBuildLettersPicture(
                                    value, _lastName.text);
                              })
                            }
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: _lastName,
                        validator: (val) {
                          if (val!.isEmpty) return 'Este campo es requerido';
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        decoration: InputDecoration(
                          labelText: "Apellidos",
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _siglas =
                                onBuildLettersPicture(_firstName.text, value);
                          });
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: _email,
                        validator: (val) {
                          if (val!.isEmpty) return 'Este campo es requerido';
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
                        controller: _orcid,
                        validator: (val) {
                          if (val!.isEmpty) return 'Este campo es requerido';
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        decoration: InputDecoration(
                          labelText: "Código ORCID",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: _firstPass,
                        validator: (val) {
                          if (val!.isEmpty) return 'Este campo es requerido';
                          return null;
                        },
                        keyboardType: TextInputType.visiblePassword,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        obscureText: visibleFirstPass,
                        decoration: InputDecoration(
                            labelText: "Contraseña",
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: _toggleFirstPass,
                              icon: Icon(visibleFirstPass
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined),
                            )),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10, bottom: 50),
                      child: TextFormField(
                        controller: _lastPass,
                        validator: (val) {
                          if (val!.isEmpty) return 'Este campo es requerido';
                          return null;
                        },
                        obscureText: visibleLastPass,
                        keyboardType: TextInputType.visiblePassword,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        decoration: InputDecoration(
                            labelText: "Repetir contraseña",
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: _toggleLastPass,
                              icon: Icon(visibleLastPass
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined),
                            )),
                      ),
                    ),
                  ],
                ),
              )),
        ),
        bottomSheet: Container(
          height: 50,
          child: ElevatedButton(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Registrarme",
                    style: TextStyle(fontSize: 18),
                  ),
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
              if (_firstPass.text != _lastPass.text) {
                Dialogs.alert(context,
                    title: "Advertencia",
                    message: "Las contraseñas no coinciden");
                return;
              }
              if (_form.currentState!.validate() && !isBusy) {
                setState(() {
                  isBusy = true;
                });
                final auth = AuthApiProvider();
                final request = SignUpRequest(
                  email: _email.text,
                  password: _firstPass.text,
                  fullName: _lastName.text,
                  name: _firstName.text,
                  phone: _phone.text,
                  specialty: "",
                  role: 'U',
                  orcid: _orcid.text
                );
                if (imageFile != null) {
                  request.file = imageFile;
                }
                final success = await auth.register(context, request);
                setState(() {
                  isBusy = false;
                });
                if (success) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              InitResearcherModule()));
                }
              }
            },
          ),
        ),
      ),
    );
  }

  String onBuildLettersPicture(firstLetterAux, secondLetterAux) {
    String fistLetter = "";
    String lastLetter = "";
    List<String> aa = firstLetterAux.split(" ");
    if (aa.length > 0 && firstLetterAux.length > 0) {
      fistLetter = aa[0].substring(0, 1).toUpperCase();
    }
    List<String> bb = secondLetterAux.split(" ");
    print(bb);
    if (bb.length > 0 && secondLetterAux.length > 0) {
      lastLetter = bb[0].substring(0, 1).toUpperCase();
    }
    String oChars = "$fistLetter$lastLetter";
    return oChars;
  }

  Future<bool> _onBackPressed() async {
    FocusScope.of(context).unfocus();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => InitResearcherModule()));
    return false;
  }
}
