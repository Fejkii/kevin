// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class WineVarietyModel {
  String id;
  String title;
  String code;
  
  WineVarietyModel({
    required this.id,
    required this.title,
    required this.code,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'code': code,
    };
  }

  factory WineVarietyModel.fromMap(Map<String, dynamic> map) {
    return WineVarietyModel(
      id: map['id'] as String,
      title: map['title'] as String,
      code: map['code'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory WineVarietyModel.fromJson(String source) => WineVarietyModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
