import 'package:flutter/material.dart';

class WpComboEspecialidad extends StatefulWidget {
  @override
  _WpComboEspecialidadState createState() => _WpComboEspecialidadState();
}

class _WpComboEspecialidadState extends State<WpComboEspecialidad> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Selecionar Especialidad"),
        leading: BackButton(
          color: Colors.white,
        ),
      ),
      body: FutureBuilder(
        future: onLoadRedResults(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.amber,
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.pink[900],
                      ),
                      //child: Image.asset("assets/programmer.png"),
                    ),
                    contentPadding: EdgeInsets.all(10),
                    title: Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        snapshot.data[index]["especialidad"],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop(snapshot.data[index]["especialidad"]);
                    },
                  );
                });
          } else {
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

  Future onLoadRedResults() async {
    final List<dynamic> _listRed = [
      {"especialidad": "Software"},
      {"especialidad": "Redes Neuronales"}
    ];
    return _listRed;
  }
}
