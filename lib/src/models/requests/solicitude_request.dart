import 'dart:io';

class SolicitudeRequest {
  File? repository;
  File? investigation;
  int? userId;
  int? expertId;
  String? status;
  SolicitudeRequest({
    this.repository,
    this.investigation,
    this.expertId,
    this.status,
    this.userId,
  });
  Map<String, dynamic> toJson() => {
        'investigation': investigation,
        "repository": repository,
        "userId": userId,
        "expertId": expertId,
        "status": status,
      };
}
