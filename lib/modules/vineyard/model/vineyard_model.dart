// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class VineyardModel {
  String? id;
  String projectId;
  String title;
  double? area;
  DateTime created;
  DateTime? updated;
  VineyardModel({
    this.id,
    required this.projectId,
    required this.title,
    this.area,
    required this.created,
    this.updated,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'projectId': projectId,
      'title': title,
      'area': area,
      'created': created.millisecondsSinceEpoch,
      'updated': updated?.millisecondsSinceEpoch,
    };
  }

  factory VineyardModel.fromMap(Map<String, dynamic> map) {
    return VineyardModel(
      id: map['id'] != null ? map['id'] as String : null,
      projectId: map['projectId'] as String,
      title: map['title'] as String,
      area: map['area'] != null ? map['area'] as double : null,
      created: DateTime.fromMillisecondsSinceEpoch(map['created'] as int),
      updated: map['updated'] != null ? DateTime.fromMillisecondsSinceEpoch(map['updated'] as int) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory VineyardModel.fromJson(String source) => VineyardModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
