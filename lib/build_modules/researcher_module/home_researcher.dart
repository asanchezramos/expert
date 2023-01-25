import 'dart:io';
import 'package:expert/build_modules/researcher_module/add_dimensions.dart';
import 'package:expert/build_modules/researcher_module/find_researcher.dart';
import 'package:expert/build_modules/researcher_module/init_researcher.dart';
import 'package:expert/build_modules/researcher_module/notification_researcher.dart';
import 'package:expert/build_modules/researcher_module/response_researcher.dart';
import 'package:expert/build_modules/researcher_module/view_criterios_response.dart';
import 'package:expert/src/api/auth_api_provider.dart';
import 'package:expert/src/api/dimension_api_provider.dart';
import 'package:expert/src/api/expert_api_provider.dart';
import 'package:expert/src/api/network_api_provider.dart';
import 'package:expert/src/api/research_api_provider.dart';
import 'package:expert/src/app_config.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:expert/src/managers/session_manager.dart';
import 'package:expert/src/models/dimension_entity.dart';
import 'package:expert/src/models/expert_entity.dart';
import 'package:expert/src/models/research_entity.dart';
import 'package:expert/src/utils/dialogs.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeResearcherModule extends StatefulWidget {
  @override
  _HomeResearcherModuleState createState() => _HomeResearcherModuleState();
}

class _HomeResearcherModuleState extends State<HomeResearcherModule> {
  PageController _pageController = PageController(
    keepPage: true,
  );

