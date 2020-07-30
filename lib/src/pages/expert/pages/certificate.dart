import 'dart:io';

import 'package:expert/src/api/answer_api_provider.dart';
import 'package:expert/src/models/requests/answer_request.dart';
import 'package:expert/src/pages/expert/pages/list_students.dart';
import 'package:expert/src/pages/student/widgets/header.dart';
import 'package:expert/src/utils/responsive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Solo es visual xd no funciona :v

class Certificate extends StatelessWidget {
  final solicitudeId;
  const Certificate({Key key, this.solicitudeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Header2(
                  texto: 'Certificado de validez',
                ),
                SizedBox(
                  height: responsive.hp(10),
                ),
                Container(
                  constraints: BoxConstraints(
                      minWidth: responsive.wp(85), maxWidth: responsive.wp(85)),
                  height: responsive.hp(50),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[200]),
                  child: DataExpert(solicitudeId: solicitudeId),
                )
              ],
            ),
          ),
          //bottomNavigationBar: NavigatorN(),
        ),
      ),
    );
  }
}

class DataExpert extends StatefulWidget {
  const DataExpert({Key key, this.solicitudeId}) : super(key: key);
  final solicitudeId;
  @override
  _DataExpertState createState() => _DataExpertState();
}

class _DataExpertState extends State<DataExpert> {
  File _repositoryFile;
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

  final TextEditingController _comments = TextEditingController();
  bool isBusy = false;

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return Padding(
      padding: const EdgeInsets.all(
        20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: responsive.hp(2.0),
              ),
              Text(
                'Abrir Certificado',
                style: TextStyle(fontSize: responsive.ip(3.5)),
              ),
              SizedBox(
                height: responsive.hp(2.0),
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
                        'Certificado',
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
              Container(
                height: responsive.hp(15),
                width: responsive.wp(50),
                color: Colors.white54,
                child: TextField(
                  controller: _comments,
                  decoration: InputDecoration(
                    labelText: 'Comentario',
                    hintText: 'Escriba su comentario',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 10,
                ),
              ),
              SizedBox(
                height: responsive.hp(4),
              ),
              InkWell(
                onTap: () async {
                  if (!isBusy) {
                    setState(() {
                      isBusy = true;
                    });
                    final answerRequest = AnswerRequest(
                      file: _repositoryFile,
                      comments: _comments.text,
                      solicitudeId: widget.solicitudeId,
                    );
                    final success = await AnswerApiProvider.createAnswer(
                      answerRequest,
                      context,
                    );
                    setState(() {
                      isBusy = false;
                    });
                    if (success) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => StudentList()),
                        (Route<dynamic> route) => false,
                      );
                    }
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  height: responsive.hp(5),
                  width: responsive.wp(50),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey),
                  child: isBusy
                      ? SizedBox(
                          child: CircularProgressIndicator(
                              strokeWidth: 2, backgroundColor: Colors.white),
                          height: 20.0,
                          width: 20.0,
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
        ],
      ),
    );
  }
}
