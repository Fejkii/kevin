// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum VineyardRecordType {
  spraying,
  pleating,
  greenJobs,
  plowing,
  pickingGrapes,
  cutting,
  binding,
  fertilization,
  others,
}

extension VineyardRecordTypeExtension on VineyardRecordType {
  int getId() {
    switch (this) {
      case VineyardRecordType.spraying:
        return 1;
      case VineyardRecordType.pleating:
        return 2;
      case VineyardRecordType.greenJobs:
        return 3;
      case VineyardRecordType.plowing:
        return 4;
      case VineyardRecordType.pickingGrapes:
        return 5;
      case VineyardRecordType.cutting:
        return 6;
      case VineyardRecordType.binding:
        return 7;
      case VineyardRecordType.fertilization:
        return 8;
      case VineyardRecordType.others:
        return 9;
      default:
        return 9;
    }
  }

  String getTranslate(BuildContext context) {
    switch (this) {
      case VineyardRecordType.spraying:
        return AppLocalizations.of(context)!.spraying;
      case VineyardRecordType.pleating:
        return AppLocalizations.of(context)!.pleating;
      case VineyardRecordType.greenJobs:
        return AppLocalizations.of(context)!.greenJobs;
      case VineyardRecordType.plowing:
        return AppLocalizations.of(context)!.plowing;
      case VineyardRecordType.pickingGrapes:
        return AppLocalizations.of(context)!.pickingGrapes;
      case VineyardRecordType.cutting:
        return AppLocalizations.of(context)!.cutting;
      case VineyardRecordType.binding:
        return AppLocalizations.of(context)!.binding;
      case VineyardRecordType.fertilization:
        return AppLocalizations.of(context)!.fertilization;
      case VineyardRecordType.others:
        return AppLocalizations.of(context)!.others;
      default:
        return AppLocalizations.of(context)!.others;
    }
  }
}

class VineyardRecordModel {
  String? id;
  String? vineyardId;
  String? vineyardWineId;
  int vineyardRecordTypeId;
  DateTime date;
  bool? isInProgress;
  DateTime? dateTo;
  String? note;
  String? title;
  dynamic data;
  DateTime created;
  DateTime? updated;
  VineyardRecordModel({
    this.id,
    this.vineyardId,
    this.vineyardWineId,
    required this.vineyardRecordTypeId,
    required this.date,
    this.isInProgress,
    this.dateTo,
    this.note,
    this.title,
    required this.data,
    required this.created,
    this.updated,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'vineyardId': vineyardId,
      'vineyardWineId': vineyardWineId,
      'vineyardRecordTypeId': vineyardRecordTypeId,
      'date': date.millisecondsSinceEpoch,
      'isInProgress': isInProgress,
      'dateTo': dateTo?.millisecondsSinceEpoch,
      'note': note,
      'title': title,
      'data': data,
      'createdAt': created.millisecondsSinceEpoch,
      'updatedAt': updated?.millisecondsSinceEpoch,
    };
  }

  factory VineyardRecordModel.fromMap(Map<String, dynamic> map) {
    return VineyardRecordModel(
      id: map['id'] != null ? map['id'] as String : null,
      vineyardId: map['vineyardId'] != null ? map['vineyardId'] as String : null,
      vineyardWineId: map['vineyardWineId'] != null ? map['vineyardWineId'] as String : null,
      vineyardRecordTypeId: map['vineyardRecordTypeId'] as int,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      isInProgress: map['isInProgress'] != null ? map['isInProgress'] as bool : null,
      dateTo: map['dateTo'] != null ? DateTime.fromMillisecondsSinceEpoch(map['dateTo'] as int) : null,
      note: map['note'] != null ? map['note'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      data: map['data'] as dynamic,
      created: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updated: map['updatedAt'] != null ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory VineyardRecordModel.fromJson(String source) => VineyardRecordModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class VineyardRecordSpraying {
  String sprayName;
  double amountSpray;
  double amountWater;
  VineyardRecordSpraying({
    required this.sprayName,
    required this.amountSpray,
    required this.amountWater,
  });

  Map<String, dynamic> toMap() {
    return {
      'sprayName': sprayName,
      'amountSpray': amountSpray,
      'amountWater': amountWater,
    };
  }

  factory VineyardRecordSpraying.fromMap(Map<String, dynamic> map) {
    return VineyardRecordSpraying(
      sprayName: map['sprayName'] ?? '',
      amountSpray: map['amountSpray']?.toDouble() ?? 0.0,
      amountWater: map['amountWater']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory VineyardRecordSpraying.fromJson(String source) => VineyardRecordSpraying.fromMap(json.decode(source));
}
