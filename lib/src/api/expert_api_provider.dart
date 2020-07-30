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
}
