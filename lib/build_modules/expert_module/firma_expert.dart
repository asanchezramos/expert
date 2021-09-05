import 'dart:io';

import 'package:expert/src/api/signing_api_provider.dart';
import 'package:expert/src/app_config.dart';
import 'package:expert/src/managers/session_manager.dart';
import 'package:expert/src/models/signing_entity.dart';
import 'package:expert/src/utils/dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FirmaExperto extends StatefulWidget {
  @override
  _FirmaExpertoState createState() => _FirmaExpertoState();
}

class _FirmaExpertoState extends State<FirmaExperto> {
  bool isBusy = false;
  bool isBodyfirma = false;
  SigningEntity firmaDigital;
  Future<List<SigningEntity>> getSigningByUser =
  SigningApiProvider.getSigningByUser();
  File imageFile;
  pickImageFromGallery() async {
    var photo = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = photo;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSigningByUser.then((value) {
      print(value);
      setState(() {
        if(value.length > 0){
          firmaDigital = value[0];
          print(firmaDigital.toJson());
          print(firmaDigital.link);
          isBodyfirma = true;
        }  else {
          firmaDigital = null;
          isBodyfirma = false;
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
          color: Colors.pink[900],
        ),
        title: Text(
          "Firma Digital",
          style: TextStyle(color: Colors.pink[900]),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(30),
              child: Card(
                color: isBodyfirma ?  Colors.grey : Colors.white ,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 50),
                  child: Center(
                    child: ( firmaDigital != null) ?  Container(
                      height: 200,
                      width: 200,
                      child:
                      Image.network(
                        "${AppConfig.API_URL}public/${firmaDigital.link}",
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes
                                  : null,
                            ),
                          );
                        },
                      errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                        return Container(child: Center(child: Icon(Icons.error_outline,size: 50,color: Colors.red,),),);
                      },
                      ),
                    )
                     :
                    Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.amber,
                          radius: 50,
                          child:Icon(Icons.close_fullscreen,color: Colors.pink[900],size: 50,) ,
                        ),
                        Padding(padding: EdgeInsets.all(10)),
                        Text("Su firma digital se mostrará aquí"),
                      ],
                    ),

                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              width: double.infinity,
              child: ListView(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                children: [
                  ListTile(
                    title: Text("Especificaciones",style: TextStyle(fontWeight: FontWeight.bold),),
                    subtitle: Text("Su firma digital debe tener fondo transaparente.") ,
                    leading: Icon(Icons.confirmation_num,color: Colors.pink[900],),
                    onTap: (){
                      showDialog(
                          context: context,
                          builder: (BuildContext context){
                            return AlertDialog(
                              title: Text("Especificaciones", textAlign: TextAlign.center,),
                              content: Container(
                                height: 200,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Las dimensiones de la imagen debe de ser 500px por 500px."),
                                    Padding(padding: EdgeInsets.all(10)),
                                    Text("El fondo de la imagen debe de ser transparente."),
                                    Padding(padding: EdgeInsets.all(10)),
                                    Text("La firma tiene que ser legible y de trazo gruesas.")

                                  ],
                                ),
                              ),
                            );
                          }
                      );
                    },
                  ),
                  ListTile(
                    title: Text("Ejemplo",style: TextStyle(fontWeight: FontWeight.bold),),
                    subtitle: Text("Puede visualizar un ejemplo selecionando aquí.") ,
                    leading: Icon(Icons.image,color: Colors.pink[900],),
                    onTap: (){
                      showDialog(
                          context: context,
                          builder: (BuildContext context){
                            return AlertDialog(
                              title: Text("Ejemplo", textAlign: TextAlign.center,),
                              content: ListTile(
                                title: Container(
                                  child: Card(
                                      color: Colors.grey,
                                      child: Container(
                                        padding: EdgeInsets.all(20),
                                        child: Image.asset("assets/firma_digital_v1.png"),
                                      )
                                  ),
                                ),
                                subtitle: Text("(*) El fondo gris se colocó para verificar la transparencia de la imagen."),
                              ),
                            );
                          }
                      );
                    },
                  ),
                  ListTile(
                    title: Text("Utilización",style: TextStyle(fontWeight: FontWeight.bold),),
                    subtitle: Text("Su firma digital se mostrará en las investigaciones aprobadas.") ,
                    leading: Icon(Icons.handyman,color: Colors.pink[900],),
                    onTap: (){
                      showDialog(
                          context: context,
                          builder: (BuildContext context){
                            return AlertDialog(
                              title: Text("Utilización", textAlign: TextAlign.center,),
                              content: Container(
                                height: 200,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Su firma digital se utilizará para los siguientes puntos:"),
                                    Padding(padding: EdgeInsets.all(10)),
                                    Text(" - En los certificados de investigaciones aprobadas."),
                                    Padding(padding: EdgeInsets.all(10)),
                                    Text(" - Su firma ."),

                                  ],
                                ),
                              ),
                            );
                          }
                      );
                    },
                  ),
                  ListTile(
                    title: Text("LLave Privada",style: TextStyle(fontWeight: FontWeight.bold),),
                    subtitle: Text("Su firma digital está protegida con una contraseña.") ,
                    leading: Icon(Icons.security,color: Colors.pink[900],),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        child: FlatButton.icon(
          icon: Icon(Icons.upload_file, color: Colors.pink[900],),
          color: Colors.amber,
          height: 50,
          label: Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(!isBodyfirma ? "Subir firma digital" : "Actualizar firma digital", style: TextStyle(color: Colors.pink[900], fontWeight: FontWeight.bold),),
                Visibility(
                  visible: isBusy,
                    child: Padding(padding: EdgeInsets.all(20),)),
                Visibility(
                    visible: isBusy,
                    child: Container(
                  width: 20,
                  height: 20,child: Center(child: CircularProgressIndicator(backgroundColor: Colors.pink[900],),),)),
              ],
            ),
          ),
          onPressed: !isBodyfirma ? () async {
            if(!isBusy){
              setState(() {
                isBusy = true;
              });
              Dialogs.confirm(context,title: "Especificaciones",message: "De preferencia la imagen de su firma debe estar en un fondo blanco o transparente.").then((value) async {
                await pickImageFromGallery();
                final session = await SessionManager.getInstance();
                SigningEntity signingEntity = new SigningEntity(
                  expertId: session.getUserId(),
                  fileSigning: imageFile != null ? imageFile : null,
                  link: ""
                );
                print(signingEntity.toJson());

                bool success = await SigningApiProvider.createSigning(context, signingEntity);

                if(success){
                  setState(() {
                    getSigningByUser =
                    SigningApiProvider.getSigningByUser();

                    getSigningByUser.then((value) {
                      print(value);
                      setState(() {
                        if(value.length > 0){
                          firmaDigital = value[0];
                          isBodyfirma = true;
                        }  else {
                          firmaDigital = null;
                          isBodyfirma = false;
                        }
                      });
                    });
                  });
                }

                setState(() {
                  isBusy = false;
                });
              });
            }

          } : () async {
            if(!isBusy){
              setState(() {
                isBusy = true;
              });
              Dialogs.confirm(context,title: "Especificaciones",message: "De preferencia la imagen de su firma debe estar en un fondo blanco o transparente.").then((value) async {
                await pickImageFromGallery();
                final session = await SessionManager.getInstance();
                SigningEntity signingEntity = new SigningEntity(
                    signingId: firmaDigital.signingId,
                    expertId: session.getUserId(),
                    fileSigning: imageFile != null ? imageFile : null,
                    link: firmaDigital.link
                );
                print(signingEntity.toJson());
                bool success = await SigningApiProvider.updateSigning(context, signingEntity);
                if(success){
                  setState(() {
                    getSigningByUser =
                        SigningApiProvider.getSigningByUser();

                    getSigningByUser.then((value) {
                      print(value);
                      setState(() {
                        if(value.length > 0){
                          firmaDigital = value[0];
                          isBodyfirma = true;
                        }  else {
                          firmaDigital = null;
                          isBodyfirma = false;
                        }
                      });
                    });
                  });
                }
                setState(() {
                  isBusy = false;
                });
              });
            }
          },
        ),
      ),
    );
  }
}
