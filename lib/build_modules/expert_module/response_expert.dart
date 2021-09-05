import 'package:expert/build_modules/expert_module/home_expert.dart';
import 'package:expert/src/api/research_api_provider.dart';
import 'package:expert/src/api/signing_api_provider.dart';
import 'package:expert/src/app_config.dart';
import 'package:expert/src/models/expert_entity.dart';
import 'package:expert/src/models/research_entity.dart';
import 'package:expert/src/models/signing_entity.dart';
import 'package:expert/src/utils/dialogs.dart';
import 'package:flutter/material.dart';

class ResponseExpert extends StatefulWidget {
  final ExpertEntity expertSelected;
  final ResearchEntity researchSelected;
  final int applicable;
  ResponseExpert(this.researchSelected,this.expertSelected,this.applicable);
  @override
  _ResponseExpertState createState() => _ResponseExpertState();
}

class _ResponseExpertState extends State<ResponseExpert> {
  TextEditingController _comentario = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  bool isBusy = false;
bool hasFirma = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     SigningApiProvider.getSigningByExpert(widget.researchSelected.expertId).then((value) {
      setState(() {
        if(value.length > 0){
          hasFirma = true;
        }  else {
          hasFirma = false;
        }
      });
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
      ),
      body: GestureDetector(
        onTap: () {
          final FocusScopeNode focus = FocusScope.of(context);
          if (!focus.hasPrimaryFocus && focus.hasFocus) {
            FocusManager.instance.primaryFocus.unfocus();
          }
        },
        child: Form(
          key: _form,
          child: Container(
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
                                widget.expertSelected.name +
                                    ' ' +
                                    widget.expertSelected.fullName,
                                style: TextStyle(fontSize: 25),
                              ),
                              Text(
                                widget.expertSelected.specialty,
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
                        child: (widget.expertSelected.photo.length <= 0)
                            ? CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.amber,
                          child: Text(
                            onBuildLettersPicture(
                                widget.expertSelected.name,
                                widget.expertSelected.fullName),
                            style: TextStyle(
                                color: Colors.pink[900],
                                fontWeight: FontWeight.bold,
                                fontSize: 40),
                          ),
                          //child: Image.asset("assets/programmer.png"),
                        )
                            : CircleAvatar(
                          backgroundImage: NetworkImage(
                              "${AppConfig.API_URL}public/${widget.expertSelected.photo}"),
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
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                  child: Text(
                    "\"${widget.researchSelected.title}\"",
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
                    "Autores: ${widget.researchSelected.authors}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontStyle: FontStyle.italic
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
                buildStatusResearch(widget.applicable),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
                Divider(),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _comentario,
                    validator: (val) {
                      if (val.isEmpty) return 'Este campo es requerido';
                      return null;
                    },
                    minLines: 3,
                    maxLines: 3,
                    autocorrect: false,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      labelText: "Comentario",
                      border: OutlineInputBorder(),
                    ),
                    onTap: () {},
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        width: double.infinity, 
        child: FlatButton(
          color: Colors.amber,
          child: Container(
            height: 50,
        child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Enviar revisión", style: TextStyle(fontSize: 18, color: Colors.pink[900]),),
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
                child: CircularProgressIndicator(backgroundColor: Colors.pink[900],),
              ),
            ),
          ],
        ),
      ),
          onPressed: () async {

            if(!hasFirma){
              Dialogs.alert(context,title: "No tiene firma digital", message: "En el menú podrá encontrar la opcion apra que suba su firma digital");
            return;
            }
            if (_form.currentState.validate() && !isBusy) {
              Dialogs.confirm(context,title: "Confirmación", message: "¿Está seguro que desea enviar revisión?").then((value) async {
                if(value){
                  setState(() {
                    isBusy = true;
                  });
                  final request = ResearchEntity(
                      researchId: widget.researchSelected.researchId,
                      status: ongetStatus(),
                      observation: _comentario.text
                  );
                  final success = await ResearchApiProvider.putUpdateResearchRevision(context, request);
                  setState(() {
                    isBusy = false;
                  });
                  if(success){
                    Navigator.pop(context,true);
                    Dialogs.alert(context,title: "Éxito", message: "La investigación fue revisada");

                  } else {
                    Dialogs.alert(context,title: "Error", message: "No se pudo enviar revisión");
                  }
                }
              });
              
            }
          },
        ),
      ),
    );
  }
  ongetStatus(){
    int status = 4;
    switch(widget.applicable){
      case 1:
        status = 3;
        break;
      case 2:
        status = 4;
        break;
      case 3:
        status = 6;
        break;
    }
return status;
  }
  buildStatusResearch(int status){
    switch(status){
      case 1:
        return Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex:1,
                child: Text("Aplicable",textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
              ),
              Expanded(
                flex:1,
                child: Icon(Icons.check_circle, color: Colors.green,size: 30,),
              ),
            ],
          ),
        );

        break;
      case 2:
        return Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex:1,
                child: Text("No Aplicable",textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
              ),
              Expanded(
                flex:1,
                child: Icon(Icons.remove_circle, color: Colors.red,size: 30,),
              ),
            ],
          ),
        );
        break;
      case 3:
        return
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex:1,
                  child: Text("Correción",textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                ),
                Expanded(
                  flex:1,
                  child: Icon(Icons.swap_horizontal_circle, color: Colors.orange,size: 30,),
                ),
              ],
            ),
          );
        break;

    }
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
