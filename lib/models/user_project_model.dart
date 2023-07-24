// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:kevin/models/project_model.dart';
import 'package:kevin/models/user_model.dart';

class UserProjectModel {
  String id;
  UserModel user;
  ProjectModel project;
  bool isDefault;
  bool isOwner;
  DateTime createdAt;
  DateTime updatedAt;
  UserProjectModel({
    required this.id,
    required this.user,
    required this.project,
    required this.isDefault,
    required this.isOwner,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user': user.toMap(),
      'project': project.toMap(),
      'isDefault': isDefault,
      'isOwner': isOwner,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory UserProjectModel.fromMap(Map<String, dynamic> map) {
    return UserProjectModel(
      id: map['id'] as String,
      user: UserModel.fromMap(map['user'] as Map<String,dynamic>),
      project: ProjectModel.fromMap(map['project'] as Map<String,dynamic>),
      isDefault: map['isDefault'] as bool,
      isOwner: map['isOwner'] as bool,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProjectModel.fromJson(String source) => UserProjectModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
