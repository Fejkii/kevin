// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String id;
  final String email;
  final String? userName;
  final DateTime created;
  final DateTime updated;

  UserModel(
    this.id,
    this.email,
    this.userName,
    this.created,
    this.updated,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'userName': userName,
      'created': created.millisecondsSinceEpoch,
      'updated': updated.millisecondsSinceEpoch,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      map['id'] as String,
      map['email'] as String,
      map['userName'] != null ? map['userName'] as String : null,
      DateTime.fromMillisecondsSinceEpoch(map['created']),
      DateTime.fromMillisecondsSinceEpoch(map['updated']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
