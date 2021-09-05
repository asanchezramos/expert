
import 'package:dio/dio.dart';
import 'package:expert/src/models/criterio_response_entity.dart';
import 'package:expert/src/utils/dialogs.dart';
import 'package:flutter/cupertino.dart';

import '../managers/http_manager.dart';

class CriterioResponseApiProvider {
  static final HttpManager httpManager = HttpManager();

  static Future<List<CriterioResponseEntity>> getCriterios(int researchId) async {
    try {
      final responseData = await httpManager.get("mobile/criterio-response-get/$researchId");
      return CriterioResponseEntity.fromJSONList(responseData["data"]);
    } catch (e) {
      print("Error ${e.message}");
      return null;
    }
  }
  static Future<bool> postRegisterCriterioResponse(
      BuildContext context,
      CriterioResponseEntity netReqEntity,
      ) async {
    try {
      FormData formData = new FormData.fromMap(netReqEntity.toJson());
      await httpManager.postForm("mobile/criterio-response", formData);
      return true;
    } catch (error) {
      Dialogs.alert(context, title: "Ocurrio un error", message: "No se puedo registrar la respuesta del criterio");
      return false;
    }
  }
  static Future<bool> putUpdateCriterioResponse(
      BuildContext context,
      CriterioResponseEntity netReqEntity,
      ) async {
    try {
      FormData formData = new FormData.fromMap(netReqEntity.toJson());
       await httpManager.putForm("mobile/criterio-response/${netReqEntity.criterioResponseId}", formData);
      return true;
    } catch (error) {
      Dialogs.alert(context, title: "Ocurrio un error", message: "No se puedo registrar la investigación");
      return false;
    }
  }
}