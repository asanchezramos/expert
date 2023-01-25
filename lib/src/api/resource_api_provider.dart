import 'package:dio/dio.dart';
import 'package:expert/src/managers/session_manager.dart';
import 'package:expert/src/models/resource_entity.dart';
import 'package:flutter/cupertino.dart';

import '../managers/http_manager.dart';
import '../models/expert_entity.dart';

class ResourceApiProvider {
  static final HttpManager httpManager = HttpManager();

  static Future<List<ResourceEntity>?> getResources(int? userId) async {
    SessionManager? session = await SessionManager.getInstance();
    if (session != null) {
      try {
        if (userId == null) {
          userId = session.getUserId();
        }
        print(userId);
        final responseData =
            await httpManager.get("mobile/resource-user-post/$userId");

        return ResourceEntity.fromJSONList(responseData["data"]);
      } catch (e) { 
        return null;
      }
    }
  }

  static Future<bool?> createResource(
      BuildContext context, ResourceEntity netReqEntity) async {
    try {
      FormData formData = new FormData.fromMap(netReqEntity.toJson());
      final responseData =
          await httpManager.postForm("mobile/resource-user-post", formData);
      return true;
    } catch (e) { 
      return null;
    }
  }

  static Future<bool?> deleteResource(int? resourceUserId) async {
    try {
      final responseData =
          await httpManager.delete("mobile/resource-user/$resourceUserId");
      return true;
    } catch (e) { 
      return null;
    }
  }
}
