import 'package:dio/dio.dart';
import 'package:expert/build_modules/expert_module/init_expert.dart';
import 'package:expert/build_modules/researcher_module/init_researcher.dart';
import 'package:expert/src/pages/expert/pages/login_expert_page.dart';
import 'package:expert/src/pages/student/Pages/login_student_page.dart';
import 'package:flutter/material.dart';

import '../managers/http_manager.dart';
import '../managers/session_manager.dart';
import '../managers/token_manager.dart';
import '../models/requests/login_request.dart';
import '../models/requests/sign_up_request.dart';
import '../models/user_entity.dart';
import '../utils/dialogs.dart';

class AuthApiProvider {
  final HttpManager httpManager = HttpManager();

  Future<bool> register(
    BuildContext context,
    SignUpRequest signUpRequest,
  ) async {
    try {
      FormData formData = new FormData.fromMap(signUpRequest.toJson());
      final file = signUpRequest.file;

      if (file != null) {
        final multiPartFile = await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        );
        formData.files.add(MapEntry('file', multiPartFile));
      }
      print(formData);
      await httpManager.postForm("auth/register", formData);
      return true;
    } catch (error) {
      Dialogs.alert(context,
          title: "Ocurrio un error", message: "No se pudo crear el usuario");
      return false;
    }
  }

  Future<bool> loginStudent(
    BuildContext context,
    LoginRequest loginRequest,
  ) async {
    try {
      final responseData = await httpManager.post(
        "auth/login",
        loginRequest.toJson(),
      );
      final token = responseData['token'] as String?;
      final user = UserEntity.fromJson(responseData['data']);

      if (user.role == "U") {
        await TokenManager.getInstance()!.setToken(token);
        SessionManager? session = await SessionManager.getInstance();
        if (session != null) {
          await session.setUserId(user.id);
          await session.setRole(user.role);
        }
        return true;
      } else {
        Dialogs.alert(
          context,
          title: "Error de inicio sesión",
          message: "Acceso sólo para investigadores",
        );
        return false;
      }
    } catch (error) {
      Dialogs.alert(context,
          title: "Error de inicio sesión",
          message: "El usuario y/o contraseña incorrectos");
      return false;
    }
  }

  Future<bool> loginExpert(
    BuildContext context,
    LoginRequest loginRequest,
  ) async {
    try {
      final responseData = await httpManager.post(
        "auth/login",
        loginRequest.toJson(),
      );
      final token = responseData['token'] as String?;
      final user = UserEntity.fromJson(responseData['data']);

      if (user.role == "E") {
        await TokenManager.getInstance()!.setToken(token);
        SessionManager? session = await SessionManager.getInstance();
        if (session != null) {
          await session.setUserId(user.id);
          await session.setRole(user.role);
        }
        return true;
      } else {
        Dialogs.alert(
          context,
          title: "Error de inicio sesión",
          message: "Acceso sólo para expertos",
        );
        return false;
      }
    } catch (error) {
      Dialogs.alert(context,
          title: "Error de inicio sesión",
          message: "El usuario y/o contraseña incorrectos");
      return false;
    }
  }

  static Future logout(context) async {
    Widget nextPage;
    await TokenManager.getInstance()!.cleanToken();
    SessionManager? session = await SessionManager.getInstance();
    if (session != null) {
      final role = session.getRole();
      if (role == "U") {
        nextPage = InitResearcherModule();
      } else {
        nextPage = InitExpertModule();
      }
      await session.clear();
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => nextPage));
    }
  }
}
