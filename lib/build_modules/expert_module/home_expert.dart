import 'dart:io';
import 'package:expert/build_modules/expert_module/expert_profile.dart';
import 'package:expert/build_modules/expert_module/firma_expert.dart';
import 'package:expert/build_modules/researcher_module/perfil_expert.dart';
import 'package:expert/src/api/auth_api_provider.dart';
import 'package:expert/src/app_config.dart';
import 'package:expert/src/managers/session_manager.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:expert/build_modules/expert_module/init_expert.dart';
import 'package:expert/build_modules/expert_module/notification_expert.dart';
import 'package:expert/build_modules/expert_module/response_expert.dart';
import 'package:expert/src/api/criterio_api_provider.dart';
import 'package:expert/src/api/criterio_response_api_provider.dart';
import 'package:expert/src/api/dimension_api_provider.dart';
import 'package:expert/src/api/expert_api_provider.dart';
import 'package:expert/src/api/network_api_provider.dart';
import 'package:expert/src/api/research_api_provider.dart';
import 'package:expert/src/models/criterio_entity.dart';
import 'package:expert/src/models/criterio_response_entity.dart';
import 'package:expert/src/models/dimension_entity.dart';
import 'package:expert/src/models/expert_entity.dart';
import 'package:expert/src/models/research_entity.dart';
import 'package:expert/src/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool isUpdateComplete = false;
  ExpertEntity? expertSelected = ExpertEntity();
  ResearchEntity? _researchSelected = ResearchEntity();
  List<CriterioResponseEntity>? _criteriosResponse = [];

  bool isBusy = false;
  bool isBusyOne = false;
  bool isBusyTwo = false;
  Future<List<CriterioEntity>?>? getCriterio;
  Future<List<ExpertEntity>?> getNetworkByUserId =
      NetworkApiProvider.getNetworkExpert();
  Future<List<ResearchEntity>?> getResearchByUserId =
      ResearchApiProvider.getResearchByExpertId();
  Future<List<DimensionEntity>?>? getDimensions;
  List<FocusNode> _focusNodes =
      List<FocusNode>.generate(1, (int index) => FocusNode());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
              body: RefreshIndicator(
                child: FutureBuilder(
                  future: getNetworkByUserId,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<ExpertEntity>? aaa =
                          snapshot.data as List<ExpertEntity>;
                      if (aaa.length <= 0) {
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
                                    text: "No tienes contactos en tu red",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return ListView.builder(
                            itemCount: aaa.length,
                            itemBuilder: (context, index) {
                              ExpertEntity element = aaa[index];
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
                                        "Investigador ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
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
                    getNetworkByUserId = NetworkApiProvider.getNetworkExpert();
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
                      List<ResearchEntity>? vvv =
                          snapshot.data as List<ResearchEntity>;
                      if (vvv.length <= 0) {
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
                                        "No cuentas con investigaciones para revisión",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return ListView.builder(
                            itemCount: vvv.length,
                            itemBuilder: (context, index) {
                              ResearchEntity element = vvv[index];
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

                                      break;
                                    case 6:
                                      Dialogs.alert(
                                        context,
                                        title: "Enviado a corregir",
                                        message:
                                            "Podrás revisar esta investigación cuando se corrija",
                                      );
                                      break;
                                    case 5:
                                    case 2:
                                      await ResearchApiProvider.getResearchById(
                                              element.researchId)
                                          .then((value) {
                                        setState(() {
                                          _researchSelected = value;
                                        });
                                      });
                                      await ExpertApiProvider.getExpertById(
                                              _researchSelected!.expertId)
                                          .then((valueAux) {
                                        setState(() {
                                          expertSelected = valueAux;
                                          _pageController.jumpToPage(2);
                                          isUpdateComplete = true;
                                        });
                                      });
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
                        ResearchApiProvider.getResearchByExpertId();
                  });
                },
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
                  child: isUpdateComplete
                      ? ListView(
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
                                    child: (expertSelected!.photo!.length <= 0)
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
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                            ),
                            Divider(),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Text(
                                "\"${_researchSelected!.title}\"",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Text(
                                "Autores: ${_researchSelected!.authors}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                            ),
                            Divider(),
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            padding: EdgeInsets.all(15),
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
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(10),
                                                child: ElevatedButton.icon(
                                                    onPressed: () async {
                                                      setState(() {
                                                        isBusyOne = true;
                                                      });
                                                      try {
                                                        var data = await http
                                                            .get(Uri.parse(
                                                                "${AppConfig.API_URL}public/${_researchSelected!.attachmentOne}"));
                                                        var bytes =
                                                            data.bodyBytes;
                                                        var dir =
                                                            await getApplicationDocumentsDirectory();
                                                        print(dir.path);
                                                        File file = File(
                                                            "/storage/emulated/0/Download/${_researchSelected!.attachmentOne}");
                                                        await file.writeAsBytes(
                                                            bytes);
                                                        setState(() {
                                                          isBusyOne = false;
                                                        });
                                                        Dialogs.alert(context,
                                                            title: "Éxito",
                                                            message:
                                                                "El archivo se guardó en descargas");
                                                      } catch (e) {
                                                        setState(() {
                                                          isBusyOne = false;
                                                        });
                                                        Dialogs.alert(context,
                                                            title: "Error",
                                                            message:
                                                                "No se pudo guardar el archivo");
                                                      }
                                                    },
                                                    icon: Icon(
                                                        Icons.cloud_download),
                                                    label: Text("Descargar")),
                                              ),
                                              Visibility(
                                                visible: isBusyOne,
                                                child: Padding(
                                                  padding: EdgeInsets.all(10),
                                                ),
                                              ),
                                              Visibility(
                                                visible: isBusyOne,
                                                child: Container(
                                                    height: 20,
                                                    width: 20,
                                                    child:
                                                        CircularProgressIndicator()),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            padding: EdgeInsets.all(15),
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
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(10),
                                                child: ElevatedButton.icon(
                                                    onPressed: () async {
                                                      setState(() {
                                                        isBusyTwo = true;
                                                      });
                                                      try {
                                                        var data = await http
                                                            .get(Uri.parse(
                                                                "${AppConfig.API_URL}public/${_researchSelected!.attachmentTwo}"));
                                                        var bytes =
                                                            data.bodyBytes;
                                                        var dir =
                                                            await getApplicationDocumentsDirectory();
                                                        print(dir.path);
                                                        File file = File(
                                                            "/storage/emulated/0/Download/${_researchSelected!.attachmentTwo}");
                                                        await file.writeAsBytes(
                                                            bytes);
                                                        setState(() {
                                                          isBusyTwo = false;
                                                        });
                                                        Dialogs.alert(context,
                                                            title: "Éxito",
                                                            message:
                                                                "El archivo se guardó en descargas");
                                                      } catch (e) {
                                                        setState(() {
                                                          isBusyTwo = false;
                                                        });
                                                        Dialogs.alert(context,
                                                            title: "Error",
                                                            message:
                                                                "No se pudo guardar el archivo");
                                                      }
                                                    },
                                                    icon: Icon(
                                                        Icons.cloud_download),
                                                    label: Text("Descargar")),
                                              ),
                                              Visibility(
                                                visible: isBusyTwo,
                                                child: Padding(
                                                  padding: EdgeInsets.all(10),
                                                ),
                                              ),
                                              Visibility(
                                                visible: isBusyTwo,
                                                child: Container(
                                                    height: 20,
                                                    width: 20,
                                                    child:
                                                        CircularProgressIndicator()),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )),
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
                    setState(() {
                      isBusy = true;
                    });
                    final request = ResearchEntity(
                        researchId: _researchSelected!.researchId,
                        status: 5,
                        observation: "");
                    await ResearchApiProvider.putUpdateResearchRevision(
                        context, request);

                    await CriterioResponseApiProvider.getCriterios(
                            _researchSelected!.researchId)
                        .then((value) {
                      setState(() {
                        getCriterio = CriterioApiProvider.getCriterios(
                            _researchSelected!.speciality,
                            _researchSelected!.expertId);
                        _criteriosResponse = value;
                        getDimensions = DimensionApiProvider.getDimensions(
                            _researchSelected!.researchId);
                        getDimensions!.then((value) {
                          _focusNodes = List<FocusNode>.generate(
                              value!.length, (int index) => FocusNode());
                        });
                      });
                    });
                    _pageController.jumpToPage(3);

                    setState(() {
                      isBusy = false;
                    });
                  },
                ),
              ),
            ),
            Scaffold(
              body: RefreshIndicator(
                onRefresh: () async {
                  await CriterioResponseApiProvider.getCriterios(
                          _researchSelected!.researchId)
                      .then((value) {
                    setState(() {
                      _criteriosResponse = value;
                      getDimensions = DimensionApiProvider.getDimensions(
                          _researchSelected!.researchId);
                    });
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
                                    text: "No se encontraron dimensiones",
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
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 5.0),
                                title: Text(
                                  value!,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          itemBuilder: (c, element) {
                            return Card(
                              elevation: 2.0,
                              margin: new EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 6.0),
                              child: Container(
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  title: Text(element.variable),
                                  subtitle: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                      ),
                                      FutureBuilder(
                                        future: getCriterio,
                                        builder: (_, snapshot) {
                                          if (snapshot.hasData) {
                                            List<CriterioEntity>? fff = snapshot
                                                .data as List<CriterioEntity>;
                                            return ListView.builder(
                                                physics:
                                                    ClampingScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: fff.length,
                                                itemBuilder: (context, index) {
                                                  CriterioEntity
                                                      elementCriterio =
                                                      fff[index];
                                                  return ListTile(
                                                      leading: Icon(
                                                        Icons.filter_tilt_shift,
                                                        color: Colors.green,
                                                      ),
                                                      title: Text(
                                                          elementCriterio
                                                              .name!),
                                                      subtitle:
                                                          onBuildSubtitleDimension(
                                                              element,
                                                              elementCriterio,
                                                              0));
                                                });
                                          } else {
                                            return Container(
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ],
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
              bottomNavigationBar: Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        " Siguientes ",
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
                    Future.delayed(const Duration(milliseconds: 200), () async {
                      int isApplicate = await onValidateIsApplicate();
                      print(isApplicate);
                      if (isApplicate != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ResponseExpert(
                                        _researchSelected,
                                        expertSelected,
                                        isApplicate))).then((value) {
                          if (value != null) {
                            setState(() {
                              getResearchByUserId =
                                  ResearchApiProvider.getResearchByExpertId();
                            });
                            onChangePage(1);
                          }
                        });
                      }
                      setState(() {
                        isBusy = false;
                      });
                    });
                  },
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: _buildNavigationBar(),
      ),
    );
  }

  onValidateIsApplicate() async {
    int? validateResp;
    int dimensionLength = 0;
    await getDimensions!.then((value) {
      dimensionLength = value!.length;
    });
    await getCriterio!.then((value) {
      dimensionLength = value!.length * dimensionLength;
    });
    int criterioResponseLength = _criteriosResponse!.length;
    if (criterioResponseLength < dimensionLength) {
      Dialogs.alert(context,
          title: "Alerta", message: "Debe calificar todos los criterios");
      validateResp = null;
    } else {
      int validate = 0;
      int invalidate = 0;
      _criteriosResponse!.forEach((element) {
        switch (element.status) {
          case 'A':
            validate = validate + 1;
            break;
          case 'R':
            invalidate = invalidate + 1;
            break;
          default:
            break;
        }
      });

      if (validate == _criteriosResponse!.length) {
        validateResp = 1;
      } else if (invalidate == _criteriosResponse!.length) {
        validateResp = 2;
      } else {
        validateResp = 3;
      }
    }
    return validateResp;
  }

  onFindCriterioResponse(int? criterioId, int? dimensionId) {
    int index = _criteriosResponse!.indexWhere((element) =>
        element.criterioId == criterioId && element.dimensionId == dimensionId);
    if (index == -1) {
      return null;
    } else {
      return _criteriosResponse![index];
    }
  }

  onGetStatusDimension(CriterioResponseEntity criterioResponse) {
    String statusStr = "";
    switch (criterioResponse.status) {
      case "A":
        statusStr = "Aprobado";
        break;
      case "R":
        statusStr = "Rechazado";
        break;
    }
    return statusStr;
  }

  Widget onBuildSubtitleDimension(
      DimensionEntity dimension, CriterioEntity criterio, int indexDimension) {
    final CriterioResponseEntity? criterioResponse =
        onFindCriterioResponse(criterio.criterioId, dimension.dimensionId);
    if (criterioResponse != null) {
      return Focus(
        focusNode: _focusNodes[indexDimension],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
                child: RichText(
              text: TextSpan(
                  style: TextStyle(fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: onGetStatusDimension(criterioResponse),
                      style: TextStyle(
                          color: (criterioResponse.status == 'R')
                              ? Colors.red
                              : Colors.green),
                    )
                  ]),
            )),
            Spacer(),
            Visibility(
              visible: (criterioResponse.status == 'R'),
              child: IconButton(
                icon: Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                onPressed: () async {
                  final netReqEntity = CriterioResponseEntity(
                      criterioResponseId: criterioResponse.criterioResponseId,
                      criterioId: criterio.criterioId,
                      dimensionId: dimension.dimensionId,
                      expertId: expertSelected!.id,
                      researchId: _researchSelected!.researchId,
                      status: "A");
                  await CriterioResponseApiProvider.putUpdateCriterioResponse(
                      context, netReqEntity);
                  await CriterioResponseApiProvider.getCriterios(
                          _researchSelected!.researchId)
                      .then((value) {
                    setState(() {
                      _criteriosResponse = value;
                      getDimensions = DimensionApiProvider.getDimensions(
                          _researchSelected!.researchId);
                    });
                  });

                  _focusNodes[indexDimension].requestFocus();
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
            ),
            Visibility(
              visible: (criterioResponse.status != 'A'),
              child: Padding(
                padding: EdgeInsets.all(24),
              ),
            ),
            Visibility(
              visible: (criterioResponse.status == 'A'),
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.red,
                ),
                onPressed: () async {
                  final netReqEntity = CriterioResponseEntity(
                      criterioResponseId: criterioResponse.criterioResponseId,
                      criterioId: criterio.criterioId,
                      dimensionId: dimension.dimensionId,
                      expertId: expertSelected!.id,
                      researchId: _researchSelected!.researchId,
                      status: "R");
                  await CriterioResponseApiProvider.putUpdateCriterioResponse(
                      context, netReqEntity);
                  await CriterioResponseApiProvider.getCriterios(
                          _researchSelected!.researchId)
                      .then((value) {
                    setState(() {
                      _criteriosResponse = value;
                      getDimensions = DimensionApiProvider.getDimensions(
                          _researchSelected!.researchId);
                    });
                  });
                },
              ),
            )
          ],
        ),
      );
    } else {
      return Focus(
        focusNode: _focusNodes[indexDimension],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
                child: RichText(
              text: TextSpan(
                  style: TextStyle(fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: "En revisión ",
                      style: TextStyle(color: Colors.deepOrange),
                    )
                  ]),
            )),
            Spacer(),
            IconButton(
              icon: Icon(
                Icons.check,
                color: Colors.green,
              ),
              onPressed: () async {
                final netReqEntity = CriterioResponseEntity(
                    criterioId: criterio.criterioId,
                    dimensionId: dimension.dimensionId,
                    expertId: expertSelected!.id,
                    researchId: _researchSelected!.researchId,
                    status: "A");
                await CriterioResponseApiProvider.postRegisterCriterioResponse(
                    context, netReqEntity);
                await CriterioResponseApiProvider.getCriterios(
                        _researchSelected!.researchId)
                    .then((value) {
                  setState(() {
                    _criteriosResponse = value;
                    getDimensions = DimensionApiProvider.getDimensions(
                        _researchSelected!.researchId);
                  });
                });
              },
            ),
            Padding(
              padding: EdgeInsets.all(20),
            ),
            IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.red,
              ),
              onPressed: () async {
                final netReqEntity = CriterioResponseEntity(
                    criterioId: criterio.criterioId,
                    dimensionId: dimension.dimensionId,
                    expertId: expertSelected!.id,
                    researchId: _researchSelected!.researchId,
                    status: "R");
                await CriterioResponseApiProvider.postRegisterCriterioResponse(
                    context, netReqEntity);
                await CriterioResponseApiProvider.getCriterios(
                        _researchSelected!.researchId)
                    .then((value) {
                  setState(() {
                    _criteriosResponse = value;
                    getDimensions = DimensionApiProvider.getDimensions(
                        _researchSelected!.researchId);
                  });
                });
              },
            )
          ],
        ),
      );
    }
  }

  Future<bool> _onBackPressed() async {
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
        Dialogs.confirm(context,
                title: "Mensaje de Confirmación",
                message:
                    "¿Está seguro de salir de la revisión de la investigación?")
            .then((value) {
          if (value!) {
            setState(() {
              getResearchByUserId = ResearchApiProvider.getResearchByExpertId();
            });
            onChangePage(1);
          }
        });
        break;
      case 3:
        onChangePage(2);
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
    return true;
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

  String onBuildStatusResearch(int? status) {
    String statudStr = "";
    switch (status) {
      case 1:
        statudStr = "CR";
        break;
      case 2:
        statudStr = "ER";
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
    Widget widgetaux;
    switch (research.status) {
      case 1:
        widgetaux = RichText(
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
        widgetaux = RichText(
          text: TextSpan(style: TextStyle(color: Colors.grey), children: [
            WidgetSpan(
              child: Icon(
                Icons.mail_outline,
                size: 16,
                color: Colors.green,
              ),
            ),
            TextSpan(text: " Por revisar   -   "),
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
        widgetaux = RichText(
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
        widgetaux = RichText(
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
        widgetaux = RichText(
          text: TextSpan(style: TextStyle(color: Colors.grey), children: [
            WidgetSpan(
              child: Icon(
                Icons.alarm,
                size: 16,
                color: Colors.red,
              ),
            ),
            TextSpan(text: " Revisando   -   "),
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
        widgetaux = RichText(
          text: TextSpan(style: TextStyle(color: Colors.grey), children: [
            WidgetSpan(
              child: Icon(
                Icons.cached,
                size: 16,
                color: Colors.red,
              ),
            ),
            TextSpan(text: " Enviado a corregir   -   "),
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
        widgetaux = Container();
        break;
    }
    return widgetaux;
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
    Widget auxWidget;
    switch (_currentIndex) {
      case 0:
        {
          auxWidget = AppBar(
            actions: [
              IconButton(
                icon: Icon(Icons.markunread_mailbox),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              NotificationExpert())).then((value) {
                    setState(() {
                      getNetworkByUserId =
                          NetworkApiProvider.getNetworkExpert();
                    });
                  });
                },
              )
            ],
            centerTitle: true,
            title: Text(
              "Mi Red",
            ),
          );
        }
        break;
      case 1:
        {
          auxWidget = AppBar(
            centerTitle: true,
            title: Text(
              "Mis Revisiones",
            ),
          );
        }
        break;
      case 2:
        {
          auxWidget = AppBar(
            leading: BackButton(
              onPressed: () {
                Dialogs.confirm(context,
                        title: "Mensaje de Confirmación",
                        message:
                            "¿Está seguro de salir de la revisión de la investigación?")
                    .then((value) {
                  if (value!) {
                    setState(() {
                      getResearchByUserId =
                          ResearchApiProvider.getResearchByExpertId();
                    });
                    onChangePage(1);
                  }
                });
              },
            ),
            centerTitle: true,
            title: Text(
              "Datos de la investigación",
            ),
          );
        }
        break;
      case 3:
        auxWidget = AppBar(
          leading: BackButton(
            onPressed: () {
              onChangePage(2);
            },
          ),
          centerTitle: true,
          title: Text(
            "Revisión de dimensiones",
          ),
        );
        break;
      default:
        auxWidget = Container();
        break;
    }
    return auxWidget;
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
              label: "Mis Revisiones",
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
            canvasColor: Color.fromRGBO(136, 14, 79,
                1), //This will change the drawer background to blue.
            //other styles
          ),
          child: Drawer(
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: FutureBuilder(
                future: obtenerUsuario(),
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    final ExpertEntity oUser = snapshot.data as ExpertEntity;
                    return ListView(
                      children: [
                        DrawerHeader(
                          padding: EdgeInsets.only(top: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: (oUser.photo!.length <= 0)
                                    ? CircleAvatar(
                                        radius: 50,
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
                                    text: "Hola,",
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            "${oUser.name!.split(" ")[0]} ${oUser.fullName!.split(" ")[0]}" + "\n",
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "ORCID:${oUser.orcid!}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16,
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
                              Icons.contact_mail,
                              color: Colors.white,
                            ),
                            title: Text(
                              "Mi perfil",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onTap: () async {
                              Navigator.of(context).pop();
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ExpertProfile(oUser)))
                                  .then((value) {});
                            },
                          ),
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
                              ),
                            ),
                            onTap: () async {
                              if (!await launchUrl(
                                  Uri.parse(AppConfig.TUTORIAL_URL))) {
                                throw 'Could not launch ${AppConfig.TUTORIAL_URL}';
                              }
                            },
                          ),
                        ),
                        Container(
                          child: ListTile(
                            leading: Icon(
                              Icons.attractions,
                              color: Colors.white,
                            ),
                            title: Text(
                              "Firma Digital",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onTap: () async {
                              Navigator.of(context).pop();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          FirmaExperto())).then((value) {});
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
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onTap: () async {
                              await AuthApiProvider.logout(context);
                            },
                          ),
                        )
                      ],
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
