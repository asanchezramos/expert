class ExpertEntity {
  int id;
  String name;
  String fullName;
  String specialty;
  int status;
  String photo;
  String phone;

  ExpertEntity(
      {this.id, this.name,this.fullName, this.specialty, this.status, this.photo, this.phone});

  factory ExpertEntity.fromJson(Map<String, dynamic> json) {
    return ExpertEntity(
      id: json['userId'] ?? 0,
      name: json['name'] ?? "",
      fullName: json['fullName'] ?? "",
      specialty: json['specialty'] ?? "",
      status: json['status'] ?? 0,
      photo: json['photo'] ?? "",
      phone: json['phone'] ?? "",
    );
  }

  static List<ExpertEntity> fromJSONList(List<dynamic> jsonList) {
    List<ExpertEntity> items = List<ExpertEntity>();
    jsonList.forEach((dynamic json) {
      items.add(ExpertEntity.fromJson(json));
    });
    return items;
  }
}
