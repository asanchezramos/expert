import 'package:flutter/material.dart';

class NotificationResearcher extends StatefulWidget {
  @override
  _NotificationResearcherState createState() => _NotificationResearcherState();
}

class _NotificationResearcherState extends State<NotificationResearcher> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notificaciones"),
        leading: BackButton(
          color: Colors.white,
        ),
      ),
      body: FutureBuilder(
        future: onLoadRedResults(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.amber,
                      child: Icon(Icons.notification_important, color: Colors.pink[900],),
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
      ),
    );
  }
}
Future onLoadRedResults() async {
  final List<dynamic> _listRed = [
    {
      "nombre": "Enviaste una solicitud",
      "acronimo":"JB",
      "especialidad":"Juan Bautista"
    },
    {
      "nombre": "Tatiana Cespedes",
      "acronimo":"AL",
      "especialidad":"Acepto tu solicitud"
    }
  ];
  return _listRed;
}
