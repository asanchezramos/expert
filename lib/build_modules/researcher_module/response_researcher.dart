import 'dart:io';

import 'package:expert/src/api/research_api_provider.dart';
import 'package:expert/src/app_config.dart';
import 'package:expert/src/models/expert_entity.dart';
import 'package:expert/src/models/research_entity.dart';
import 'package:expert/src/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ResponseResearcher extends StatefulWidget {
  ExpertEntity _expertEntity;
  ResearchEntity _researchEntity;
  ResponseResearcher(this._researchEntity,this._expertEntity);
  @override
  _ResponseResearcherState createState() => _ResponseResearcherState();
}

class _ResponseResearcherState extends State<ResponseResearcher> {
  TextEditingController _comentario = TextEditingController();
  bool isBusyOne = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _comentario.text = widget._researchEntity.observation;
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _comentario.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
        ),
        title: Text("Respuesta de revisión"),
        centerTitle: true,
      ),
      body: Container(
        child: ListView(
          children: [
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      child: Column(
                        children: [
                          Text(
                            widget._expertEntity.name +
                                ' ' +
                                widget._expertEntity.fullName,
                            style: TextStyle(fontSize: 25),
                          ),
                          Text(
                            widget._expertEntity.specialty,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(10),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: (widget._expertEntity.photo.length <= 0)
                        ? CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.amber,
                      child: Text(
                        onBuildLettersPicture(
                            widget._expertEntity.name,
                            widget._expertEntity.fullName),
                        style: TextStyle(
                            color: Colors.pink[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 40),
                      ),
                      //child: Image.asset("assets/programmer.png"),
                    )
                        : CircleAvatar(
                      backgroundImage: NetworkImage(
                          "${AppConfig.API_URL}public/${widget._expertEntity.photo}"),
                      backgroundColor: Colors.grey,
                      radius: 50,
                      //child: Image.asset("assets/programmer.png"),
                    ),
                  )
                ],
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
              ),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.all(20),
              child: Center(
                child: QrImage(
                  embeddedImage: AssetImage("assets/logo_v2.png"),
                  embeddedImageStyle: QrEmbeddedImageStyle(
                    size: Size(40, 40),
                  ),
                  data: "${widget._researchEntity.researchId}",
                  version: QrVersions.auto,
                  gapless: false,
                  size: 200.0,
                ),
              ),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              child: Text(
                "\"${widget._researchEntity.title}\"",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontStyle: FontStyle.italic
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              child: Text(
                "Autores: ${widget._researchEntity.authors}",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    fontStyle: FontStyle.italic
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20,vertical:10),
              child: Row(
                children: [
                  Expanded(
                    flex:1,
                    child: Icon(Icons.check_circle_outline, color: Colors.green,size: 30,),
                  ),
                  Expanded(
                    flex:2,
                    child: Text("Validado ${onBuildStringToDate(widget._researchEntity.updatedAt)}", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: _comentario,
                minLines: 3,
                maxLines: 3,
                autocorrect: false,
                readOnly: true,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(15),
                  labelText: "Comentario",
                  border: OutlineInputBorder(),
                ),
                onTap: () {},
              ),
            ),

          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.amber,
        width: double.infinity,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FlatButton.icon(
              color: Colors.amber,
              icon: Icon(Icons.cloud_download, color: Colors.pink[900],),
              label: Text(
                "Descargar certificado validez",
                style: TextStyle(
                    color: Colors.pink[900],
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              onPressed: () async {
                setState(() {
                  isBusyOne = true;
                });
                print(widget._researchEntity.researchId);
                String oRutaCertificate = await ResearchApiProvider.getCertificateByResearchId(widget._researchEntity.researchId);

                try {
                  var data = await http.get("${AppConfig.API_URL}public/${oRutaCertificate}");
                  var bytes = data.bodyBytes;
                  var dir = await getApplicationDocumentsDirectory();
                  print(dir.path);
                  File file = File("/storage/emulated/0/Download/${oRutaCertificate}");
                  await file.writeAsBytes(bytes);
                  setState(() {
                    isBusyOne = false;
                  });
                  Dialogs.alert(context,title: "Éxito",message: "El archivo se guardó en descargas");
                } catch (e) {
                  setState(() {
                    isBusyOne = false;
                  });
                  Dialogs.alert(context,title: "Error",message: "No se pudo guardar el archivo");
                }
              },
            ),
            Visibility(
              visible: isBusyOne,
              child: Padding(padding: EdgeInsets.all(10),),
            ),
            Visibility(
              visible: isBusyOne,
              child: Container(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(backgroundColor: Colors.pink[900],),
              ),
            )
          ],
        ),
      ),
    );
  }
  String onBuildStringToDate(String date){
    DateTime parsedDate = DateTime.parse(date);
    return new  DateFormat('dd/MM/yyyy').format(parsedDate);
  }

  String onBuildLettersPicture(firstLetterAux, secondLetterAux) {
    String fistLetter = "";
    String lastLetter = "";
    List<String> aa = firstLetterAux.split(" ");
    if (aa.length > 0) {
      fistLetter = aa[0].substring(0, 1).toUpperCase();
    }
    List<String> bb = secondLetterAux.split(" ");
    if (bb.length > 0) {
      lastLetter = bb[0].substring(0, 1).toUpperCase();
    }
    String oChars = "$fistLetter$lastLetter";
    return oChars;
  }
}
