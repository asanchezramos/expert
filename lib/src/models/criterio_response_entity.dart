class CriterioResponseEntity {
  int criterioResponseId;
  int expertId;
  int criterioId;
  int researchId;
  int dimensionId;
  String status;
  String updateAt;

  CriterioResponseEntity(
      {this.criterioResponseId, this.criterioId,this.researchId, this.dimensionId, this.status, this.updateAt,this.expertId});

  factory CriterioResponseEntity.fromJson(Map<String, dynamic> json) {
    return CriterioResponseEntity(
        criterioResponseId: json['criterioResponseId'] ?? 0,
        criterioId: json['criterioId'] ?? 0,
        researchId: json['researchId'] ?? 0,
        dimensionId: json['dimensionId'] ?? 0,
        expertId: json['expertId'] ?? 0,
        status: json['status'] ?? "",
        updateAt: json['updateAt'] ?? ""
    );
  }
  Map<String, dynamic> toJson() =>
      {'criterioResponseId': criterioResponseId,
        "criterioId": criterioId,
        "expertId": expertId,
        "researchId": researchId,
        "dimensionId": dimensionId,
        "status": status,
      };
  static List<CriterioResponseEntity> fromJSONList(List<dynamic> jsonList) {
    List<CriterioResponseEntity> items = List<CriterioResponseEntity>();
    jsonList.forEach((dynamic json) {
      items.add(CriterioResponseEntity.fromJson(json));
    });
    return items;
  }
}
