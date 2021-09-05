import 'package:dio/dio.dart';
import 'package:expert/src/models/dimension_entity.dart';
import 'package:expert/src/utils/dialogs.dart';
import 'package:flutter/cupertino.dart';

import '../managers/http_manager.dart';
import '../models/expert_entity.dart';

class DimensionApiProvider {
  static final HttpManager httpManager = HttpManager();

  static Future<List<DimensionEntity>> getDimensions(int researchId) async {
    try {
      final responseData = await httpManager.get("mobile/dimension/$researchId");
      return DimensionEntity.fromJSONList(responseData["data"]);
    } catch (e) {
      print("Error ${e.message}");
      return null;
    }
  }

  static Future<bool> postRegisterDimension(
      BuildContext context,
      DimensionEntity netReqEntity,
      ) async {
    try {
      FormData formData = new FormData.fromMap(netReqEntity.toJson());
      await httpManager.postForm("mobile/dimension", formData);
      return true;
    } catch (error) {
      Dialogs.alert(context, title: "Ocurrio un error", message: "No se puedo registrar la dimensión");
      return false;
    }
  }

  static Future<bool> postDeleteDimension(
      BuildContext context,
      int dimensionId,
      ) async {
    try {
      var s = await httpManager.delete("mobile/dimension-delete/$dimensionId");
      print(s);
      return true;
    } catch (error) {
      Dialogs.alert(context, title: "Ocurrio un error", message: "No se puedo eliminar la dimensión");
      return false;
    }
  }

  static Future<bool> putUpdateDimension(
      BuildContext context,
      DimensionEntity netReqEntity,
      ) async {
    try {
      FormData formData = new FormData.fromMap(netReqEntity.toJson());
      await httpManager.putForm("mobile/dimension-update-only/${netReqEntity.dimensionId}", formData);
      return true;
    } catch (error) {
      Dialogs.alert(context, title: "Ocurrio un error", message: "No se puedo actualizar la dimensión");
      return false;
    }
  }
}
