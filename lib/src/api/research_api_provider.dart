
import 'package:dio/dio.dart';
import 'package:expert/src/managers/session_manager.dart';
import 'package:expert/src/models/research_entity.dart';
import 'package:expert/src/utils/dialogs.dart';
import 'package:flutter/cupertino.dart';

import '../managers/http_manager.dart';

class ResearchApiProvider {
  static final HttpManager httpManager = HttpManager();

  static Future<List<ResearchEntity>> getResearchByUserId() async {
    final session = await SessionManager.getInstance();
    final userId =  session.getUserId();
    try {
      final responseData = await httpManager.get("mobile/research/$userId");
      return ResearchEntity.fromJSONList(responseData["data"]);
    } catch (e) {
      print("Error ${e.message}");
      return null;
    }
  }

  static Future<List<ResearchEntity>> getResearchByExpertId() async {
    final session = await SessionManager.getInstance();
    final userId =  session.getUserId();
    try {
      final responseData = await httpManager.get("mobile/research-revision/$userId");
      return ResearchEntity.fromJSONList(responseData["data"]);
    } catch (e) {
      print("Error ${e.message}");
      return null;
    }
  }
  static Future<bool> postRegisterResearch(
      BuildContext context,
      ResearchEntity netReqEntity,
      ) async {
    try {
      FormData formData = new FormData.fromMap(netReqEntity.toJson());
      final fileOne = netReqEntity.attachmentOneFile;

      if (fileOne != null) {
        final multiPartFileOne = await MultipartFile.fromFile(
          fileOne.path,
          filename: fileOne.path.split('/').last,
        );
        formData.files.add(MapEntry('attachmentOne', multiPartFileOne));
      }
      final fileTwo = netReqEntity.attachmentTwoFile;

      if (fileTwo != null) {
        final multiPartFileTwo = await MultipartFile.fromFile(
          fileTwo.path,
          filename: fileTwo.path.split('/').last,
        );
        formData.files.add(MapEntry('attachmentTwo', multiPartFileTwo));
      }
      final responseData = await httpManager.postForm("mobile/research", formData);
      final session = await SessionManager.getInstance();
      final int researcherId = responseData['data'] as int;
      await session.setResearchId(researcherId);
      return true;
    } catch (error) {
      Dialogs.alert(context, title: "Ocurrio un error", message: "No se puedo registrar la investigación");
      return false;
    }
  }

  static Future<bool> putUpdateResearch(
      BuildContext context,
      ResearchEntity netReqEntity,
      ) async {
    try {
      FormData formData = new FormData.fromMap(netReqEntity.toJson());
      final fileOne = netReqEntity.attachmentOneFile;

      if (fileOne != null) {
        final multiPartFileOne = await MultipartFile.fromFile(
          fileOne.path,
          filename: fileOne.path.split('/').last,
        );
        formData.files.add(MapEntry('attachmentOneFile', multiPartFileOne));
      }
      final fileTwo = netReqEntity.attachmentTwoFile;

      if (fileTwo != null) {
        final multiPartFileTwo = await MultipartFile.fromFile(
          fileTwo.path,
          filename: fileTwo.path.split('/').last,
        );
        formData.files.add(MapEntry('attachmentTwoFile', multiPartFileTwo));
      }
      final responseData = await httpManager.putForm("mobile/research-all/${netReqEntity.researchId}", formData);
      final session = await SessionManager.getInstance();
      final int researcherId = responseData['data'] as int;
      await session.setResearchId(researcherId);
      return true;
    } catch (error) {
      Dialogs.alert(context, title: "Ocurrio un error", message: "No se puedo registrar la investigación");
      return false;
    }
  }

  static Future<bool> putUpdateResearchRevision(
      BuildContext context,
      ResearchEntity netReqEntity,
      ) async {
    try {
      FormData formData = new FormData.fromMap(netReqEntity.toJson());
      final responseData = await httpManager.putForm("mobile/research-status/${netReqEntity.researchId}", formData);
      final session = await SessionManager.getInstance();
      final int researcherId = responseData['data'] as int;
      await session.setResearchId(researcherId);
      return true;
    } catch (error) {
      Dialogs.alert(context, title: "Ocurrio un error", message: "No se puedo registrar la investigación");
      return false;
    }
  }
  static Future<ResearchEntity> getResearchById(int researchId) async {
    try {
      final responseData = await httpManager.get("mobile/research-only/$researchId");
      return ResearchEntity.fromJson(responseData["data"]);
    } catch (e) {
      print("Error ${e.message}");
      return null;
    }
  }
  static Future<bool> postDeleteResearch(
      BuildContext context,
      int researchId,
      ) async {
    try {
      var s = await httpManager.delete("mobile/research-delete/$researchId");
      print(s);
      return true;
    } catch (error) {
      Dialogs.alert(context, title: "Ocurrio un error", message: "No se puedo eliminar la investigación");
      return false;
    }
  }
  static Future<String> getCertificateByResearchId(int researchId) async {
    try {
      final responseData = await httpManager.get("mobile/certificate/$researchId");
      return responseData["data"];
    } catch (e) {
      print("Error ${e.message}");
      return null;
    }
  }

}