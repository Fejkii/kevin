// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WineRecordModel {
  String? id;
  int wineRecordTypeId;
  DateTime date;
  bool? isInProgress;
  DateTime? dateTo;
  String? note;
  String? title;
  dynamic data;
  DateTime created;
  DateTime? updated;
  WineRecordModel({
    this.id,
    required this.wineRecordTypeId,
    required this.date,
    this.isInProgress,
    this.dateTo,
    this.note,
    this.title,
    this.data,
    required this.created,
    this.updated,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'wineRecordTypeId': wineRecordTypeId,
      'date': date.millisecondsSinceEpoch,
      'isInProgress': isInProgress,
      'dateTo': dateTo?.millisecondsSinceEpoch,
      'note': note,
      'title': title,
      'data': data,
      'created': created.millisecondsSinceEpoch,
      'updated': updated?.millisecondsSinceEpoch,
    };
  }

  factory WineRecordModel.fromMap(Map<String, dynamic> map) {
    return WineRecordModel(
      id: map['id'] != null ? map['id'] as String : null,
      wineRecordTypeId: map['wineRecordTypeId'] as int,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      isInProgress: map['isInProgress'] != null ? map['isInProgress'] as bool : null,
      dateTo: map['dateTo'] != null ? DateTime.fromMillisecondsSinceEpoch(map['dateTo'] as int) : null,
      note: map['note'] != null ? map['note'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      data: map['data'] as dynamic,
      created: DateTime.fromMillisecondsSinceEpoch(map['created'] as int),
      updated: map['updated'] != null ? DateTime.fromMillisecondsSinceEpoch(map['updated'] as int) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory WineRecordModel.fromJson(String source) => WineRecordModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

enum WineRecordType {
  measurementFreeSulfure,
  sulfurization,
  measurementProteins,
  proteinWithdrawal,
  filtering,
  withdrawal,
  fermentation,
  pressing,
  others,
}

extension WineRecordTypeExtension on WineRecordType {
  int getId() {
    switch (this) {
      case WineRecordType.measurementFreeSulfure:
        return 1;
      case WineRecordType.sulfurization:
        return 2;
      case WineRecordType.measurementProteins:
        return 3;
      case WineRecordType.proteinWithdrawal:
        return 4;
      case WineRecordType.filtering:
        return 5;
      case WineRecordType.withdrawal:
        return 6;
      case WineRecordType.fermentation:
        return 7;
      case WineRecordType.pressing:
        return 8;
      case WineRecordType.others:
        return 9;
      default:
        return 9;
    }
  }

  String getTranslate(BuildContext context) {
    switch (this) {
      case WineRecordType.measurementFreeSulfure:
        return AppLocalizations.of(context)!.measurementFreeSulfure;
      case WineRecordType.sulfurization:
        return AppLocalizations.of(context)!.sulfurization;
      case WineRecordType.measurementProteins:
        return AppLocalizations.of(context)!.measurementProteins;
      case WineRecordType.proteinWithdrawal:
        return AppLocalizations.of(context)!.proteinWithdrawal;
      case WineRecordType.filtering:
        return AppLocalizations.of(context)!.filtering;
      case WineRecordType.withdrawal:
        return AppLocalizations.of(context)!.withdrawal;
      case WineRecordType.fermentation:
        return AppLocalizations.of(context)!.fermentation;
      case WineRecordType.pressing:
        return AppLocalizations.of(context)!.pressing;
      case WineRecordType.others:
        return AppLocalizations.of(context)!.others;
      default:
        return AppLocalizations.of(context)!.others;
    }
  }
}

class WineRecordFreeSulfure {
  double freeSulfure;
  double quantity;
  double requiredSulphurisation;
  double liquidSulfur;
  double sulfurizationBy;
  double liquidSulfurDosage;

  WineRecordFreeSulfure({
    required this.freeSulfure,
    required this.quantity,
    required this.requiredSulphurisation,
    required this.liquidSulfur,
    required this.sulfurizationBy,
    required this.liquidSulfurDosage,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'freeSulfure': freeSulfure,
      'quantity': quantity,
      'requiredSulphurisation': requiredSulphurisation,
      'liquidSulfur': liquidSulfur,
      'sulfurizationBy': sulfurizationBy,
      'liquidSulfurDosage': liquidSulfurDosage,
    };
  }

  factory WineRecordFreeSulfure.fromMap(Map<String, dynamic> map) {
    return WineRecordFreeSulfure(
      freeSulfure: map['freeSulfure'] as double,
      quantity: map['quantity'] as double,
      requiredSulphurisation: map['requiredSulphurisation'] as double,
      liquidSulfur: map['liquidSulfur'] as double,
      sulfurizationBy: map['sulfurizationBy'] as double,
      liquidSulfurDosage: map['liquidSulfurDosage'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory WineRecordFreeSulfure.fromJson(String source) => WineRecordFreeSulfure.fromMap(json.decode(source) as Map<String, dynamic>);
}
