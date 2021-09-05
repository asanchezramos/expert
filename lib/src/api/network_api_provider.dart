import 'package:dio/dio.dart';
import 'package:expert/src/managers/session_manager.dart';
import 'package:expert/src/models/network_request_entity.dart';
import 'package:expert/src/utils/dialogs.dart';
import 'package:flutter/cupertino.dart';

import '../managers/http_manager.dart';
import '../models/expert_entity.dart';

class NetworkApiProvider {
  static final HttpManager httpManager = HttpManager();

  static Future<List<ExpertEntity>> getNetworkByUserId() async {
    final session = await SessionManager.getInstance();
    final userId =  session.getUserId();
    try {
      final responseData = await httpManager.get("mobile/network/$userId");
      return ExpertEntity.fromJSONList(responseData["data"]);
    } catch (e) {
      print("Error ${e.message}");
      return null;
    }
  }
  static Future<bool> postRegisterNetwork(
      BuildContext context,
      NetworkRequestEntity netReqEntity,
      ) async {
    try {
      FormData formData = new FormData.fromMap(netReqEntity.toJson());
      await httpManager.postForm("mobile/networkrequest", formData);
      return true;
    } catch (error) {
      Dialogs.alert(context, title: "Ocurrio un error", message: "La solicitud ya fué enviada");
      return false;
    }
  }
  static Future<bool> putNetworkRequestResponse(
      BuildContext context,
      NetworkRequestEntity netReqEntity,
      ) async {
    try {
      FormData formData = new FormData.fromMap(netReqEntity.toJson());
      await httpManager.putForm("mobile/network-request-response/${netReqEntity.userBaseId}/${netReqEntity.userRelationId}", formData);
      return true;
    } catch (error) {
      Dialogs.alert(context, title: "Error", message: "No se pudo aceptar la solicitud");
      return false;
    }
  }
  static Future<List<ExpertEntity>> getNetworkExpert() async {
    final session = await SessionManager.getInstance();
    final userId =  session.getUserId();
    try {
      final responseData = await httpManager.get("mobile/network-request/${userId}");
      return ExpertEntity.fromJSONList(responseData["data"]);
    } catch (e) {
      print("Error ${e.message}");
      return null;
    }
  }
  static Future<List<ExpertEntity>> getNetworkRequestExpert() async {
    final session = await SessionManager.getInstance();
    final userId =  session.getUserId();
    try {
      final responseData = await httpManager.get("mobile/network-request-expert/${userId}");
      return ExpertEntity.fromJSONList(responseData["data"]);
    } catch (e) {
      print("Error ${e.message}");
      return null;
    }
  }
}