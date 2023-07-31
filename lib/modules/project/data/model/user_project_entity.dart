// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserProjectEntity {
  String id;
  String userId;
  String projectId;
  bool isDefault;
  bool isOwner;
  DateTime created;
  DateTime updated;
  UserProjectEntity({
    required this.id,
    required this.userId,
    required this.projectId,
    required this.isDefault,
    required this.isOwner,
    required this.created,
    required this.updated,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'projectId': projectId,
      'isDefault': isDefault,
      'isOwner': isOwner,
      'created': created.millisecondsSinceEpoch,
      'updated': updated.millisecondsSinceEpoch,
    };
  }

  factory UserProjectEntity.fromMap(Map<String, dynamic> map) {
    return UserProjectEntity(
      id: map['id'] as String,
      userId: map['userId'] as String,
      projectId: map['projectId'] as String,
      isDefault: map['isDefault'] as bool,
      isOwner: map['isOwner'] as bool,
      created: DateTime.fromMillisecondsSinceEpoch(map['created'] as int),
      updated: DateTime.fromMillisecondsSinceEpoch(map['updated'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProjectEntity.fromJson(String source) => UserProjectEntity.fromMap(json.decode(source) as Map<String, dynamic>);
}
