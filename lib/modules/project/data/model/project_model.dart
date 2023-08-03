import 'dart:convert';

class ProjectModel {
  String id;
  String title;
  double defaultFreeSulfur;
  double defaultLiquidSulfur;
  ProjectModel({
    required this.id,
    required this.title,
    required this.defaultFreeSulfur,
    required this.defaultLiquidSulfur,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'defaultFreeSulfur': defaultFreeSulfur,
      'defaultLiquidSulfur': defaultLiquidSulfur,
    };
  }

  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    return ProjectModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      defaultFreeSulfur: map['defaultFreeSulfur']?.toDouble() ?? 0.0,
      defaultLiquidSulfur: map['defaultLiquidSulfur']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProjectModel.fromJson(String source) => ProjectModel.fromMap(json.decode(source));
}
