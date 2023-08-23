// Hlavička vinohradu
import 'dart:convert';

import 'package:kevin/modules/wine/data/model/wine_variety_model.dart';

class VineyardWineModel {
  String? id;
  String vineyardId;
  WineVarietyModel wineModel;
  String? title;
  int quantity;
  int? year;
  String? note;
  VineyardWineModel({
    this.id,
    required this.vineyardId,
    required this.wineModel,
    this.title,
    required this.quantity,
    this.year,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
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
      id: map['id'],
      vineyardId: map['vineyardId'] ?? '',
      wineModel: WineVarietyModel.fromMap(map['wineModel']),
      title: map['title'],
      quantity: map['quantity']?.toInt() ?? 0,
      year: map['year']?.toInt(),
      note: map['note'],
    );
  }

  String toJson() => json.encode(toMap());

  factory VineyardWineModel.fromJson(String source) => VineyardWineModel.fromMap(json.decode(source));
}
