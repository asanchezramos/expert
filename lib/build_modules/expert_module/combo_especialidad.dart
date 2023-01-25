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
        title: Text("Seleccionar Especialidad"), 
      ),
      body: FutureBuilder(
        future: onLoadRedResults(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
          List<dynamic> aaa = snapshot.data as List<dynamic>;
            return ListView.builder(
                itemCount: aaa.length ,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.amber,
                      child: Icon(
                        Icons.check_circle, 
                      ),
                      //child: Image.asset("assets/programmer.png"),
                    ),
                    contentPadding: EdgeInsets.all(10),
                    title: Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        aaa[index]["especialidad"],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop(aaa[index]["especialidad"]);
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

  Future<List<dynamic>> onLoadRedResults() async {
    final List<dynamic> _listRed = [
      {"especialidad": "Desarrollo de software"},
      {"especialidad": "Gestión estratégica de tecnologías"},
      {"especialidad": "Desarrollo de sistemas inteligentes"}
    ];
    return _listRed;
  }
}
