class NetworkRequestEntity {
  int? networkRequestId;
  int? userBaseId;
  int? userRelationId;
  int? status;

  NetworkRequestEntity(
      { this.networkRequestId, this.userBaseId,this.userRelationId,  this.status  });

  factory NetworkRequestEntity.fromJson(Map<String, dynamic> json) {
    return NetworkRequestEntity(
      networkRequestId: json['networkRequestId'] ?? 0,
      userBaseId: json['userBaseId'] ?? 0,
      userRelationId: json['userRelationId'] ?? 0,
      status: json['status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() =>
      {'networkRequestId': networkRequestId,'userBaseId': userBaseId, "userRelationId": userRelationId, "status": status};
  static List<NetworkRequestEntity> fromJSONList(List<dynamic> jsonList) {
    List<NetworkRequestEntity> items = [];
    jsonList.forEach((dynamic json) {
      items.add(NetworkRequestEntity.fromJson(json));
    });
    return items;
  }
}
