import 'package:expert/build_modules/researcher_module/perfil_expert.dart';
import 'package:expert/src/app_config.dart';
import 'package:flutter/material.dart';
import 'package:expert/src/models/expert_entity.dart';
import 'package:expert/src/api/expert_api_provider.dart';

class FindResearcher extends SearchDelegate{
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        icon: Icon(Icons.clear, ),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    print(query);
    String param = " " +query ;
    return FutureBuilder(
      future: ExpertApiProvider.getFindExpert(param),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          List<ExpertEntity>? expertos = snapshot.data as List<ExpertEntity>;
          return ListView.builder(
              itemCount: expertos.length,
              itemBuilder: (context, index) {
                ExpertEntity element =expertos[index];
                return ListTile(
                  contentPadding: EdgeInsets.only(left: 20,top: 10,bottom: 10,right: 20),
                  leading: (element.photo!.length <= 0) ? CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.amber,
                    child:  Text(
                      onBuildLettersPicture(element.name , element.fullName),
                      style: TextStyle( fontWeight: FontWeight.bold),
                    ),
                    //child: Image.asset("assets/programmer.png"),
                  ) :
                  CircleAvatar(
                    backgroundImage: NetworkImage("${AppConfig.API_URL}public/${element.photo}"),
                    backgroundColor: Colors.grey,
                    radius: 25,
                    //child: Image.asset("assets/programmer.png"),
                  ),
                  title: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(element.name! + ' ' + element.fullName!),
                        Text(
                          element.specialty!,
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        )
                      ],
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward,  ) ,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => PerfilExpert(element)));
                  },
                );
              });
        }else{
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return FutureBuilder(
      future: ExpertApiProvider.getFindExpert(" "),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          List<ExpertEntity>? expertosfirst = snapshot.data as List<ExpertEntity>;
          return ListView.builder(
              itemCount: expertosfirst.length,
              itemBuilder: (context, index) {
                ExpertEntity element = expertosfirst[index];
                return ListTile(
                  contentPadding: EdgeInsets.only(left: 20,top: 10,bottom: 10,right: 20),
                  leading: (element.photo!.length <= 0) ? CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.amber,
                    child:  Text(
                      onBuildLettersPicture(element.name , element.fullName),
                      style: TextStyle( fontWeight: FontWeight.bold),
                    ),
                    //child: Image.asset("assets/programmer.png"),
                  ) :
                  CircleAvatar(
                    backgroundImage: NetworkImage("${AppConfig.API_URL}public/${element.photo}"),
                    backgroundColor: Colors.grey,
                    radius: 25,
                    //child: Image.asset("assets/programmer.png"),
                  ),
                  title: Container( 
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(element.name! + ' ' + element.fullName!),
                        Text(
                          element.specialty!,
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        Text("ORCID: ${element.orcid}",
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                      ],
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward,  ) ,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => PerfilExpert(element)));
                  },
                );
              });
        }else{
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
  @override
  String get searchFieldLabel => 'Búsqueda de experto';
}
String onBuildLettersPicture(firstLetterAux, secondLetterAux) {

  String fistLetter = "" ;
  String lastLetter = "";
  List<String> aa = firstLetterAux.split(" ");
  if(aa.length > 0){
    fistLetter = aa[0].substring(0,1).toUpperCase();
  }
  List<String> bb = secondLetterAux.split(" ") ;
  if(bb.length > 0){
    lastLetter = bb[0].substring(0,1).toUpperCase();
  }
  String oChars = "$fistLetter$lastLetter" ;
  return oChars;
}
Future onLoadRedSuggestions() async {
  final List<dynamic> _listRed = [
    {
      "nombre": "Juan Antonio Carranza Bermudez",
      "acronimo":"JB",
      "especialidad":"Software"
    },
    {
      "nombre": "Andres Bermudez",
      "acronimo":"AB",
      "especialidad":"Minería de Datos"
    },
    {
      "nombre": "David Benjamin Huapaya",
      "acronimo":"DH",
      "especialidad":"Inteligencia Articial"
    }
  ];
  return _listRed;
}
Future onLoadRedResults() async {
  final List<dynamic> _listRed = [
    {
      "nombre": "Sergio Cordova Dioses",
      "acronimo":"AL",
      "especialidad":"Software"
    },
    {
      "nombre": "Tatiana Cespedes",
      "acronimo":"AL",
      "especialidad":"Software"
    }
  ];
  return _listRed;
}