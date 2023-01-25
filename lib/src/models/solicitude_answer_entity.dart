class SolicitudeAnswerEntity {
  int? id;
  String? fullName;
  String? photo;
  String? specialty;
  String? file;
  String? comments;

  SolicitudeAnswerEntity({
    this.id,
    this.fullName,
    this.photo,
    this.specialty,
    this.file,
    this.comments,
  });

  factory SolicitudeAnswerEntity.fromJson(Map<String, dynamic> json) {
    return SolicitudeAnswerEntity(
      id: json['answerId'] ?? 0,
      fullName: json['fullName'] ?? "",
      photo: json['photo'] ?? "",
      specialty: json['specialty'] ?? "",
      file: json['file'] ?? "",
      comments: json['comments'] ?? "",
    );
  }

  static List<SolicitudeAnswerEntity> fromJSONList(List<dynamic> jsonList) {
    List<SolicitudeAnswerEntity> items = [];
    jsonList.forEach((dynamic json) {
      items.add(SolicitudeAnswerEntity.fromJson(json));
    });
    return items;
  }
}
