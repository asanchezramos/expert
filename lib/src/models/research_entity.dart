import 'dart:io';

class ResearchEntity {
  int researchId;
  int researcherId;
  int expertId;
  String title;
  String speciality;
  String authors;
  String observation;
  String attachmentOne;
  String attachmentTwo;
  int status;
  File attachmentOneFile;
  File attachmentTwoFile;
  String updatedAt;

  ResearchEntity(
      { this.researchId,
        this.researcherId,
        this.expertId,
        this.title,
        this.speciality,
        this.authors,
        this.observation,
        this.attachmentOne,
        this.attachmentTwo,
        this.status ,
        this.attachmentOneFile,
        this.attachmentTwoFile,
        this.updatedAt
      });

  factory ResearchEntity.fromJson(Map<String, dynamic> json) {
    return ResearchEntity(
      researchId: json['researchId'] ?? 0,
      researcherId: json['researcherId'] ?? 0,
      expertId: json['expertId'] ?? 0,
      title: json['title'] ?? '',
      speciality: json['speciality'] ?? '',
      authors: json['authors'] ?? '',
      observation: json['observation'] ?? '',
      attachmentOne: json['attachmentOne'] ?? '',
      attachmentTwo: json['attachmentTwo'] ?? '',
      status: json['status'] ?? 0,
      attachmentOneFile: null,
      attachmentTwoFile: null,
        updatedAt:json['updatedAt'] ?? ''
    );
  }

  Map<String, dynamic> toJson() =>
      {'researchId': researchId,
        "researcherId": researcherId,
        "expertId": expertId,
        "title": title,
        "speciality": speciality,
        "authors": authors,
        "observation": observation,
        "status": status,
        "attachmentOne": attachmentOne,
        "attachmentTwo": attachmentTwo
      };
  static List<ResearchEntity> fromJSONList(List<dynamic> jsonList) {
    List<ResearchEntity> items = List<ResearchEntity>();
    jsonList.forEach((dynamic json) {
      items.add(ResearchEntity.fromJson(json));
    });
    return items;
  }
}
