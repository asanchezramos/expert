import 'package:expert/src/api/solicitude_api_provider.dart';
import 'package:expert/src/models/user_solicitude_entity.dart';
import 'package:expert/src/pages/expert/pages/certificate.dart';
import 'package:expert/src/pages/expert/pages/list_students.dart';
import 'package:expert/src/pages/student/widgets/header.dart';
import 'package:expert/src/utils/dialogs.dart';
import 'package:expert/src/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactStudent extends StatelessWidget {
  const ContactStudent({Key key, this.userSolicitudeEntity}) : super(key: key);
  final UserSolicitudeEntity userSolicitudeEntity;
  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Header2(
              texto: 'Contacto con el Estudiante',
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
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.grey[200]),
      child: DataExpert(
        userSolicitudeEntity: userSolicitudeEntity,
      ),
    );
  }
}

class DataExpert extends StatefulWidget {
  const DataExpert({Key key, this.userSolicitudeEntity}) : super(key: key);

  final UserSolicitudeEntity userSolicitudeEntity;

  @override
  _DataExpertState createState() => _DataExpertState();
}

class _DataExpertState extends State<DataExpert> {
  void _downloadFile(String url, String filename) async {
    if (url == "") {
      Dialogs.alert(context,
          title: "Aviso", message: "No hay archivo para descargar");
      return;
    }
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  bool isBusy1 = false;
  bool isBusy2 = false;

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    return FutureBuilder<UserSolicitudeEntity>(
        future: SolicitudeApiProvider.getUserSolicitudeDetailByExpert(
          widget.userSolicitudeEntity.solicitudeId,
        ),
        builder: (
          BuildContext context,
          AsyncSnapshot<UserSolicitudeEntity> snapshot,
        ) {
          if (snapshot.hasData) {
            UserSolicitudeEntity userData = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(
                20,
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    width: responsive.wp(42),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: responsive.hp(2.0),
                        ),
                        Text(
                          'Estudiante: ' + userData.fullName,
                          style: TextStyle(fontSize: responsive.ip(1.7)),
                        ),
                        Text(
                          'Especialidad: ' +
                              widget.userSolicitudeEntity.specialty,
                          style: TextStyle(fontSize: responsive.ip(1.7)),
                        ),
                        SizedBox(
                          height: responsive.hp(3.5),
                        ),
                        Text(
                          'Descargar Excel',
                          style: TextStyle(fontSize: responsive.ip(2)),
                        ),
                        SizedBox(
                          height: responsive.hp(1.0),
                        ),
                        InkWell(
                          onTap: () => _downloadFile(
                            userData.repository,
                            "repositorio",
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            height: responsive.hp(5),
                            width: responsive.wp(40),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.green),
                            child: Text(
                              'Descargar',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: responsive.hp(3.0),
                        ),
                        Text(
                          'Descargar Investigación',
                          style: TextStyle(fontSize: responsive.ip(2)),
                        ),
                        SizedBox(
                          height: responsive.hp(1.0),
                        ),
                        InkWell(
                          onTap: () => _downloadFile(
                            userData.investigation,
                            "investigacion",
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            height: responsive.hp(5),
                            width: responsive.wp(40),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.green),
                            child: Text(
                              'Descargar',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: responsive.hp(5),
                        ),
                        InkWell(
                          onTap: () async {
                            setState(() {
                              isBusy1 = true;
                            });
                            await SolicitudeApiProvider.updateSolicitudeStatus(
                              userData.solicitudeId,
                              'C',
                            );
                            setState(() {
                              isBusy1 = false;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Certificate(
                                  solicitudeId: userData.solicitudeId,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: responsive.hp(5),
                            width: responsive.wp(43),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey),
                            child: isBusy1
                                ? SizedBox(
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        backgroundColor: Colors.white),
                                    height: 20.0,
                                    width: 20.0,
                                  )
                                : Text(
                                    'Siguiente',
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ),
                        ),
                        SizedBox(
                          height: responsive.hp(2),
                        ),
                        InkWell(
                          onTap: () async {
                            setState(() {
                              isBusy2 = true;
                            });
                            await SolicitudeApiProvider.updateSolicitudeStatus(
                              userData.solicitudeId,
                              'D',
                            );
                            setState(() {
                              isBusy2 = true;
                            });
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StudentList()),
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: responsive.hp(5),
                            width: responsive.wp(43),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey),
                            child: isBusy2
                                ? SizedBox(
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        backgroundColor: Colors.white),
                                    height: 20.0,
                                    width: 20.0,
                                  )
                                : Text(
                                    'Cancelar',
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: responsive.wp(5),
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        height: responsive.hp(20),
                        width: responsive.wp(25),
                        child: userData.photo != ""
                            ? Image.network(
                                userData.photo,
                              )
                            : SizedBox(),
                      ),
                      SizedBox(
                        height: responsive.hp(3),
                      ),
                      Column(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text('Contactar'),
                                        content: Text('Teléfono: ' +
                                            widget.userSolicitudeEntity.phone),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text('ok'),
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
                                    borderRadius: BorderRadius.circular(35),
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
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
