import 'package:expert/src/api/answer_api_provider.dart';
import 'package:expert/src/models/solicitude_answer_entity.dart';
import 'package:expert/src/pages/student/widgets/header.dart';
import 'package:expert/src/utils/dialogs.dart';
import 'package:expert/src/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AnswerExpert extends StatelessWidget {
  final solicitudeId;
  const AnswerExpert({Key key, this.solicitudeId}) : super(key: key);

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
                  texto: 'Respuesta del experto',
                ),
                SizedBox(
                  height: responsive.hp(10),
                ),
                Container(
                  constraints: BoxConstraints(
                      minWidth: responsive.wp(85), maxWidth: responsive.wp(85)),
                  height: responsive.hp(60),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[200]),
                  child: DataExpert(solicitudeId: solicitudeId),
                )
              ],
            ),
          ),
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

  bool isBusy = false;

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    return FutureBuilder<List<SolicitudeAnswerEntity>>(
        future: AnswerApiProvider.getAnswerBySolicitude(
          widget.solicitudeId,
        ),
        builder: (
          BuildContext context,
          AsyncSnapshot<List<SolicitudeAnswerEntity>> snapshot,
        ) {
          if (snapshot.hasData) {
            return Expanded(
                child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      SolicitudeAnswerEntity solicitudeAnswerEntity =
                          snapshot.data[index];
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
                                    'Nombres: ' +
                                        solicitudeAnswerEntity.fullName,
                                    style:
                                        TextStyle(fontSize: responsive.ip(1.7)),
                                  ),
                                  Text(
                                    'Expecialista: ' +
                                        solicitudeAnswerEntity.specialty,
                                    style:
                                        TextStyle(fontSize: responsive.ip(1.7)),
                                  ),
                                  SizedBox(
                                    height: responsive.hp(3.5),
                                  ),
                                  Text(
                                    'Certificado de validez',
                                    style:
                                        TextStyle(fontSize: responsive.ip(2)),
                                  ),
                                  SizedBox(
                                    height: responsive.hp(1.0),
                                  ),
                                  InkWell(
                                    onTap: () => _downloadFile(
                                      solicitudeAnswerEntity.file,
                                      "respuestas",
                                    ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: responsive.hp(5),
                                      width: responsive.wp(40),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                                    'Comentarios',
                                    style:
                                        TextStyle(fontSize: responsive.ip(2)),
                                  ),
                                  SizedBox(
                                    height: responsive.hp(1.0),
                                  ),
                                  Text(solicitudeAnswerEntity.comments),
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
                                  child: solicitudeAnswerEntity.photo != ""
                                      ? Image.network(
                                          solicitudeAnswerEntity.photo,
                                        )
                                      : SizedBox(),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    }));
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
