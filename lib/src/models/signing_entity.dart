import 'dart:io';

class SigningEntity {
  int signingId;
  int expertId;
  String link;
  File fileSigning;
  String updatedAt;

  SigningEntity(
      { this.signingId,
        this.expertId,
        this.link,
        this.fileSigning,
        this.updatedAt
      });

  factory SigningEntity.fromJson(Map<String, dynamic> json) {
    return SigningEntity(
        signingId: json['signingId'] ?? 0,
        expertId: json['expertId'] ?? 0,
        link: json['link'] ?? '',
        fileSigning: null,
        updatedAt:json['updatedAt'] ?? ''
    );
  }

  Map<String, dynamic> toJson() =>
      {'signingId': signingId,
        "expertId": expertId,
        "link": link
      };
  static List<SigningEntity> fromJSONList(List<dynamic> jsonList) {
    List<SigningEntity> items = List<SigningEntity>();
    jsonList.forEach((dynamic json) {
      items.add(SigningEntity.fromJson(json));
    });
    return items;
  }
}
