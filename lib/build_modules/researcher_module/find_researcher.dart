import 'package:flutter/material.dart';

class FindResearcher extends SearchDelegate{
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        icon: Icon(Icons.clear),
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
    return FutureBuilder(
      future: onLoadRedResults(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.amber,
                    child: Text(snapshot.data[index]["acronimo"],style: TextStyle(color: Colors.pink[900]),),
                    //child: Image.asset("assets/programmer.png"),
                  ),
                  title: Container(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(snapshot.data[index]["nombre"]),
                        Text(snapshot.data[index]["especialidad"], style: TextStyle(fontWeight: FontWeight.bold),)
                      ],
                    ),
                  ),
                  onTap: () {},
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
      future: onLoadRedSuggestions(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.amber,
                    child: Text(snapshot.data[index]["acronimo"],style: TextStyle(color: Colors.pink[900]),),
                    //child: Image.asset("assets/programmer.png"),
                  ),
                  title: Container(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(snapshot.data[index]["nombre"]),
                        Text(snapshot.data[index]["especialidad"], style: TextStyle(fontWeight: FontWeight.bold),)
                      ],
                    ),
                  ),
                  onTap: () {},
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