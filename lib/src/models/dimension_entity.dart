class DimensionEntity {
  int dimensionId;
  int researchId;
  String name;
  String variable;
  String status;

  DimensionEntity(
      {this.dimensionId, this.researchId,this.name, this.variable, this.status  });

  factory DimensionEntity.fromJson(Map<String, dynamic> json) {
    return DimensionEntity(
      dimensionId: json['dimensionId'] ?? 0,
      researchId: json['researchId'] ?? 0,
      name: json['name'] ?? "",
      variable: json['variable'] ?? "",
      status: json['status'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    'dimensionId': dimensionId,
    'researchId': researchId,
    'name': name,
    'variable': variable,
    "status": status,
  };
  static List<DimensionEntity> fromJSONList(List<dynamic> jsonList) {
    List<DimensionEntity> items = List<DimensionEntity>();
    jsonList.forEach((dynamic json) {
      items.add(DimensionEntity.fromJson(json));
    });
    return items;
  }
}
