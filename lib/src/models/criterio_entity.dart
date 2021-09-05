class CriterioEntity {
  int criterioId;
  int expertId;
  String name;
  String speciality;

  CriterioEntity(
      {this.criterioId, this.expertId,this.name, this.speciality});

  factory CriterioEntity.fromJson(Map<String, dynamic> json) {
    return CriterioEntity(
      criterioId: json['criterioId'] ?? 0,
      expertId: json['expertId'] ?? 0,
      name: json['name'] ?? "",
      speciality: json['speciality'] ?? ""
    );
  }
  static List<CriterioEntity> fromJSONList(List<dynamic> jsonList) {
    List<CriterioEntity> items = List<CriterioEntity>();
    jsonList.forEach((dynamic json) {
      items.add(CriterioEntity.fromJson(json));
    });
    return items;
  }
}
