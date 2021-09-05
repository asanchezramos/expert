import 'package:expert/build_modules/expert_module/resource_user_add.dart';
import 'package:expert/src/api/network_api_provider.dart';
import 'package:expert/src/api/resource_api_provider.dart';
import 'package:expert/src/app_config.dart';
import 'package:expert/src/managers/session_manager.dart';
import 'package:expert/src/models/expert_entity.dart';
import 'package:expert/src/models/network_request_entity.dart';
import 'package:expert/src/models/resource_entity.dart';
import 'package:expert/src/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ExpertProfile extends StatefulWidget {
  ExpertEntity expert;
  ExpertProfile(this.expert);
  @override
  _ExpertProfileState createState() => _ExpertProfileState();
}

class _ExpertProfileState extends State<ExpertProfile> {
  bool isBusy = false;

  Future<List<ResourceEntity>> getNetworkByUserId =
      ResourceApiProvider.getResources(null);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
          color: Colors.pink[900],
        ),
        title: Text(
          "Mi Perfil",
          style: TextStyle(color: Colors.pink[900]),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.pink[900],
        ),
        onPressed: () {
          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => ResourceUserAdd()))
              .then((value) {
            setState(() {
              getNetworkByUserId = ResourceApiProvider.getResources(null);
            });
          });
        },
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            getNetworkByUserId =  ResourceApiProvider.getResources(null);
          });
        },
        child: ListView(
          padding: EdgeInsets.all(10),
          children: [
            Container(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  (widget.expert.photo.length <= 0)
                      ? CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.amber,
                    child: Text(
                      onBuildLettersPicture(
                          widget.expert.name, widget.expert.fullName),
                      style: TextStyle(
                          color: Colors.pink[900],
                          fontWeight: FontWeight.bold,
                          fontSize: 60),
                    ),
                    //child: Image.asset("assets/programmer.png"),
                  )
                      : CircleAvatar(
                    backgroundImage: NetworkImage(
                        "${AppConfig.API_URL}public/${widget.expert.photo}"),
                    backgroundColor: Colors.grey,
                    radius: 80,
                    //child: Image.asset("assets/programmer.png"),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20, bottom: 5),
                    child: Text(
                      widget.expert.name + ' ' + widget.expert.fullName,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 5, bottom: 20),
                    child: Text(
                      widget.expert.specialty,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: RichText(
                text: TextSpan(
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                    children: [
                      WidgetSpan(
                        child: Icon(Icons.recent_actors, size: 20, color: Colors.pink[900],),
                      ),
                      TextSpan(
                          text:
                          " Mis recursos"
                      )
                    ]
                ),
              ),
            ),
            Divider(),
            FutureBuilder(
              future: getNetworkByUserId,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final ResourceEntity element = snapshot.data[index];
                      return ListTile(
                        title: Text(element.title),
                        subtitle: Text(element.subtitle),
                        trailing: Container(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.link,
                                  color: Colors.pink[900],
                                ),
                                onPressed: () async {
                                  if (await canLaunch(element.link)) {
                                    await launch(element.link);
                                  } else {
                                    throw 'Could not launch $element.link';
                                  }
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete_forever,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  Dialogs.confirm(context,title: "Confirmación", message: "¿Está seguro que desea eliminar el recurso?").then((value) async  {
                                    if(value){
                                      final success = await ResourceApiProvider.deleteResource(element.resourceUserId);
                                      if(success){
                                        setState(() {
                                          getNetworkByUserId = ResourceApiProvider.getResources(null);
                                        });
                                        Dialogs.alert(context,title: "Éxito", message: "Recurso eliminado");
                                      }
                                    }
                                  });

                                },
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
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
