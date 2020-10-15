import 'dart:io';
import 'package:expert/build_modules/researcher_module/add_dimensions.dart';
import 'package:expert/build_modules/researcher_module/find_researcher.dart';
import 'package:expert/build_modules/researcher_module/init_researcher.dart';
import 'package:expert/build_modules/researcher_module/notification_researcher.dart';
import 'package:expert/build_modules/researcher_module/response_researcher.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class HomeResearcherModule extends StatefulWidget {
  @override
  _HomeResearcherModuleState createState() => _HomeResearcherModuleState();
}

class _HomeResearcherModuleState extends State<HomeResearcherModule> {
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
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: FindResearcher());
              },
            ),
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) => ResponseResearcher()));

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
            floatingActionButton: FloatingActionButton(
              child: Icon(
                Icons.add,
                color: Colors.pink[900],
              ),
              onPressed: () {
                _pageController.jumpToPage(2);
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
                                    "Jose Luis Herrera",
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
                                'JH',
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
                                      child: TextField(
                                        readOnly: true,
                                        autocorrect: false,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(15),
                                          suffixIcon: Icon(Icons.attach_file),
                                          labelText:
                                          "Selecionar archivo(pdf,jpg,xls)",
                                          border: OutlineInputBorder(),
                                        ),
                                        onTap: () async {
                                          try {
                                            File file =
                                            await FilePicker.getFile(
                                              type: FileType.custom,
                                            );
                                            return file;
                                          } catch (e) {
                                            print(
                                                "Error while picking the file: " +
                                                    e.toString());
                                          }
                                        },
                                      )),
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
                                      child: TextField(
                                        readOnly: true,
                                        autocorrect: false,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(15),
                                          suffixIcon: Icon(Icons.attach_file),
                                          labelText:
                                          "Selecionar archivo(pdf,jpg,xls)",
                                          border: OutlineInputBorder(),
                                        ),
                                        onTap: () async {
                                          try {
                                            File file =
                                            await FilePicker.getFile(
                                              type: FileType.custom,
                                            );
                                            return file;
                                          } catch (e) {
                                            print(
                                                "Error while picking the file: " +
                                                    e.toString());
                                          }
                                        },
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        minLines: 3,
                        maxLines: 3,
                        autocorrect: false,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(15),
                          labelText: "Título",
                          border: OutlineInputBorder(),
                        ),
                        onTap: () {},
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        minLines: 2,
                        maxLines: 3,
                        autocorrect: false,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(15),
                          labelText: "Autores",
                          border: OutlineInputBorder(),
                        ),
                        onTap: () {},
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Container(
                              child: Text(
                                "Dimensiones (4)",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: IconButton(
                                color: Colors.pink[900],
                                icon: Icon(Icons.add),
                                onPressed: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) => AddDimensions()));


                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(),
                    Container(
                      height: 120,
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
                                        padding: EdgeInsets.symmetric(vertical: 15),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(snapshot.data[index]["nombre"], style: TextStyle(fontWeight: FontWeight.bold),),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      Text("Aspecto 1"),
                                                      Icon(Icons.check)
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      Text("Aspecto 2"),
                                                      Icon(Icons.close)
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      Text("Aspecto 3"),
                                                      Icon(Icons.watch_later)
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
              )
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.pink[900],
              child: Icon(
                Icons.call,
                color: Colors.amber,
              ),
              onPressed: () {},
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
        "acronimo": "JS",
        "especialidad": "Minería de Datos",
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
          {
            "variable":"Primera"
          },
          {
            "variable":"Primera"
          }
        ]
      },
      {
        "nombre": "Nivel de seguridad",
        "acronimo": "AL",
        "especialidad": "Software",
        "id": "124",
        "aspecto": [
          {
            "variable":"Primera"
          },
          {
            "variable":"Primera"
          }
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
                icon: Icon(Icons.notifications),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              NotificationResearcher()));
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
              "Mis Investigaciones",
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
              title: Text("Mis Investigaciones"),
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
                                builder: (BuildContext context) => InitResearcherModule()));
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