  File? attachmentOneFile;
  File? attachmentTwoFile;
  final TextEditingController _attachmentOneController =
      TextEditingController();
  final TextEditingController _attachmentTwoController =
      TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorsController = TextEditingController();
  final TextEditingController _observationController = TextEditingController();
  final GlobalKey<FormState> _formResearch = GlobalKey<FormState>();
  final GlobalKey<FormState> _formUpdateResearch = GlobalKey<FormState>();
  int? _expertId;
  int? _researchId;
  int _currentIndex = 0;
  ExpertEntity? expertSelected = ExpertEntity();
  ResearchEntity? _researchSelected;
  bool isBusy = false;
  bool isUpdateComplete = false;
  bool hasDimensions = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<List<ExpertEntity>?> getNetworkByUserId =
      NetworkApiProvider.getNetworkByUserId();
  Future<List<ResearchEntity>?> getResearchByUserId =
      ResearchApiProvider.getResearchByUserId();
  Future<List<DimensionEntity>?>? getDimensions;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: _buildAppBar(context) as PreferredSizeWidget?,
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
                  future: getNetworkByUserId,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<ExpertEntity>? usuarios =
                          snapshot.data as List<ExpertEntity>;
                      if (usuarios.length <= 0) {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 40.0),
                          child: Center(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                                children: [
                                  TextSpan(
                                    text:
                                        "Puedes seleccionar el botón con icono ",
                                  ),
                                  WidgetSpan(
                                    child: Icon(
                                      Icons.search,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        " para agregar invitar a un experto a ser parte de tu red ",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return ListView.builder(
                            itemCount: usuarios.length,
                            itemBuilder: (context, index) {
                              ExpertEntity element = usuarios[index];
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(element.name! +
                                          ' ' +
                                          element.fullName!),
                                      Text(
                                        element.specialty!,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                                onTap: () {},
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
                    getNetworkByUserId =
                        NetworkApiProvider.getNetworkByUserId();
                  });
                },
              ),
            ),
            Scaffold(
              body: RefreshIndicator(
                child: FutureBuilder(
                  future: getResearchByUserId,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<ResearchEntity>? investigaciones =
                          snapshot.data as List<ResearchEntity>;
                      if (investigaciones.length <= 0) {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 40.0),
                          child: Center(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                                children: [
                                  TextSpan(
                                    text:
                                        "Puedes seleccionar el botón con icono ",
                                  ),
                                  WidgetSpan(
                                    child: Icon(
                                      Icons.add,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " para agregar una investigación ",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return ListView.builder(
                            itemCount: investigaciones.length,
                            itemBuilder: (context, index) {
                              ResearchEntity element = investigaciones[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.amber,
                                  child: Text(
                                    onBuildStatusResearch(element.status),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  //child: Image.asset("assets/programmer.png"),
                                ),
                                title: Container(
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(element.title!),
                                      Text(
                                        element.speciality!,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        element.authors!,
                                      )
                                    ],
                                  ),
                                ),
                                subtitle: onBuildSubtitleResearch(element),
                                onTap: () async {
                                  switch (element.status) {
                                    case 1:
                                      //editar research
                                      await ResearchApiProvider.getResearchById(
                                              element.researchId)
                                          .then((value) {
                                        onClearResearch();
                                        onSetResearch(value);
                                        setState(() {
                                          _researchId = element.researchId;
                                          _researchSelected = value;
                                        });
                                      });
                                      await ExpertApiProvider.getExpertById(
                                              _researchSelected!.expertId)
                                          .then((valueAux) {
                                        print(valueAux);
                                        setState(() {
                                          expertSelected = valueAux;
                                          print(expertSelected!.fullName);
                                          isUpdateComplete = true;
                                          _pageController.jumpToPage(5);
                                        });
                                      });
                                      break;
                                    case 2:
                                      Dialogs.alert(
                                        context,
                                        title: "Estado Enviado",
                                        message:
                                            "Podrás acceder al certificado de validez cuando el estado sea 'Aprobado'",
                                      );
                                      break;
                                    case 3:
                                      await ResearchApiProvider.getResearchById(
                                              element.researchId)
                                          .then((value) {
                                        onClearResearch();
                                        onSetResearch(value);
                                        setState(() {
                                          _researchId = element.researchId;
                                          _researchSelected = value;
                                        });
                                      });
                                      await ExpertApiProvider.getExpertById(
                                              _researchSelected!.expertId)
                                          .then((valueAux) {
                                        print(valueAux);
                                        setState(() {
                                          expertSelected = valueAux;
                                        });
                                      });
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  ResponseResearcher(
                                                      _researchSelected,
                                                      expertSelected)));
                                      break;
                                    case 6:
                                    case 4:
                                      await ResearchApiProvider.getResearchById(
                                              element.researchId)
                                          .then((value) {
                                        onClearResearch();
                                        onSetResearch(value);
                                        setState(() {
                                          _researchId = element.researchId;
                                          _researchSelected = value;
                                        });
                                      });
                                      await ExpertApiProvider.getExpertById(
                                              _researchSelected!.expertId)
                                          .then((valueAux) {
                                        print(valueAux);
                                        setState(() {
                                          expertSelected = valueAux;
                                          print(expertSelected!.fullName);
                                          isUpdateComplete = true;
                                          _pageController.jumpToPage(5);
                                        });
                                      });
                                      break;
                                    case 5:
                                      Dialogs.alert(
                                        context,
                                        title: "En revisión",
                                        message:
                                            "El experto se encuentra revisando tu investigación",
                                      );
                                      break;
                                  }
                                },
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
                    getResearchByUserId =
                        ResearchApiProvider.getResearchByUserId();
                  });
                },
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(
                  Icons.add,
                ),
                onPressed: () {
                  onClearResearch();
                  _pageController.jumpToPage(2);
                },
              ),
            ),
            Scaffold(
              body: RefreshIndicator(
                child: FutureBuilder(
                  future: getNetworkByUserId,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<ExpertEntity>? expertos =
                          snapshot.data as List<ExpertEntity>;
                      return ListView.builder(
                          itemCount: expertos.length,
                          itemBuilder: (context, index) {
                            ExpertEntity element = expertos[index];
                            return RadioListTile(
                              groupValue: _expertId,
                              value: element.id,
                              title: Container(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      child: (element.photo!.length <= 0)
                                          ? CircleAvatar(
                                              radius: 25,
                                              backgroundColor: Colors.amber,
                                              child: Text(
                                                onBuildLettersPicture(
                                                    element.name,
                                                    element.fullName),
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(5),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(element.name! +
                                              ' ' +
                                              element.fullName!),
                                          Text(
                                            element.specialty!,
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
                              onChanged: (dynamic value) {
                                setState(() {
                                  expertSelected = element;
                                  _expertId = value;
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
                  setState(() {
                    getNetworkByUserId =
                        NetworkApiProvider.getNetworkByUserId();
                  });
                },
              ),
              bottomNavigationBar: Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Siguiente",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Visibility(
                          visible: !isBusy,
                          child: Icon(
                            Icons.arrow_forward,
                          )),
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
                  onPressed: () {
                    setState(() {
                      isBusy = true;
                    });
                    Future.delayed(const Duration(milliseconds: 200), () {
                      if (_expertId == null) {
                        Dialogs.alert(context,
                            title: "Alerta",
                            message: "Debe seleccionar un experto");
                      } else {
                        _pageController.jumpToPage(3);
                      }
                      setState(() {
                        isBusy = false;
                      });
                    });
                  },
                ),
              ),
            ),
            Scaffold(
              body: GestureDetector(
                  onTap: () {
                    final FocusScopeNode focus = FocusScope.of(context);
                    if (!focus.hasPrimaryFocus && focus.hasFocus) {
                      FocusManager.instance.primaryFocus!.unfocus();
                    }
                  },
                  child: (_expertId != null)
                      ? Form(
                          key: _formResearch,
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
                                              expertSelected!.name! +
                                                  ' ' +
                                                  expertSelected!.fullName!,
                                              style: TextStyle(fontSize: 25),
                                            ),
                                            Text(
                                              expertSelected!.specialty!,
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
                                      child: (expertSelected!.photo!.length <=
                                              0)
                                          ? CircleAvatar(
                                              radius: 50,
                                              backgroundColor: Colors.amber,
                                              child: Text(
                                                onBuildLettersPicture(
                                                    expertSelected!.name,
                                                    expertSelected!.fullName),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 40),
                                              ),
                                              //child: Image.asset("assets/programmer.png"),
                                            )
                                          : CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  "${AppConfig.API_URL}public/${expertSelected!.photo}"),
                                              backgroundColor: Colors.grey,
                                              radius: 50,
                                              //child: Image.asset("assets/programmer.png"),
                                            ),
                                    )
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                                child: TextFormField(
                                                  controller:
                                                      _attachmentOneController,
                                                  validator: (val) {
                                                    if (val!.isEmpty)
                                                      return 'Este campo es requerido';
                                                    return null;
                                                  },
                                                  readOnly: true,
                                                  autocorrect: false,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.all(15),
                                                    suffixIcon:
                                                        Icon(Icons.attach_file),
                                                    labelText:
                                                        "Seleccionar archivo(pdf,jpg,xls)",
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                  onTap: () async {
                                                    try {
                                                      FilePickerResult? rs =
                                                          await FilePicker
                                                              .platform
                                                              .pickFiles();
                                                      if (rs != null) {
                                                        File file = File(rs
                                                            .files
                                                            .single
                                                            .path!);
                                                        setState(() {
                                                          attachmentOneFile =
                                                              file;
                                                          if (attachmentOneFile !=
                                                              null) {
                                                            _attachmentOneController
                                                                    .text =
                                                                "Archivo Selecionado";
                                                          } else {
                                                            _attachmentOneController
                                                                .text = "";
                                                          }
                                                        });
                                                      }
                                                    } catch (e) {
                                                      setState(() {
                                                        attachmentOneFile =
                                                            null;
                                                        _attachmentOneController
                                                            .text = "";
                                                      });
                                                      print(
                                                          "Error while picking the file: " +
                                                              e.toString());
                                                    }
                                                  },
                                                  onChanged: (value) {
                                                    _formResearch.currentState!
                                                        .validate();
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
                                                child: TextFormField(
                                                  controller:
                                                      _attachmentTwoController,
                                                  validator: (val) {
                                                    if (val!.isEmpty)
                                                      return 'Este campo es requerido';
                                                    return null;
                                                  },
                                                  readOnly: true,
                                                  autocorrect: false,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.all(15),
                                                    suffixIcon:
                                                        Icon(Icons.attach_file),
                                                    labelText:
                                                        "Seleccionar archivo(pdf,jpg,xls)",
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                  onTap: () async {
                                                    try {
                                                      FilePickerResult? rs =
                                                          await FilePicker
                                                              .platform
                                                              .pickFiles();
                                                      if (rs != null) {
                                                        File file = File(rs
                                                            .files
                                                            .single
                                                            .path!);
                                                        setState(() {
                                                          attachmentTwoFile =
                                                              file;
                                                          if (attachmentTwoFile !=
                                                              null) {
                                                            _attachmentTwoController
                                                                    .text =
                                                                "Archivo Selecionado";
                                                          } else {
                                                            _attachmentTwoController
                                                                .text = "";
                                                          }
                                                        });
                                                      }
                                                    } catch (e) {
                                                      setState(() {
                                                        attachmentTwoFile =
                                                            null;
                                                        _attachmentTwoController
                                                            .text = "";
                                                      });
                                                      print(
                                                          "Error while picking the file: " +
                                                              e.toString());
                                                    }
                                                  },
                                                  onChanged: (value) {
                                                    _formResearch.currentState!
                                                        .validate();
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
                                child: TextFormField(
                                  controller: _titleController,
                                  validator: (val) {
                                    if (val!.isEmpty)
                                      return 'Este campo es requerido';
                                    return null;
                                  },
                                  minLines: 3,
                                  maxLines: 3,
                                  autocorrect: false,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    labelText: "Título",
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (value) {
                                    _formResearch.currentState!.validate();
                                  },
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: TextFormField(
                                  controller: _authorsController,
                                  validator: (val) {
                                    if (val!.isEmpty)
                                      return 'Este campo es requerido';
                                    return null;
                                  },
                                  minLines: 2,
                                  maxLines: 3,
                                  autocorrect: false,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    labelText: "Autores",
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (value) {
                                    _formResearch.currentState!.validate();
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      : null),
              bottomNavigationBar: Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Siguiente",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Visibility(
                          visible: !isBusy,
                          child: Icon(
                            Icons.arrow_forward,
                          )),
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
                  onPressed: () async {
                    final FocusScopeNode focus = FocusScope.of(context);
                    if (!focus.hasPrimaryFocus && focus.hasFocus) {
                      FocusManager.instance.primaryFocus!.unfocus();
                    }
                    if (_formResearch.currentState!.validate() && !isBusy) {
                      setState(() {
                        isBusy = true;
                      });
                      SessionManager? session =
                          await SessionManager.getInstance();
                      if (session != null) {
                        final userId = session.getUserId();
                        final request = ResearchEntity(
                            expertId: expertSelected!.id,
                            speciality: expertSelected!.specialty,
                            researcherId: userId,
                            status: 1,
                            title: _titleController.text,
                            authors: _authorsController.text,
                            observation: "",
                            attachmentTwoFile: attachmentTwoFile,
                            attachmentOneFile: attachmentOneFile);
                        final success =
                            await ResearchApiProvider.postRegisterResearch(
                                context, request);
                        setState(() {
                          isBusy = false;
                        });
                        if (success) {
                          SessionManager? session =
                              await SessionManager.getInstance();
                          if (session != null) {
                            final int? researcherId = session.getResearchId();
                            setState(() {
                              _researchId = researcherId;
                              getDimensions =
                                  DimensionApiProvider.getDimensions(
                                      _researchId);
                            });

                            _pageController.jumpToPage(4);
                          }
                        }
                      }
                    } else {
                      Dialogs.alert(context,
                          title: "Alerta",
                          message: "Complete los campos requeridos");
                    }
                  },
                ),
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(
                  Icons.call,
                ),
                onPressed: () async {
                  if (!await launchUrl(
                      Uri.parse("tel:${expertSelected!.phone}"))) {
                    throw 'Could not launch ${expertSelected!.phone}';
                  }
                },
              ),
            ),
            Scaffold(
              body: RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    getDimensions =
                        DimensionApiProvider.getDimensions(_researchId);
                  });
                },
                child: FutureBuilder(
                  future: getDimensions,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      dynamic element = snapshot.data;
                      if (element.length <= 0) {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 40.0),
                          child: Center(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                                children: [
                                  TextSpan(
                                    text:
                                        "Puedes seleccionar el botón con icono ",
                                  ),
                                  WidgetSpan(
                                    child: Icon(
                                      Icons.playlist_add,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " para agregar dimensiones ",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return GroupedListView<dynamic, String?>(
                          elements: element,
                          groupBy: (element) => element.name,
                          groupComparator: (value1, value2) =>
                              value2!.compareTo(value1!),
                          itemComparator: (item1, item2) =>
                              item1.variable.compareTo(item2.variable),
                          order: GroupedListOrder.ASC,
                          useStickyGroupSeparators: true,
                          groupSeparatorBuilder: (String? value) => Padding(
                            padding: const EdgeInsets.all(0),
                            child: Container(
                              color: Colors.pink[50],
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 5.0),
                                title: Text(
                                  value!,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () async {
                                    DimensionEntity sEntity = DimensionEntity(
                                        name: value, variable: "");
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                AddDimensions(
                                                    expertSelected!.specialty,
                                                    expertSelected!.id,
                                                    sEntity,
                                                    _researchId))).then(
                                        (value) async {
                                      setState(() {
                                        getDimensions =
                                            DimensionApiProvider.getDimensions(
                                                _researchId);
                                      });
                                    });
                                  },
                                ),
                                subtitle: Visibility(
                                  child: Container(
                                    child: RichText(
                                      text: TextSpan(children: [
                                        WidgetSpan(
                                          child: Icon(
                                            Icons.info_outline,
                                            size: 18,
                                          ),
                                        ),
                                        TextSpan(
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                          text:
                                              " Has un tap doble sobre la variable para editar la revisión.",
                                        )
                                      ]),
                                    ),
                                    padding: EdgeInsets.only(
                                      top: 15,
                                      bottom: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          itemBuilder: (c, element) {
                            return GestureDetector(
                              onDoubleTap: () {
                                Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                ViewCriterioResponse(
                                                    expertSelected!.specialty,
                                                    expertSelected!.id,
                                                    element,
                                                    _researchId,
                                                    _researchSelected)))
                                    .then((value) {
                                  setState(() {
                                    getDimensions =
                                        DimensionApiProvider.getDimensions(
                                            _researchId);
                                  });
                                });
                              },
                              child: Card(
                                elevation: 2.0,
                                margin: new EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 6.0),
                                child: Container(
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10.0),
                                    title: Text(element.variable),
                                    trailing: IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () async {
                                        Dialogs.confirm(context,
                                                title: "Alerta",
                                                message:
                                                    "¿Está seguro de eliminar el indicador?")
                                            .then((value) async {
                                          if (value!) {
                                            if (!isBusy) {
                                              setState(() {
                                                isBusy = true;
                                              });
                                              final success =
                                                  await DimensionApiProvider
                                                      .postDeleteDimension(
                                                          context,
                                                          element.dimensionId);
                                              setState(() {
                                                isBusy = false;
                                              });
                                              if (success) {
                                                getDimensions =
                                                    DimensionApiProvider
                                                        .getDimensions(
                                                            _researchId);
                                              }
                                            }
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
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
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(
                  Icons.playlist_add,
                ),
                onPressed: () {
                  DimensionEntity sEntity =
                      DimensionEntity(name: "", variable: "");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => AddDimensions(
                              expertSelected!.specialty,
                              expertSelected!.id,
                              sEntity,
                              _researchId))).then((value) {
                    setState(() {
                      getDimensions =
                          DimensionApiProvider.getDimensions(_researchId);
                      getDimensions!.then((value) {
                        if (value!.length > 0) {
                          hasDimensions = true;
                        } else {
                          hasDimensions = false;
                        }
                      });
                    });
                  });
                },
              ),
              bottomNavigationBar: Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Enviar a revisión  ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Visibility(
                          visible: !isBusy,
                          child: Icon(
                            Icons.send,
                          )),
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
                  onPressed: () {
                    if (hasDimensions) {
                      Dialogs.confirm(context,
                              title: "Confirmación",
                              message:
                                  "¿Está seguro de enviar a revisión la investigación?")
                          .then((value) async {
                        if (value!) {
                          setState(() {
                            isBusy = true;
                          });
                          final request = ResearchEntity(
                              researchId: _researchId,
                              status: 2,
                              observation: "");
                          final success = await ResearchApiProvider
                              .putUpdateResearchRevision(context, request);
                          setState(() {
                            isBusy = false;
                          });
                          if (success) {
                            onClearResearch();
                            setState(() {
                              getResearchByUserId =
                                  ResearchApiProvider.getResearchByUserId();
                            });
                            _pageController.jumpToPage(1);
                            Dialogs.alert(context,
                                title: "Éxito",
                                message:
                                    "La investigación fue enviada a revisión");
                          }
                        }
                      });
                    } else {
                      Dialogs.alert(context,
                          title: "Alerta",
                          message:
                              "Agregue almenos una dimensión para enviar a revisión");
                    }
                  },
                ),
              ),
            ),
            Scaffold(
              body: GestureDetector(
                  onTap: () {
                    final FocusScopeNode focus = FocusScope.of(context);
                    if (!focus.hasPrimaryFocus && focus.hasFocus) {
                      FocusManager.instance.primaryFocus!.unfocus();
                    }
                  },
                  child: (isUpdateComplete)
                      ? Form(
                          key: _formUpdateResearch,
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
                                              expertSelected!.name! +
                                                  ' ' +
                                                  expertSelected!.fullName!,
                                              style: TextStyle(fontSize: 25),
                                            ),
                                            Text(
                                              expertSelected!.specialty!,
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
                                      child: (expertSelected!.photo!.length <=
                                              0)
                                          ? CircleAvatar(
                                              radius: 50,
                                              child: Text(
                                                onBuildLettersPicture(
                                                    expertSelected!.name,
                                                    expertSelected!.fullName),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 40),
                                              ),
                                              //child: Image.asset("assets/programmer.png"),
                                            )
                                          : CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  "${AppConfig.API_URL}public/${expertSelected!.photo}"),
                                              backgroundColor: Colors.grey,
                                              radius: 50,
                                              //child: Image.asset("assets/programmer.png"),
                                            ),
                                    )
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                                child: TextFormField(
                                                  controller:
                                                      _attachmentOneController,
                                                  validator: (val) {
                                                    if (val!.isEmpty)
                                                      return 'Este campo es requerido';
                                                    return null;
                                                  },
                                                  readOnly: true,
                                                  autocorrect: false,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.all(15),
                                                    suffixIcon:
                                                        Icon(Icons.attach_file),
                                                    labelText:
                                                        "Seleccionar archivo(pdf,jpg,xls)",
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                  onTap: () async {
                                                    try {
                                                      FilePickerResult? rs =
                                                          await FilePicker
                                                              .platform
                                                              .pickFiles();
                                                      if (rs != null) {
                                                        File file = File(rs
                                                            .files
                                                            .single
                                                            .path!);

                                                        setState(() {
                                                          attachmentOneFile =
                                                              file;
                                                          if (attachmentOneFile !=
                                                              null) {
                                                            _attachmentOneController
                                                                    .text =
                                                                "Archivo Selecionado";
                                                          } else {
                                                            _attachmentOneController
                                                                .text = "";
                                                          }
                                                        });
                                                      }
                                                    } catch (e) {
                                                      setState(() {
                                                        attachmentOneFile =
                                                            null;
                                                        _attachmentOneController
                                                            .text = "";
                                                      });
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
                                                child: TextFormField(
                                                  controller:
                                                      _attachmentTwoController,
                                                  validator: (val) {
                                                    if (val!.isEmpty)
                                                      return 'Este campo es requerido';
                                                    return null;
                                                  },
                                                  readOnly: true,
                                                  autocorrect: false,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.all(15),
                                                    suffixIcon:
                                                        Icon(Icons.attach_file),
                                                    labelText:
                                                        "Seleccionar archivo(pdf,jpg,xls)",
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                  onTap: () async {
                                                    try {
                                                      FilePickerResult? rs =
                                                          await FilePicker
                                                              .platform
                                                              .pickFiles();
                                                      if (rs != null) {
                                                        File file = File(rs
                                                            .files
                                                            .single
                                                            .path!);
                                                        print(file);
                                                        setState(() {
                                                          attachmentTwoFile =
                                                              file;
                                                          if (attachmentTwoFile !=
                                                              null) {
                                                            _attachmentTwoController
                                                                    .text =
                                                                "Archivo Selecionado";
                                                          } else {
                                                            _attachmentTwoController
                                                                .text = "";
                                                          }
                                                        });
                                                      }
                                                    } catch (e) {
                                                      setState(() {
                                                        attachmentTwoFile =
                                                            null;
                                                        _attachmentTwoController
                                                            .text = "";
                                                      });
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
                                child: TextFormField(
                                  controller: _titleController,
                                  validator: (val) {
                                    if (val!.isEmpty)
                                      return 'Este campo es requerido';
                                    return null;
                                  },
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
                                child: TextFormField(
                                  controller: _authorsController,
                                  validator: (val) {
                                    if (val!.isEmpty)
                                      return 'Este campo es requerido';
                                    return null;
                                  },
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
                              Visibility(
                                  visible:
                                      (_researchSelected!.observation!.length >
                                          0),
                                  child: Divider()),
                              Visibility(
                                visible:
                                    (_researchSelected!.observation!.length >
                                        0),
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  child: Text("Observaciones del experto"),
                                ),
                              ),
                              Visibility(
                                visible:
                                    (_researchSelected!.observation!.length >
                                        0),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: TextFormField(
                                    controller: _observationController,
                                    minLines: 3,
                                    maxLines: 3,
                                    autocorrect: false,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(15),
                                      labelText: "Observaciones",
                                      border: OutlineInputBorder(),
                                    ),
                                    onTap: () {},
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : null),
              bottomNavigationBar: Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Actualizar ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Visibility(
                          visible: !isBusy,
                          child: Icon(
                            Icons.update,
                          )),
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
                  onPressed: () async {
                    if (_formUpdateResearch.currentState!.validate() &&
                        !isBusy) {
                      setState(() {
                        isBusy = true;
                      });
                      SessionManager? session =
                          await SessionManager.getInstance();
                      if (session != null) {
                        final userId = session.getUserId();
                        final request = ResearchEntity(
                            researchId: _researchSelected!.researchId,
                            expertId: expertSelected!.id,
                            speciality: expertSelected!.specialty,
                            researcherId: userId,
                            status: 1,
                            title: _titleController.text,
                            authors: _authorsController.text,
                            attachmentTwoFile: attachmentTwoFile,
                            attachmentOneFile: attachmentOneFile,
                            attachmentOne: _researchSelected!.attachmentOne,
                            attachmentTwo: _researchSelected!.attachmentTwo,
                            observation: _observationController.text);
                        print(request.toJson());
                        final success =
                            await ResearchApiProvider.putUpdateResearch(
                                context, request);
                        setState(() {
                          isBusy = false;
                        });
                        if (success) {
                          SessionManager? session =
                              await SessionManager.getInstance();
                          if (session != null) {
                            session
                                .setResearchId(_researchSelected!.researchId);
                            setState(() {
                              _researchId = _researchSelected!.researchId;
                              getDimensions =
                                  DimensionApiProvider.getDimensions(
                                      _researchId);
                            });
                            getDimensions!.then((value) {
                              if (value!.length > 0) {
                                hasDimensions = true;
                              } else {
                                hasDimensions = false;
                              }
                            });
                            _pageController.jumpToPage(4);
                          }
                        }
                      }
                    }
                  },
                ),
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(
                  Icons.call,
                ),
                onPressed: () async {
                  if (!await launchUrl(
                      Uri.parse("tel:${expertSelected!.phone}"))) {
                    throw 'Could not launch ${expertSelected!.phone}';
                  }
                },
              ),
            )
          ],
        ),
        bottomNavigationBar: _buildNavigationBar(),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    bool asdasd = false;
    switch (_currentIndex) {
      case 0:
      case 1:
        Dialogs.confirm(context,
                title: "¿Estás seguro?",
                message: 'Si aceptas la aplicación cerrará')
            .then((value) {
          if (value!) {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          }
        });
        break;
      case 2:
        onChangePage(1);
        break;
      case 3:
        Dialogs.confirm(context,
                title: "Mensaje de Confirmación",
                message:
                    "¿Está seguro de cancelar el registro de la investigación?")
            .then((value) {
          if (value!) {
            setState(() {
              getResearchByUserId = ResearchApiProvider.getResearchByUserId();
            });
            onChangePage(1);
          }
        });
        break;
      case 4:
        await ResearchApiProvider.getResearchById(_researchId).then((value) {
          onClearResearch();
          onSetResearch(value);
          setState(() {
            _researchSelected = value;
          });
        });
        await ExpertApiProvider.getExpertById(_researchSelected!.expertId)
            .then((valueAux) {
          print(valueAux);
          setState(() {
            expertSelected = valueAux;
            isUpdateComplete = true;
            _pageController.jumpToPage(5);
          });
        });
        break;
      case 5:
        Dialogs.confirm(context,
                title: "Mensaje de Confirmación",
                message:
                    "¿Está seguro de salir de la actualización de la investigación?")
            .then((value) {
          if (value!) {
            setState(() {
              getResearchByUserId = ResearchApiProvider.getResearchByUserId();
            });
            onChangePage(1);
          }
        });
        break;
      default:
        Dialogs.confirm(context,
                title: "¿Estás seguro?",
                message: 'Si aceptas la aplicación cerrará')
            .then((value) {
          print(value);
          if (value!) {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          }
        });
        break;
    }
    return asdasd;
  }

  onClearResearch() {
    setState(() {
      _expertId = null;
      expertSelected = null;
      attachmentOneFile = null;
      attachmentTwoFile = null;
      _attachmentOneController.text = "";
      _attachmentTwoController.text = "";
      _titleController.text = "";
      _authorsController.text = "";
      hasDimensions = false;
      isUpdateComplete = false;
    });
  }

  onSetResearch(ResearchEntity? researchEntity) {
    setState(() {
      attachmentOneFile = null;
      attachmentTwoFile = null;
      _attachmentOneController.text = "Archivo selecionado";
      _attachmentTwoController.text = "Archivo selecionado";
      _titleController.text = researchEntity!.title!;
      _authorsController.text = researchEntity.authors!;
      _observationController.text = researchEntity.observation!;
      hasDimensions = false;
    });
  }

  String onBuildStatusResearch(int? status) {
    String statudStr = "";
    switch (status) {
      case 1:
        statudStr = "CR";
        break;
      case 2:
        statudStr = "EN";
        break;
      case 3:
        statudStr = "AP";
        break;
      case 4:
        statudStr = "RE";
        break;
      case 5:
        statudStr = "ER";
        break;
      case 6:
        statudStr = "CO";
        break;
    }
    return statudStr;
  }

  Widget onBuildSubtitleResearch(ResearchEntity research) {
    Widget aaaaa;
    switch (research.status) {
      case 1:
        aaaaa = RichText(
          text: TextSpan(style: TextStyle(color: Colors.grey), children: [
            WidgetSpan(
              child: Icon(
                Icons.watch_later,
                size: 16,
                color: Colors.orange,
              ),
            ),
            TextSpan(text: " Creado   -   "),
            WidgetSpan(
              child: Icon(
                Icons.insert_invitation,
                size: 16,
              ),
            ),
            TextSpan(text: " ${onBuildStringToDate(research.updatedAt!)}")
          ]),
        );
        break;
      case 2:
        aaaaa = RichText(
          text: TextSpan(style: TextStyle(color: Colors.grey), children: [
            WidgetSpan(
              child: Icon(
                Icons.send,
                size: 16,
                color: Colors.green,
              ),
            ),
            TextSpan(text: " Enviado   -   "),
            WidgetSpan(
              child: Icon(
                Icons.insert_invitation,
                size: 16,
              ),
            ),
            TextSpan(text: " ${onBuildStringToDate(research.updatedAt!)}")
          ]),
        );
        break;
      case 3:
        aaaaa = RichText(
          text: TextSpan(style: TextStyle(color: Colors.grey), children: [
            WidgetSpan(
              child: Icon(
                Icons.check_circle_outline,
                size: 16,
                color: Colors.green,
              ),
            ),
            TextSpan(text: " Aprobado   -   "),
            WidgetSpan(
              child: Icon(
                Icons.insert_invitation,
                size: 16,
              ),
            ),
            TextSpan(text: " ${onBuildStringToDate(research.updatedAt!)}")
          ]),
        );
        break;
      case 4:
        aaaaa = RichText(
          text: TextSpan(style: TextStyle(color: Colors.grey), children: [
            WidgetSpan(
              child: Icon(
                Icons.remove_circle_outline,
                size: 16,
                color: Colors.red,
              ),
            ),
            TextSpan(text: " Rechazado   -   "),
            WidgetSpan(
              child: Icon(
                Icons.insert_invitation,
                size: 16,
              ),
            ),
            TextSpan(text: " ${onBuildStringToDate(research.updatedAt!)}")
          ]),
        );
        break;
      case 5:
        aaaaa = RichText(
          text: TextSpan(style: TextStyle(color: Colors.grey), children: [
            WidgetSpan(
              child: Icon(
                Icons.alarm,
                size: 16,
                color: Colors.red,
              ),
            ),
            TextSpan(text: " En revisión   -   "),
            WidgetSpan(
              child: Icon(
                Icons.insert_invitation,
                size: 16,
              ),
            ),
            TextSpan(text: " ${onBuildStringToDate(research.updatedAt!)}")
          ]),
        );
        break;
      case 6:
        aaaaa = RichText(
          text: TextSpan(style: TextStyle(color: Colors.grey), children: [
            WidgetSpan(
              child: Icon(
                Icons.cached,
                size: 16,
                color: Colors.red,
              ),
            ),
            TextSpan(text: " Corregir   -   "),
            WidgetSpan(
              child: Icon(
                Icons.insert_invitation,
                size: 16,
              ),
            ),
            TextSpan(text: " ${onBuildStringToDate(research.updatedAt!)}")
          ]),
        );
        break;
      default:
        aaaaa = Container();
        break;
    }
    return aaaaa;
  }

  String onBuildStringToDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return new DateFormat('dd/MM/yyyy').format(parsedDate);
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
    Widget asdasdasdas;
    switch (_currentIndex) {
      case 0:
        {
          asdasdasdas = AppBar(
            centerTitle: true,
            title: Text(
              "Mi Red",
            ),
          );
        }
        break;
      case 1:
        {
          asdasdasdas = AppBar(
            centerTitle: true,
            title: Text(
              "Mis Investigaciones",
            ),
          );
        }
        break;
      case 2:
        {
          asdasdasdas = AppBar(
            leading: BackButton(
              onPressed: () {
                onChangePage(1);
              },
            ),
            centerTitle: true,
            title: Text(
              "Seleciona un experto",
            ),
          );
        }
        break;
      case 3:
        asdasdasdas = AppBar(
          leading: BackButton(
            onPressed: () {
              Dialogs.confirm(context,
                      title: "Mensaje de Confirmación",
                      message:
                          "¿Está seguro de cancelar el registro de la investigación?")
                  .then((value) {
                if (value!) {
                  setState(() {
                    getResearchByUserId =
                        ResearchApiProvider.getResearchByUserId();
                  });
                  onChangePage(1);
                }
              });
            },
          ),
          centerTitle: true,
          title: Text(
            "Nueva investigación",
          ),
        );
        break;
      case 4:
        asdasdasdas = AppBar(
          leading: BackButton(
            onPressed: () async {
              // enviar a editar
              await ResearchApiProvider.getResearchById(_researchId)
                  .then((value) {
                onClearResearch();
                if (value != null) {
                  onSetResearch(value);
                  setState(() {
                    _researchSelected = value;
                  });
                }
              });
              await ExpertApiProvider.getExpertById(_researchSelected!.expertId)
                  .then((valueAux) {
                print(valueAux);
                setState(() {
                  expertSelected = valueAux;
                  print(expertSelected!.fullName);
                  isUpdateComplete = true;
                  _pageController.jumpToPage(5);
                });
              });
            },
          ),
          centerTitle: true,
          title: Text(
            "Dimensiones",
          ),
        );
        break;
      case 5:
        asdasdasdas = AppBar(
          leading: BackButton(
            onPressed: () {
              // enviar a editar
              Dialogs.confirm(context,
                      title: "Mensaje de Confirmación",
                      message:
                          "¿Está seguro de salir de la actualización de la investigación?")
                  .then((value) {
                if (value!) {
                  setState(() {
                    getResearchByUserId =
                        ResearchApiProvider.getResearchByUserId();
                  });
                  onChangePage(1);
                }
              });
            },
          ),
          centerTitle: true,
          title: Text(
            "Editar dimensiones",
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.delete_forever),
              color: Colors.red,
              onPressed: () {
                Dialogs.confirm(context,
                        title: "Confirmación",
                        message: "¿Está seguro de eliminar esta investigación?")
                    .then((value) {
                  if (value!) {
                    print(_researchId);
                    ResearchApiProvider.postDeleteResearch(context, _researchId)
                        .then((valueAux) {
                      if (valueAux) {
                        setState(() {
                          getResearchByUserId =
                              ResearchApiProvider.getResearchByUserId();
                        });
                        onChangePage(1);
                        Dialogs.alert(context,
                            title: "Éxito",
                            message: "La investigación fue eliminada");
                      }
                    });
                  }
                });
              },
            )
          ],
        );
        break;
      default:
        asdasdasdas = Container();
        break;
    }
    return asdasdasdas;
  }

  Widget? _buildNavigationBar() {
    switch (_currentIndex) {
      case 0:
      case 1:
        return BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: onChangePage,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.supervised_user_circle),
              label: "Mi red",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.folder_shared),
              label: "Mis Investigaciones",
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

  Widget? _buildDrawer() {
    switch (_currentIndex) {
      case 0:
      case 1:
        return Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Color.fromRGBO(136, 14, 79, 1),
          ),
          child: Drawer(
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: ListView(
                padding: EdgeInsets.all(10),
                children: [
                  FutureBuilder(
                    future: obtenerUsuario(),
                    builder: (_, snapshot) {
                      if (snapshot.hasData) {
                        final ExpertEntity oUser =
                            snapshot.data as ExpertEntity;
                        return DrawerHeader(
                          padding: EdgeInsets.only(top: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: (oUser.photo!.length <= 0)
                                    ? CircleAvatar(
                                        radius: 50,
                                        backgroundColor: Colors.amber,
                                        child: Text(
                                          onBuildLettersPicture(
                                              oUser.name, oUser.fullName),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 40),
                                        ),
                                        //child: Image.asset("assets/programmer.png"),
                                      )
                                    : CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            "${AppConfig.API_URL}public/${oUser.photo}"),
                                        backgroundColor: Colors.grey,
                                        radius: 50,
                                        //child: Image.asset("assets/programmer.png"),
                                      ),
                              ),
                              Container(
                                padding: EdgeInsets.all(5),
                                child: RichText(
                                  text: TextSpan(
                                    text: "Hola, ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            "${oUser.name!.split(" ")[0]} ${oUser.fullName!.split(" ")[0]} " +
                                                "\n",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "ORCID:${oUser.orcid!}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    },
                  ),
                  Container(
                    child: ListTile(
                      leading: Icon(
                        Icons.workspaces_outline,
                        color: Colors.white,
                      ),
                      title: Text(
                        "Tutorial",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      onTap: () async {
                        if (!await launchUrl(
                            Uri.parse(AppConfig.TUTORIAL_URL))) {
                          throw 'Could not launch ${expertSelected!.phone}';
                        }
                      },
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
                      onTap: () async {
                        await AuthApiProvider.logout(context);
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

Future obtenerUsuario() async {
  SessionManager? session = await SessionManager.getInstance();
  if (session != null) {
    ExpertEntity? oUser =
        await ExpertApiProvider.getExpertById(session.getUserId());
    return oUser;
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
