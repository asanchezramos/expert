import 'package:expert/src/api/network_api_provider.dart';
import 'package:expert/src/api/resource_api_provider.dart';
import 'package:expert/src/app_config.dart';
import 'package:expert/src/managers/session_manager.dart';
import 'package:expert/src/models/expert_entity.dart';
import 'package:expert/src/models/network_request_entity.dart';
import 'package:expert/src/models/resource_entity.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PerfilExpert extends StatefulWidget {
  ExpertEntity expert;
  PerfilExpert(this.expert);
  @override
  _PerfilExpertState createState() => _PerfilExpertState();
}

class _PerfilExpertState extends State<PerfilExpert> {
  bool isBusy = false;
  bool isMyRed = false;
  Future<List<ResourceEntity>?>? getNetworkByUserId;
  Future<List<ExpertEntity>?> getNetworkByUserIdAux =
      NetworkApiProvider.getNetworkByUserId();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNetworkByUserId = ResourceApiProvider.getResources(widget.expert.id);
    getNetworkByUserIdAux.then((value) {
      var oData =
          value!.indexWhere((element) => element.id == widget.expert.id);
      print(oData);
      if (oData == -1) {
        setState(() {
          isMyRed = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Enviar solicitud",
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                (widget.expert.photo!.length <= 0)
                    ? CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.amber,
                        child: Text(
                          onBuildLettersPicture(
                              widget.expert.name, widget.expert.fullName),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 60),
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
                    widget.expert.name! + ' ' + widget.expert.fullName!,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 30,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 20),
                  child: Text(
                    widget.expert.specialty!,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 20),
                  child: Text("ORCID:${widget.expert.orcid!}",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: isMyRed,
            child: Container(
                padding: EdgeInsets.all(15),
              child: ElevatedButton( 
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Enviar solicitud",
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
                  if (!isBusy) {
                    setState(() {
                      isBusy = true;
                    });
                    SessionManager? session =
                        await SessionManager.getInstance();
                    if (session != null) {
                      final userId = session.getUserId();
                      final request = NetworkRequestEntity(
                          status: 1,
                          userBaseId: userId,
                          userRelationId: widget.expert.id);
                      final success =
                          await NetworkApiProvider.postRegisterNetwork(
                              context, request);
                      setState(() {
                        isBusy = false;
                      });
                      if (success) {
                        Navigator.of(context).pop();
                      }
                    }
                  }
                },
              ),
            ),
          ),
          Padding(padding: EdgeInsets.all(10)),
          Container(
            child: RichText(
              text: TextSpan(
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  children: [
                    WidgetSpan(
                      child: Icon(
                        Icons.recent_actors,
                        size: 20,
                      ),
                    ),
                    TextSpan(text: " Mis recursos")
                  ]),
            ),
          ),
          Divider(),
          FutureBuilder(
            future: getNetworkByUserId,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<ResourceEntity>? asdasd =
                    snapshot.data as List<ResourceEntity>;
                if (asdasd.length > 0) {
                  return ListView.builder(
                    itemCount: asdasd.length,
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final ResourceEntity element = asdasd[index];
                      return ListTile(
                        title: Text(element.title!),
                        subtitle: Text(element.subtitle!),
                        trailing: Container(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.link,
                                ),
                                onPressed: () async {
                                  if (!await launchUrl(
                                      Uri.parse(element.link!))) {
                                    throw 'Could not launch ${element.link!}';
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Container(
                    child: Center(
                      child: Text("No cuenta con recursos de experiencias"),
                    ),
                  );
                }
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
