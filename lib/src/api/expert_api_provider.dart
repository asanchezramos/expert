import '../managers/http_manager.dart';
import '../models/expert_entity.dart';

class ExpertApiProvider {
  static final HttpManager httpManager = HttpManager();

  static Future<List<ExpertEntity>> getExperts() async {
    try {
      final responseData = await httpManager.get("mobile/expert");
      return ExpertEntity.fromJSONList(responseData["data"]);
    } catch (e) {
      print("Error ${e.message}");
      return null;
    }
  }
  static Future<List<ExpertEntity>> getFindExpert(String param) async {
    try {
      final responseData = await httpManager.get("mobile/expertfind/$param");
      return ExpertEntity.fromJSONList(responseData["data"]);
    } catch (e) {
      print("Error ${e.message}");
      return null;
    }
  }
  static Future<ExpertEntity> getExpertById(int expertId) async {
    try {
      final responseData = await httpManager.get("mobile/expert/$expertId");
      return ExpertEntity.fromJson(responseData["data"]);
    } catch (e) {
      print("Error ${e.message}");
      return null;
    }
  }
}
