// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class VineyardWineSummaryModel {
  int? count;
  int? quantitySum;
  VineyardWineSummaryModel({
    this.count,
    this.quantitySum,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'count': count,
      'quantitySum': quantitySum,
    };
  }

  factory VineyardWineSummaryModel.fromMap(Map<String, dynamic> map) {
    return VineyardWineSummaryModel(
      count: map['count'] != null ? map['count'] as int : null,
      quantitySum: map['quantitySum'] != null ? map['quantitySum'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory VineyardWineSummaryModel.fromJson(String source) => VineyardWineSummaryModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
