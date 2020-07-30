import 'dart:io';

import 'package:expert/src/api/solicitude_api_provider.dart';
import 'package:expert/src/models/expert_entity.dart';
import 'package:expert/src/models/requests/solicitude_request.dart';
import 'package:expert/src/pages/student/widgets/header.dart';
import 'package:expert/src/utils/responsive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactExpert extends StatelessWidget {
  final ExpertEntity expertEntity;
  const ContactExpert({Key key, this.expertEntity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Header(
              texto: 'Contacto con el Experto',
            ),
            SizedBox(
              height: responsive.hp(10),
            ),
            expertContact(context)
          ],
        ),
        //bottomNavigationBar: NavigatorN(),
      ),
    );
  }

  Widget expertContact(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return Container(
      constraints: BoxConstraints(
          minWidth: responsive.wp(85), maxWidth: responsive.wp(85)),
      height: responsive.hp(50),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.grey[200]),
      child: DataExpert(
        expertEntity: expertEntity,
      ),
    );
  }
}

class DataExpert extends StatefulWidget {
  const DataExpert({Key key, this.expertEntity}) : super(key: key);
  final ExpertEntity expertEntity;

  @override
  _DataExpertState createState() => _DataExpertState();
}

class _DataExpertState extends State<DataExpert> {
  File _repositoryFile;
  File _investigationFile;
  bool isBusy = false;

  Future getFile() async {
    try {
      File file = await FilePicker.getFile(
        type: FileType.custom,
      );
      return file;
    } catch (e) {
      print("Error while picking the file: " + e.toString());
    }
  }

  _launchURL() async {
    const url =
        'https://drive.google.com/drive/folders/101SIsDTw4ZKzjANtXUrKFXKhHUF3nlX9';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return Padding(
      padding: const EdgeInsets.all(
        20,
      ),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: responsive.hp(2.0),
              ),
              Text(
                'Nombre: ' + widget.expertEntity.fullName,
                style: TextStyle(fontSize: responsive.ip(1.7)),
              ),
              Text(
                'Especialista: ' + widget.expertEntity.specialty,
                style: TextStyle(fontSize: responsive.ip(1.7)),
              ),
              SizedBox(
                height: responsive.hp(3.5),
              ),
              Text(
                'Abrir Repositorio',
                style: TextStyle(fontSize: responsive.ip(2.5)),
              ),
              SizedBox(
                height: responsive.hp(1.0),
              ),
              InkWell(
                onTap: () async {
                  final file = await getFile();
                  setState(() {
                    _repositoryFile = file;
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  height: responsive.hp(5),
                  width: responsive.wp(40),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.green),
                  child: Row(
                    mainAxisAlignment: _repositoryFile != null
                        ? MainAxisAlignment.spaceAround
                        : MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Repositorio',
                        style: TextStyle(color: Colors.white),
                      ),
                      _repositoryFile != null
                          ? Icon(
                              Icons.check,
                              color: Colors.white,
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: responsive.hp(2),
              ),
              InkWell(
                onTap: () async {
                  final file = await getFile();
                  setState(() {
                    _investigationFile = file;
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  height: responsive.hp(5),
                  width: responsive.wp(40),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.green),
                  child: Row(
                    mainAxisAlignment: _investigationFile != null
                        ? MainAxisAlignment.spaceAround
                        : MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Investigación',
                        style: TextStyle(color: Colors.white),
                      ),
                      _investigationFile != null
                          ? Icon(
                              Icons.check,
                              color: Colors.white,
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: responsive.hp(2),
              ),
              RaisedButton(
                onPressed: _launchURL,
                child: Text('Respositorio \n de matrices'),
              ),
              SizedBox(
                height: responsive.hp(2),
              ),
              InkWell(
                onTap: () async {
                  if (!isBusy) {
                    setState(() {
                      isBusy = true;
                    });
                    final request = SolicitudeRequest(
                      investigation: _investigationFile,
                      repository: _repositoryFile,
                      expertId: widget.expertEntity.id,
                      status: 'P',
                    );
                    final success =
                        await SolicitudeApiProvider.requestSolicitude(
                      request,
                      context,
                    );
                    setState(() {
                      isBusy = false;
                    });
                    if (success) {
                      Navigator.pop(context);
                    } else {
                      // Show error
                    }
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  height: responsive.hp(5),
                  width: responsive.wp(43),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey),
                  child: isBusy
                      ? SizedBox(
                          child: CircularProgressIndicator(
                              strokeWidth: 2, backgroundColor: Colors.white),
                          height: 15.0,
                          width: 15.0,
                        )
                      : Text(
                          'Enviar',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: responsive.wp(5),
          ),
          Column(
            children: <Widget>[
              SizedBox(
                height: responsive.hp(2.0),
              ),
              Container(
                height: responsive.hp(20),
                width: responsive.wp(25),
                //color: Colors.white,
                child: widget.expertEntity.photo != ""
                    ? Image.network(
                        widget.expertEntity.photo,
                      )
                    : SizedBox(),
              ),
              SizedBox(
                height: responsive.hp(5),
              ),
              Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text('Contactar'),
                                content: Text(
                                    'Teléfono: ' + widget.expertEntity.phone),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              ));
                    },
                    child: Container(
                        alignment: Alignment.center,
                        height: responsive.hp(8.5),
                        width: responsive.wp(15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            color: Colors.green),
                        child: Icon(
                          Icons.phone_iphone,
                          color: Colors.white,
                        )),
                  ),
                  SizedBox(height: responsive.hp(0.5)),
                  Text(
                    'Contactar',
                    style: TextStyle(
                        fontSize: responsive.ip(2),
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
