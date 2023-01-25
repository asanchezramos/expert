import 'package:expert/src/api/network_api_provider.dart';
import 'package:expert/src/app_config.dart';
import 'package:expert/src/managers/session_manager.dart';
import 'package:expert/src/models/expert_entity.dart';
import 'package:expert/src/models/network_request_entity.dart';
import 'package:flutter/material.dart';

class NotificationExpert extends StatefulWidget {
  @override
  _NotificationExpertState createState() => _NotificationExpertState();
}

class _NotificationExpertState extends State<NotificationExpert> {
  Future<List<ExpertEntity>?> getNetworkByUserId =
      NetworkApiProvider.getNetworkRequestExpert();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Solicitudes"), 
      ),
      body: RefreshIndicator(
        child: FutureBuilder(
          future: getNetworkByUserId,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<ExpertEntity>? aasd = snapshot.data as List<ExpertEntity>;
              if (aasd.length <= 0) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 40.0),
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        children: [
                          TextSpan(
                            text: "No tienes solicitudes pendientes",
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return ListView.builder(
                    itemCount: aasd.length,
                    itemBuilder: (context, index) {
                      ExpertEntity element = aasd[index];
                      return ListTile(
                        leading: (element.photo!.length <= 0)
                            ? CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.amber,
                                child: Text(
                                  onBuildLettersPicture(
                                      element.name, element.fullName),
                                  style: TextStyle( 
                                      fontWeight: FontWeight.bold),
                                ),
                                //child: Image.asset("assets/programmer.png"),
                              )
                            : CircleAvatar(
                                backgroundImage: NetworkImage(
                                    "${AppConfig.API_URL}public/${element.photo}"),
                                backgroundColor: Colors.grey,
                                radius: 25,
                                //child: Image.asset("assets/programmer.png"),
                              ),
                        title: Container(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                element.name! + ' ' + element.fullName!,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Solicitud pendiente ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () async {
                            SessionManager? session =
                                await SessionManager.getInstance();
                            if (session != null) {
                              NetworkRequestEntity netReqEntity =
                                  NetworkRequestEntity(
                                      status: 2,
                                      userBaseId: element.id,
                                      userRelationId: session.getUserId());
                              await NetworkApiProvider
                                  .putNetworkRequestResponse(
                                      context, netReqEntity);
                              setState(() {
                                getNetworkByUserId = NetworkApiProvider
                                    .getNetworkRequestExpert();
                              });
                            }
                          },
                          icon: Icon(
                            Icons.check, 
                          ),
                        ),
                      );
                    });
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
        onRefresh: () async {
          setState(() {
            getNetworkByUserId = NetworkApiProvider.getNetworkRequestExpert();
          });
        },
      ),
    );
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
