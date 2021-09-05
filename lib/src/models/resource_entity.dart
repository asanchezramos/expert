import 'dart:io';

class ResourceEntity {
  int resourceUserId;
  int expertId;
  String title;
  String subtitle;
  String link;
  String updatedAt;

  ResourceEntity(
      { this.resourceUserId,
        this.expertId,
        this.title,
        this.subtitle,
        this.link,
        this.updatedAt
      });

  factory ResourceEntity.fromJson(Map<String, dynamic> json) {
    return ResourceEntity(
        resourceUserId: json['resourceUserId'] ?? 0,
        expertId: json['expertId'] ?? 0,
        title: json['title'] ?? '',
        subtitle: json['subtitle'] ?? '',
        link: json['link'] ?? '',
        updatedAt: json['updatedAt'] ?? ''
    );
  }

  Map<String, dynamic> toJson() =>
      {'resourceUserId': resourceUserId,
        "expertId": expertId,
        "title": title,
        "subtitle": subtitle,
        "link": link,
        "updatedAt": updatedAt
      };
  static List<ResourceEntity> fromJSONList(List<dynamic> jsonList) {
    List<ResourceEntity> items = List<ResourceEntity>();
    jsonList.forEach((dynamic json) {
      items.add(ResourceEntity.fromJson(json));
    });
    return items;
  }
}
