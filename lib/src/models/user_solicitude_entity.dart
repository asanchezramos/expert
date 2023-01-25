class UserSolicitudeEntity {
  int? id;
  String? fullName;
  String? specialty;
  int? status;
  String? photo;
  String? phone;
  String? repository;
  String? investigation;
  int? solicitudeId;

  UserSolicitudeEntity({
    this.id,
    this.fullName,
    this.photo,
    this.specialty,
    this.status,
    this.solicitudeId,
    this.repository,
    this.investigation,
    this.phone,
  });

  factory UserSolicitudeEntity.fromJson(Map<String, dynamic> json) {
    return UserSolicitudeEntity(
      id: json['userId'] ?? 0,
      fullName: json['fullName'] ?? "",
      specialty: json['specialty'] ?? "",
      status: json['status'] ?? 0,
      photo: json['photo'] ?? "",
      repository: json['repository'] ?? "",
      investigation: json['investigation'] ?? "",
      solicitudeId: json['solicitudeId'] ?? 0,
      phone: json['phone'] ?? "",
    );
  }

  factory UserSolicitudeEntity.fromJson2(Map<String, dynamic> json) {
    return UserSolicitudeEntity(
      fullName: json['fullName'] ?? "",
      photo: json['photo'] ?? "",
      repository: json['repository'] ?? "",
      investigation: json['investigation'] ?? "",
      solicitudeId: json['solicitudeId'] ?? 0,
    );
  }

  static List<UserSolicitudeEntity> fromJSONList(List<dynamic> jsonList) {
    List<UserSolicitudeEntity> items = [];
    jsonList.forEach((dynamic json) {
      items.add(UserSolicitudeEntity.fromJson(json));
    });
    return items;
  }
}
