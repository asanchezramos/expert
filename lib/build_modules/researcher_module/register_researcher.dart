import 'package:expert/build_modules/researcher_module/init_researcher.dart';
import 'package:expert/build_modules/researcher_module/stikynotify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class RegisterResearcherModule extends StatefulWidget {
  @override
  _RegisterResearcherModuleState createState() => _RegisterResearcherModuleState();
}

class _RegisterResearcherModuleState extends State<RegisterResearcherModule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Regístrate Investigador"),
        centerTitle: true,
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => InitResearcherModule()));
          },
        ),
      ),
      body: GestureDetector(
        onTap: () {
          final FocusScopeNode focus = FocusScope.of(context);
          if (!focus.hasPrimaryFocus && focus.hasFocus) {
            FocusManager.instance.primaryFocus.unfocus();
          }
        },
        child: Padding(
          padding: EdgeInsets.all(15),
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.amber,
                        child: Text(
                          'TC',
                          style: TextStyle(fontSize: 40),
                        ),
                        radius: 50,
                        //child: Image.asset("assets/programmer.png"),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          icon: Icon(Icons.camera_alt, color: Colors.pink[900],),
                          onPressed: () {

                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  decoration: InputDecoration(
                    labelText: "Nombres",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  decoration: InputDecoration(
                    labelText: "Apellidos",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  decoration: InputDecoration(
                    labelText: "Correo",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  decoration: InputDecoration(
                    labelText: "Especialidad",
                    suffixIcon: Icon(Icons.arrow_drop_down),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  keyboardType: TextInputType.visiblePassword,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  decoration: InputDecoration(
                    labelText: "Contraseña",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  keyboardType: TextInputType.visiblePassword,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  decoration: InputDecoration(
                    labelText: "Repetir contraseña",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                height: 50,
                child: FlatButton(
                  color: Colors.pink[900],
                  textColor: Colors.amber,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Iniciar sesión", style: TextStyle(fontSize: 18),),
                        Visibility(
                          visible: false,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                          ),
                        ),
                        Visibility(
                          visible: false,
                          child: Container(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {

                    showOverlayNotification((context) {
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        child: SafeArea(
                          child: ListTile(
                            leading: SizedBox.fromSize(
                                size: const Size(40, 40),
                                child: ClipOval(
                                    child: Container(
                                      color: Colors.black,
                                    ))),
                            title: Text('FilledStacks'),
                            subtitle: Text('Thanks for checking out my tutorial'),
                            trailing: IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  OverlaySupportEntry.of(context).dismiss();
                                }),
                          ),
                        ),
                      );
                    }, duration: Duration(milliseconds: 4000));
                  },
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
