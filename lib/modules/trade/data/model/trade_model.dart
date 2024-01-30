// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:kevin/modules/trade/data/model/trade_item_model.dart';

enum TradeType {
  all,
  purchase,
  sale,
}

extension TradeTypeExtension on TradeType {
  int getId() {
    switch (this) {
      case TradeType.all:
        return 0;
      case TradeType.purchase:
        return 1;
      case TradeType.sale:
        return 2;
      default:
        return 0;
    }
  }

  String getTranslate(BuildContext context) {
    switch (this) {
      case TradeType.all:
        return AppLocalizations.of(context)!.all;
      case TradeType.purchase:
        return AppLocalizations.of(context)!.purchase;
      case TradeType.sale:
        return AppLocalizations.of(context)!.sale;
      default:
        return AppLocalizations.of(context)!.all;
    }
  }
}

class TradeModel {
  String? id;
  String title;
  DateTime date;
  int tradeTypeId;
  List<TradeItemModel> tradeItems;
  String? note;
  DateTime created;
  DateTime? updated;
  TradeModel({
    this.id,
    required this.title,
    required this.date,
    required this.tradeTypeId,
    required this.tradeItems,
    this.note,
    required this.created,
    this.updated,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'date': date.millisecondsSinceEpoch,
      'tradeTypeId': tradeTypeId,
      'tradeItems': tradeItems.map((x) => x.toMap()).toList(),
      'note': note,
      'created': created.millisecondsSinceEpoch,
      'updated': updated?.millisecondsSinceEpoch,
    };
  }

  factory TradeModel.fromMap(Map<String, dynamic> map) {
    return TradeModel(
      id: map['id'] != null ? map['id'] as String : null,
      title: map['title'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      tradeTypeId: map['tradeTypeId'] as int,
      tradeItems: List<TradeItemModel>.from(
        (map['tradeItems'] as List<dynamic>).map<TradeItemModel>(
          (x) => TradeItemModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      note: map['note'] != null ? map['note'] as String : null,
      created: DateTime.fromMillisecondsSinceEpoch(map['created'] as int),
      updated: map['updated'] != null ? DateTime.fromMillisecondsSinceEpoch(map['updated'] as int) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TradeModel.fromJson(String source) => TradeModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
