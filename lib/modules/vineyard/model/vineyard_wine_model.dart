// ignore_for_file: public_member_api_docs, sort_constructors_first
// Hlavička vinohradu
import 'dart:convert';

import 'package:kevin/modules/wine/data/model/wine_variety_model.dart';

class VineyardWineModel {
  String? id;
  String vineyardId;
  WineVarietyModel wineModel;
  String title;
  int quantity;
  int? year;
  String? note;
  VineyardWineModel({
    this.id,
    required this.vineyardId,
    required this.wineModel,
    required this.title,
    required this.quantity,
    this.year,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'vineyardId': vineyardId,
      'wineModel': wineModel.toMap(),
      'title': title,
      'quantity': quantity,
      'year': year,
      'note': note,
    };
  }

  factory VineyardWineModel.fromMap(Map<String, dynamic> map) {
    return VineyardWineModel(
      id: map['id'] != null ? map['id'] as String : null,
      vineyardId: map['vineyardId'] as String,
      wineModel: WineVarietyModel.fromMap(map['wineModel'] as Map<String,dynamic>),
      title: map['title'] as String,
      quantity: map['quantity'] as int,
      year: map['year'] != null ? map['year'] as int : null,
      note: map['note'] != null ? map['note'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory VineyardWineModel.fromJson(String source) => VineyardWineModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
