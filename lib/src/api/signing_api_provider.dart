import 'package:dio/dio.dart';
import 'package:expert/src/managers/session_manager.dart';
import 'package:expert/src/models/signing_entity.dart';
import 'package:expert/src/utils/dialogs.dart';
import 'package:flutter/material.dart';

import '../managers/http_manager.dart';

class SigningApiProvider {
  static final HttpManager httpManager = HttpManager();

  static Future<List<SigningEntity>?> getSigningByUser() async {
    SessionManager? session = await SessionManager.getInstance();
    if (session != null) {
      try {
        final userId = session.getUserId();
        final responseData =
            await httpManager.get("mobile/signing-get/$userId");
        return SigningEntity.fromJSONList(responseData["data"]);
      } catch (e) {
        return null;
      }
    }
  }

  static Future<List<SigningEntity>?> getSigningByExpert(userId) async {
    try {
      final responseData = await httpManager.get("mobile/signing-get/$userId");
      return SigningEntity.fromJSONList(responseData["data"]);
    } catch (e) { 
      return null;
    }
  }

  static Future<bool> createSigning(
    BuildContext context,
    SigningEntity signingEntity,
  ) async {
    try {
      FormData formData = new FormData.fromMap(signingEntity.toJson());
      final repository = signingEntity.fileSigning;

      if (repository != null) {
        final multiPartFile = await MultipartFile.fromFile(
          repository.path,
          filename: repository.path.split('/').last,
        );
        formData.files.add(MapEntry('fileSigning', multiPartFile));
      }
      await httpManager.postForm("mobile/signing-create", formData);
      return true;
    } catch (e) { 
      Dialogs.alert(context, title: "Error", message: "");
      return false;
    }
  }

  static Future<bool> updateSigning(
    BuildContext context,
    SigningEntity netReqEntity,
  ) async {
    try {
      FormData formData = new FormData.fromMap(netReqEntity.toJson());
      final repository = netReqEntity.fileSigning;
      if (repository != null) {
        final multiPartFile = await MultipartFile.fromFile(
          repository.path,
          filename: repository.path.split('/').last,
        );
        formData.files.add(MapEntry('fileSigning', multiPartFile));
      }
      final responseData = await httpManager.putForm(
          "mobile/signing-update/${netReqEntity.signingId}", formData);
      return true;
    } catch (error) {
      Dialogs.alert(context,
          title: "Ocurrio un error",
          message: "No se puedo actualizar la firma");
      return false;
    }
  }
}
