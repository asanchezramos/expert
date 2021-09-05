import 'package:expert/src/models/criterio_entity.dart';

import '../managers/http_manager.dart';

class CriterioApiProvider {
  static final HttpManager httpManager = HttpManager();

  static Future<List<CriterioEntity>> getCriterios(String speciality,int expertId) async {
    try {
      final responseData = await httpManager.get("mobile/criterio/$speciality/$expertId");
      return CriterioEntity.fromJSONList(responseData["data"]);
    } catch (e) {
      print("Error ${e.message}");
      return null;
    }
  }
}
