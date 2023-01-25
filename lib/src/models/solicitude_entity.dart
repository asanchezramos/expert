class SolicitudeEntity {
  int? id;
  String? fullName;
  String? status;

  SolicitudeEntity({
    this.id,
    this.fullName,
    this.status,
  });

  factory SolicitudeEntity.fromJson(Map<String, dynamic> json) {
    return SolicitudeEntity(
      id: json['solicitudeId'] ?? 0,
      fullName: json['fullName'] ?? "",
      status: json['status'] ?? "",
    );
  }

  static List<SolicitudeEntity> fromJSONList(List<dynamic> jsonList) {
    List<SolicitudeEntity> items = [];
    jsonList.forEach((dynamic json) {
      items.add(SolicitudeEntity.fromJson(json));
    });
    return items;
  }
}
