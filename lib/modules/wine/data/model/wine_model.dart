// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:kevin/modules/wine/data/model/wine_classification_model.dart';
import 'package:kevin/modules/wine/data/model/wine_variety_model.dart';

class WineModel {
  String id;
  String projectId;
  List<WineVarietyModel> wineVarieties;
  WineClassificationModel? wineClassification;
  String title;
  double quantity;
  int year;
  double? alcohol;
  double? acid;
  double? sugar;
  String? note;
  DateTime created;
  DateTime? updated;

  WineModel({
    required this.id,
    required this.projectId,
    required this.wineVarieties,
    this.wineClassification,
    required this.title,
    required this.quantity,
    required this.year,
    this.alcohol,
    this.acid,
    this.sugar,
    this.note,
    required this.created,
    this.updated,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'projectId': projectId,
      'wineVarieties': wineVarieties.map((x) => x.toMap()).toList(),
      'wineClassification': wineClassification?.toMap(),
      'title': title,
      'quantity': quantity,
      'year': year,
      'alcohol': alcohol,
      'acid': acid,
      'sugar': sugar,
      'note': note,
      'created': created.millisecondsSinceEpoch,
      'updated': updated?.millisecondsSinceEpoch,
    };
  }

  factory WineModel.fromMap(Map<String, dynamic> map) {
    return WineModel(
      id: map['id'] as String,
      projectId: map['projectId'] as String,
      wineVarieties: List<WineVarietyModel>.from(
        (map['wineVarieties'] as List<dynamic>).map<WineVarietyModel>(
          (x) => WineVarietyModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      wineClassification:
          map['wineClassification'] != null ? WineClassificationModel.fromMap(map['wineClassification'] as Map<String, dynamic>) : null,
      title: map['title'] as String,
      quantity: map['quantity'] as double,
      year: map['year'] as int,
      alcohol: map['alcohol'] != null ? map['alcohol'] as double : null,
      acid: map['acid'] != null ? map['acid'] as double : null,
      sugar: map['sugar'] != null ? map['sugar'] as double : null,
      note: map['note'] != null ? map['note'] as String : null,
      created: DateTime.fromMillisecondsSinceEpoch(map['created'] as int),
      updated: map['updated'] != null ? DateTime.fromMillisecondsSinceEpoch(map['updated'] as int) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory WineModel.fromJson(String source) => WineModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
