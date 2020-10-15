import 'dart:io';
import 'package:expert/build_modules/expert_module/notification_expert.dart';
import 'package:expert/build_modules/expert_module/response_expert.dart';
import 'package:expert/build_modules/researcher_module/find_researcher.dart';
import 'package:expert/build_modules/researcher_module/init_researcher.dart';
import 'package:expert/build_modules/researcher_module/notification_researcher.dart';
import 'package:expert/build_modules/researcher_module/response_researcher.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class HomeExpertModule extends StatefulWidget {
  @override
  _HomeExpertModuleState createState() => _HomeExpertModuleState();
}

class _HomeExpertModuleState extends State<HomeExpertModule> {
  PageController _pageController = PageController(
    keepPage: true,
  );
  String radioItem = '';
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: _buildDrawer(),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: onTapItemBar,
        children: [
          Scaffold(
            body: RefreshIndicator(
              child: FutureBuilder(
                future: onLoadExperto(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.amber,
                              child: Text(
                                snapshot.data[index]["acronimo"],
                                style: TextStyle(color: Colors.pink[900]),
                              ),
                              //child: Image.asset("assets/programmer.png"),
                            ),
                            title: Container(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(snapshot.data[index]["nombre"]),
                                  Text(
                                    snapshot.data[index]["especialidad"],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            onTap: () {},
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
              onRefresh: () async {
                onLoadExperto();
              },
            ),
          ),
          Scaffold(
            body: RefreshIndicator(
              child: FutureBuilder(
                future: onLoadInvestigaciones(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.amber,
                              child: Text(
                                snapshot.data[index]["acronimo"],
                                style: TextStyle(color: Colors.pink[900]),
                              ),
                              //child: Image.asset("assets/programmer.png"),
                            ),
                            title: Container(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(snapshot.data[index]["nombre"]),
                                  Text(
                                    snapshot.data[index]["especialidad"],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    snapshot.data[index]["autores"],
                                  )
                                ],
                              ),
                            ),
                            onTap: () {
                              _pageController.jumpToPage(3);
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
              onRefresh: () async {
                onLoadExperto();
              },
            ),
          ),
          Scaffold(
            body: RefreshIndicator(
              child: FutureBuilder(
                future: onLoadExperto(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return RadioListTile(
                            groupValue: radioItem,
                            value: snapshot.data[index]["id"],
                            title: Container(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: CircleAvatar(
                                      backgroundColor: Colors.amber,
                                      child: Text(
                                        snapshot.data[index]["acronimo"],
                                        style:
                                            TextStyle(color: Colors.pink[900]),
                                      ),
                                      //child: Image.asset("assets/programmer.png"),
                                    ),
                                    flex: 1,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(snapshot.data[index]["nombre"]),
                                        Text(
                                          snapshot.data[index]["especialidad"],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    flex: 4,
                                  ),
                                ],
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                radioItem = value;
                              });
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
              onRefresh: () async {
                onLoadExperto();
              },
            ),
            bottomNavigationBar: Container(
              width: double.infinity,
              height: 50,
              child: FlatButton(
                color: Colors.amber,
                child: Text(
                  "Siguiente",
                  style: TextStyle(
                      color: Colors.pink[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                onPressed: () {
                  _pageController.jumpToPage(3);
                },
              ),
            ),
          ),
          Scaffold(
            body: GestureDetector(
                onTap: () {
                  final FocusScopeNode focus = FocusScope.of(context);
                  if (!focus.hasPrimaryFocus && focus.hasFocus) {
                    FocusManager.instance.primaryFocus.unfocus();
                  }
                },
                child: ListView(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              child: Column(
                                children: [
                                  Text(
                                    "Juan Antonio Ugarte Miranda",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    "Software",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.all(10),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: CircleAvatar(
                              backgroundColor: Colors.brown.shade800,
                              child: Text(
                                'TC',
                                style: TextStyle(fontSize: 40),
                              ),
                              radius: 50,
                              //child: Image.asset("assets/programmer.png"),
                            ),
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      "Instrumento",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: FlatButton.icon(
                                        onPressed: () {},
                                        icon: Icon(Icons.cloud_download),
                                        label: Text("Descargar")),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      "Investigación",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: FlatButton.icon(
                                        onPressed: () {},
                                        icon: Icon(Icons.cloud_download),
                                        label: Text("Descargar")),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                          "Consumo de minerales tipo b para las comunidades indigenas de la selva alta"),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                          "Juan Fabricio Albares Caceres\nMario Casas Bermudez"),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        child: Text(
                          "Dimensiones (4)",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                    Divider(),
                    Container(
                      height: 200,
                      child: FutureBuilder(
                        future: onLoadDimensions(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: ListTile(
                                      title: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 15),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              snapshot.data[index]["nombre"],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 20),
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      Text("Aspecto 1"),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 10),
                                                      ),
                                                      Row(
                                                        children: [
                                                          IconButton(
                                                            icon: Icon(
                                                              Icons.check,
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                            onPressed: () {},
                                                          ),
                                                          IconButton(
                                                            icon: Icon(
                                                              Icons.close,
                                                              color: Colors.red,
                                                            ),
                                                            onPressed: () {},
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      Text("Aspecto 2"),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 10),
                                                      ),
                                                      Row(
                                                        children: [
                                                          IconButton(
                                                            icon: Icon(
                                                              Icons.check,
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                            onPressed: () {},
                                                          ),
                                                          IconButton(
                                                            icon: Icon(
                                                              Icons.close,
                                                              color: Colors.red,
                                                            ),
                                                            onPressed: () {},
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      Text("Aspecto 3"),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 10),
                                                      ),
                                                      Row(
                                                        children: [
                                                          IconButton(
                                                            icon: Icon(
                                                              Icons.check,
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                            onPressed: () {},
                                                          ),
                                                          IconButton(
                                                            icon: Icon(
                                                              Icons.close,
                                                              color: Colors.red,
                                                            ),
                                                            onPressed: () {},
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: () {},
                                    ),
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
                    ),
                    Divider(),
                  ],
                )),
            bottomNavigationBar: Container(
              width: double.infinity,
              height: 50,
              child: FlatButton(
                color: Colors.amber,
                child: Text(
                  "Siguiente",
                  style: TextStyle(
                      color: Colors.pink[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => ResponseExpert()));

                },
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: _buildNavigationBar(),
    );
  }

  Future onLoadExperto() async {
    final List<dynamic> _listRed = [
      {
        "nombre": "Andres Martin Loaiza",
        "acronimo": "AL",
        "especialidad": "Software",
        "id": "123"
      },
      {
        "nombre": "Joaquin Suares Perez",
        "acronimo": "AL",
        "especialidad": "Software",
        "id": "124"
      }
    ];
    return _listRed;
  }

  onLoadDimensions() async {
    final List<dynamic> _listRed = [
      {
        "nombre": "Nivel de importancia",
        "acronimo": "AL",
        "especialidad": "Software",
        "id": "123",
        "aspecto": [
          {"variable": "Primera"},
          {"variable": "Primera"}
        ]
      },
      {
        "nombre": "Nivel de seguridad",
        "acronimo": "AL",
        "especialidad": "Software",
        "id": "124",
        "aspecto": [
          {"variable": "Primera"},
          {"variable": "Primera"}
        ]
      }
    ];
    return _listRed;
  }

  onLoadInvestigaciones() async {
    final List<dynamic> _listRed = [
      {
        "nombre":
        "APLICACIÓN MÓVIL PARA LA VALIDACIÓN DE INSTRUMENTOS POR CONTENIDO MEDIANTE JUICIO DE EXPERTOS EN UNIVERSIDADES ",
        "acronimo": "P",
        "especialidad": "Mineria de Datos",
        "autores": "Andres Bermudez, Juan Carpio"
      }
    ];
    return _listRed;
  }

  onTapItemBar(index) {
    setState(() {
      _currentIndex = index;
    });
  }

  onChangePage(index) {
    _pageController.jumpToPage(index);
  }

  Widget _buildAppBar(context) {
    switch (_currentIndex) {
      case 0:
        {
          return AppBar(
            actions: [
              IconButton(
                icon: Icon(Icons.markunread_mailbox),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              NotificationExpert()));
                },
              )
            ],
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text(
              "Mi Red",
              style: TextStyle(color: Colors.pink[900]),
            ),
          );
        }
        break;
      case 1:
        {
          return AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text(
              "Mis Revisiones",
              style: TextStyle(color: Colors.pink[900]),
            ),
          );
        }
        break;
      case 2:
        {
          return AppBar(
            backgroundColor: Colors.white,
            leading: BackButton(
              color: Colors.pink[900],
              onPressed: () {
                onChangePage(1);
              },
            ),
            centerTitle: true,
            title: Text(
              "Seleciona un experto",
              style: TextStyle(color: Colors.pink[900]),
            ),
          );
        }
        break;
      case 3:
        return AppBar(
          backgroundColor: Colors.white,
          leading: BackButton(
            color: Colors.pink[900],
            onPressed: () {
              onChangePage(2);
            },
          ),
          centerTitle: true,
          title: Text(
            "Registrar investigación",
            style: TextStyle(color: Colors.pink[900]),
          ),
          actions: [
            IconButton(
              color: Colors.amber,
              icon: Icon(Icons.send),
              onPressed: () {
                onChangePage(1);
              },
            )
          ],
        );
        break;
    }
  }

  Widget _buildNavigationBar() {
    print(_currentIndex);
    switch (_currentIndex) {
      case 0:
      case 1:
        return BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: onChangePage,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.supervised_user_circle),
              title: Text(
                "Mi red",
                textAlign: TextAlign.center,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.folder_shared),
              title: Text("Mis Revisiones"),
            )
          ],
        );
        break;
      case 2:
      case 3:
        return null;
        break;
    }
  }

  Widget _buildDrawer() {
    switch (_currentIndex) {
      case 0:
      case 1:
        return Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.pink[900],
          ),
          child: Drawer(
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: ListView(
                padding: EdgeInsets.all(10),
                children: [
                  DrawerHeader(
                    padding: EdgeInsets.only(top: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.brown.shade800,
                          child: Text(
                            'TC',
                            style: TextStyle(fontSize: 40),
                          ),
                          radius: 50,
                          //child: Image.asset("assets/programmer.png"),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          child: RichText(
                            text: TextSpan(
                              text: "Hola \n",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              children: [
                                TextSpan(
                                  text: "Teófilo Crisóstomo",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 18,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: ListTile(
                      leading: Icon(
                        Icons.power_settings_new,
                        color: Colors.white,
                      ),
                      title: Text(
                        "Cerrar sesión",
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    InitResearcherModule()));
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        );
        break;
      case 2:
        return null;
        break;
    }
  }
}

class MyBehavior extends ScrollBehavior {
  // quita el efecto de brillo del scroll
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
