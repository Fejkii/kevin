// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:kevin/modules/auth/data/model/user_model.dart';

class ClientMessageModel {
  String? id;
  UserModel author;
  String title;
  String message;
  DateTime created;

  ClientMessageModel(
    this.id,
    this.author,
    this.title,
    this.message,
    this.created,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'author': author.toMap(),
      'title': title,
      'message': message,
      'created': created.millisecondsSinceEpoch,
    };
  }

  factory ClientMessageModel.fromMap(Map<String, dynamic> map) {
    return ClientMessageModel(
      map['id'] != null ? map['id'] as String : null,
      UserModel.fromMap(map['author'] as Map<String,dynamic>),
      map['title'] as String,
      map['message'] as String,
      DateTime.fromMillisecondsSinceEpoch(map['created'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory ClientMessageModel.fromJson(String source) => ClientMessageModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
