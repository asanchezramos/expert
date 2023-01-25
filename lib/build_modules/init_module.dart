import 'dart:async';
import 'dart:io';
import 'package:expert/build_modules/expert_module/home_expert.dart';
import 'package:expert/build_modules/expert_module/init_expert.dart';
import 'package:expert/build_modules/researcher_module/home_researcher.dart';
import 'package:expert/build_modules/researcher_module/init_researcher.dart';
import 'package:expert/src/app_config.dart';
import 'package:expert/src/managers/session_manager.dart';
import 'package:expert/src/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class InitModule extends StatefulWidget {
  @override
  _InitModuleState createState() => _InitModuleState();
}

class _InitModuleState extends State<InitModule> {
  bool isSelecion = false;
  bool isLoadingComplete = false;
  bool isRememberSession = false;
  late Timer _timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeDateFormatting();
    onValidateSession();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  onValidateSession() async {
    SessionManager? session = await SessionManager.getInstance();
    if (session != null) {
      bool validate = session.getRememberId()!;
      if (validate) {
        String? role = session.getRole();
        if (role == 'U') {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => HomeResearcherModule()));
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => HomeExpertModule()));
        }
      }
    }
  }

  Future<bool> _onBackPressed() async {
    Dialogs.confirm(context,
            title: "¿Estás seguro?",
            message: 'Si aceptas la aplicación cerrará')
        .then((value) {
      if (value!) {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      }
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: EdgeInsets.only(top: 100),
                  child: Column(
                    children: [
                      Container(
                        child: Hero(
                          tag: "logo",
                          child: Image.asset(
                            "assets/logo_v2.png",
                            width: 100,
                          ),
                        ),
                        margin: EdgeInsets.only(bottom: 10),
                      ),
                      Container(
                        child: Text(
                          "Juicio de Experto",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 6,
                              fontSize: 30),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "Te da la bienvenida.\n Elije la rama a la que perteneces para continuar.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                        child: Text(
                          "¿No sabes cuál elegir?",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      Container(
                        child: TextButton(
                          child: Text("Ver el tutorial aquí"),
                          onPressed: () async {
                            if (!await launchUrl(Uri.parse(AppConfig.TUTORIAL_URL))) {
                              throw 'Could not launch $AppConfig.TUTORIAL_URL';
                            } 
                          },
                        ),
                      ),
                    ],
                  )),
              Visibility(
                visible: isSelecion,
                child: CircularProgressIndicator(),
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(  
                        icon: Icon(
                          Icons.supervised_user_circle,
                        ),
                        label: Text(
                          "Experto",
                        ),
                        onPressed: () {
                          setState(() {
                            isSelecion = true;
                          });
                          _timer =
                              new Timer(const Duration(milliseconds: 400), () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        InitExpertModule()));
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: OutlinedButton.icon( 
                        icon: Icon(
                          Icons.featured_play_list,
                        ),
                        label: Text(
                          "Investigador",
                        ),
                        onPressed: () {
                          setState(() {
                            isSelecion = true;
                          });
                          _timer =
                              new Timer(const Duration(milliseconds: 400), () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        InitResearcherModule()));
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PermissionWidget extends StatefulWidget {
  /// Constructs a [PermissionWidget] for the supplied [Permission].
  const PermissionWidget(this._permission);

  final Permission _permission;

  @override
  _PermissionState createState() => _PermissionState(_permission);
}

class _PermissionState extends State<PermissionWidget> {
  _PermissionState(this._permission);

  final Permission _permission;
  PermissionStatus? _permissionStatus;

  @override
  void initState() {
    super.initState();

    _listenForPermissionStatus();
  }

  void _listenForPermissionStatus() async {
    final status = await _permission.status;
    setState(() => _permissionStatus = status);
  }

  Color getPermissionColor() {
    switch (_permissionStatus) {
      case PermissionStatus.denied:
        return Colors.red;
      case PermissionStatus.granted:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_permission.toString()),
      subtitle: Text(
        _permissionStatus.toString(),
        style: TextStyle(color: getPermissionColor()),
      ),
      trailing: IconButton(
          icon: const Icon(Icons.info),
          onPressed: () {
            checkServiceStatus(context, _permission);
          }),
      onTap: () {
        requestPermission(_permission);
      },
    );
  }

  void checkServiceStatus(BuildContext context, Permission permission) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text((await permission.status).toString()),
    ));
  }

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();

    setState(() {
      print(status);
      _permissionStatus = status;
      print(_permissionStatus);
    });
  }
}
