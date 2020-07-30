import 'package:dio/dio.dart';
import 'package:expert/src/models/requests/answer_request.dart';
import 'package:expert/src/models/solicitude_answer_entity.dart';
import 'package:expert/src/utils/dialogs.dart';
import 'package:flutter/material.dart';

import '../managers/http_manager.dart';

class AnswerApiProvider {
  static final HttpManager httpManager = HttpManager();

  static Future<List<SolicitudeAnswerEntity>> getAnswerBySolicitude(
      solicitudeId) async {
    try {
      final responseData =
          await httpManager.get("mobile/solicitude-answer/$solicitudeId");
      return SolicitudeAnswerEntity.fromJSONList(responseData["data"]);
    } catch (e) {
      print("Error ${e.message}");
      return null;
    }
  }

  static Future<bool> createAnswer(
    AnswerRequest answerRequest,
    BuildContext context,
  ) async {
    try {
      FormData formData = new FormData.fromMap(answerRequest.toJson());
      final file = answerRequest.file;

      if (file != null) {
        final multiPartFile = await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        );
        formData.files.add(MapEntry('file', multiPartFile));
      }

      await httpManager.postForm("mobile/answer", formData);
      return true;
    } catch (e) {
      print("Error ${e.message}");
      Dialogs.alert(context, title: "Error", message: e.message);
      return false;
    }
  }
}
