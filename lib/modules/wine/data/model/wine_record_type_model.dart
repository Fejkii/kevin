import 'dart:convert';

class WineRecordTypeModel {
  int id;
  String title;
  String code;
  String color;
  WineRecordTypeModel({
    required this.id,
    required this.title,
    required this.code,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'code': code,
      'color': color,
    };
  }

  factory WineRecordTypeModel.fromMap(Map<String, dynamic> map) {
    return WineRecordTypeModel(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      code: map['code'] ?? '',
      color: map['color'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory WineRecordTypeModel.fromJson(String source) => WineRecordTypeModel.fromMap(json.decode(source));
}
