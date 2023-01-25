import 'package:dio/dio.dart';
import 'package:expert/src/managers/session_manager.dart';
import 'package:expert/src/models/requests/solicitude_request.dart';
import 'package:expert/src/models/user_solicitude_entity.dart';
import 'package:expert/src/utils/dialogs.dart';
import 'package:flutter/material.dart';

import '../managers/http_manager.dart';
import '../models/solicitude_entity.dart';

class SolicitudeApiProvider {
  static final HttpManager httpManager = HttpManager();

  static Future<List<SolicitudeEntity>?> getSolicitudesByUser() async {
    SessionManager? session = await SessionManager.getInstance();
    if (session != null) {
      try {
        final userId = session.getUserId();
        final responseData =
            await httpManager.get("mobile/solicitude/user/$userId");
        return SolicitudeEntity.fromJSONList(responseData["data"]);
      } catch (e) {
        return null;
      }
    }
  }

  static Future<List<SolicitudeEntity>?> getSolicitudesByExpert() async {
    SessionManager? session = await SessionManager.getInstance();
    if (session != null) {
      try {
        final userId = session.getUserId();
        final responseData =
            await httpManager.get("mobile/solicitude/expert/$userId");
        return SolicitudeEntity.fromJSONList(responseData["data"]);
      } catch (e) {
        return null;
      }
    }
  }

  static Future<List<UserSolicitudeEntity>?>
      getAllUserSolicitudesByExpert() async {
    SessionManager? session = await SessionManager.getInstance();
    if (session != null) {
      try {
        final userId = session.getUserId();
        final responseData =
            await httpManager.get("mobile/solicitude-user/$userId");
        return UserSolicitudeEntity.fromJSONList(responseData["data"]);
      } catch (e) {
        return null;
      }
    }
  }

  static Future<UserSolicitudeEntity?> getUserSolicitudeDetailByExpert(
      solicitudeId) async {
    try {
      final responseData =
          await httpManager.get("mobile/solicitude-user-expert/$solicitudeId");
      return UserSolicitudeEntity.fromJson2(responseData["data"][0]);
    } catch (e) {
      return null;
    }
  }

  static Future<bool> requestSolicitude(
    SolicitudeRequest solicitudeRequest,
    BuildContext context,
  ) async {
    SessionManager? session = await SessionManager.getInstance();
    if (session != null) {
      try {
        solicitudeRequest.userId = session.getUserId();
        FormData formData = new FormData.fromMap(solicitudeRequest.toJson());
        final repository = solicitudeRequest.repository;
        final investigation = solicitudeRequest.investigation;

        if (repository != null) {
          final multiPartFile = await MultipartFile.fromFile(
            repository.path,
            filename: repository.path.split('/').last,
          );
          formData.files.add(MapEntry('repository', multiPartFile));
        }
        if (investigation != null) {
          final multiPartFile = await MultipartFile.fromFile(
            investigation.path,
            filename: investigation.path.split('/').last,
          );
          formData.files.add(MapEntry('investigation', multiPartFile));
        }

        await httpManager.postForm("mobile/solicitude", formData);
        return true;
      } catch (e) {
        Dialogs.alert(context, title: "Error", message: "");
        return false;
      }
    } else {
      return false;
    }
  }

  static Future<bool> updateSolicitudeStatus(
    int? solicitudeId,
    String status,
  ) async {
    try {
      await httpManager.put("mobile/solicitude/$solicitudeId/$status");
      return true;
    } catch (e) { 
      return false;
    }
  }
}
