// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class WineClassificationModel {
  String id;
  String title;
  String code;
  String? params;
  WineClassificationModel({
    required this.id,
    required this.title,
    required this.code,
    required this.params,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'code': code,
      'params': params,
    };
  }

  factory WineClassificationModel.fromMap(Map<String, dynamic> map) {
    return WineClassificationModel(
      id: map['id'] as String,
      title: map['title'] as String,
      code: map['code'] as String,
      params: map['params'] != null ? map['params'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory WineClassificationModel.fromJson(String source) => WineClassificationModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
