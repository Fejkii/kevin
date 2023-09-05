import 'dart:convert';

import 'package:kevin/modules/wine/data/model/wine_classification_model.dart';
import 'package:kevin/modules/wine/data/model/wine_variety_model.dart';

class WineModel {
  String id;
  String projectId;
  List<WineVarietyModel> wineVarieties;
  WineClassificationModel? wineClassification;
  String? title;
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
    return {
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
      id: map['id'] ?? '',
      projectId: map['projectId'] ?? '',
      wineVarieties: List<WineVarietyModel>.from(map['wineVarieties']?.map((x) => WineVarietyModel.fromMap(x))),
      wineClassification: map['wineClassification'] != null ? WineClassificationModel.fromMap(map['wineClassification']) : null,
      title: map['title'],
      quantity: map['quantity']?.toDouble() ?? 0.0,
      year: map['year']?.toInt() ?? 0,
      alcohol: map['alcohol']?.toDouble(),
      acid: map['acid']?.toDouble(),
      sugar: map['sugar']?.toDouble(),
      note: map['note'],
      created: DateTime.fromMillisecondsSinceEpoch(map['created']),
      updated: map['updated'] != null ? DateTime.fromMillisecondsSinceEpoch(map['updated']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory WineModel.fromJson(String source) => WineModel.fromMap(json.decode(source));
}
