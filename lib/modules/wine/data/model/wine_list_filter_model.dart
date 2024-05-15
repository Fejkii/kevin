// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:kevin/modules/wine/data/model/wine_classification_model.dart';
import 'package:kevin/modules/wine/data/model/wine_variety_model.dart';

enum WineListOrderType {
  alphabetAsc,
  alphabetDesc,
  literAsc,
  literDesc,
  yearAsc,
  yearDesc,
}

extension WineListOrderTypeExtension on WineListOrderType {
  int getId() {
    switch (this) {
      case WineListOrderType.alphabetAsc:
        return 0;
      case WineListOrderType.alphabetDesc:
        return 1;
      case WineListOrderType.literAsc:
        return 2;
      case WineListOrderType.literDesc:
        return 3;
      case WineListOrderType.yearAsc:
        return 4;
      case WineListOrderType.yearDesc:
        return 5;
      default:
        return 0;
    }
  }

  String getSortTranslate(BuildContext context) {
    switch (this) {
      case WineListOrderType.alphabetAsc:
        return AppLocalizations.of(context)!.asc;
      case WineListOrderType.alphabetDesc:
        return AppLocalizations.of(context)!.desc;
      case WineListOrderType.literAsc:
        return AppLocalizations.of(context)!.asc;
      case WineListOrderType.literDesc:
        return AppLocalizations.of(context)!.desc;
      case WineListOrderType.yearAsc:
        return AppLocalizations.of(context)!.asc;
      case WineListOrderType.yearDesc:
        return AppLocalizations.of(context)!.desc;
      default:
        return AppLocalizations.of(context)!.asc;
    }
  }

  String getTranslate(BuildContext context) {
    switch (this) {
      case WineListOrderType.alphabetAsc:
        return AppLocalizations.of(context)!.byAlphabet;
      case WineListOrderType.alphabetDesc:
        return AppLocalizations.of(context)!.byAlphabet;
      case WineListOrderType.literAsc:
        return AppLocalizations.of(context)!.byLiter;
      case WineListOrderType.literDesc:
        return AppLocalizations.of(context)!.byLiter;
      case WineListOrderType.yearAsc:
        return AppLocalizations.of(context)!.byYear;
      case WineListOrderType.yearDesc:
        return AppLocalizations.of(context)!.byYear;
      default:
        return AppLocalizations.of(context)!.all;
    }
  }
}

class WineListFilterModel {
  int activeFilters;
  List<WineVarietyModel> wineVarieties;
  List<WineClassificationModel> wineClassifications;
  int wineListOrderTypeId;
  WineListFilterModel({
    required this.activeFilters,
    required this.wineVarieties,
    required this.wineClassifications,
    required this.wineListOrderTypeId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'activeFilters': activeFilters,
      'wineVarieties': wineVarieties.map((x) => x.toMap()).toList(),
      'wineClassifications': wineClassifications.map((x) => x.toMap()).toList(),
      'wineListOrderTypeId': wineListOrderTypeId,
    };
  }

  factory WineListFilterModel.fromMap(Map<String, dynamic> map) {
    return WineListFilterModel(
      activeFilters: map['activeFilters'] as int,
      wineVarieties: List<WineVarietyModel>.from(
        (map['wineVarieties'] as List<dynamic>).map<WineVarietyModel>(
          (x) => WineVarietyModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      wineClassifications: List<WineClassificationModel>.from(
        (map['wineClassifications'] as List<dynamic>).map<WineClassificationModel>(
          (x) => WineClassificationModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      wineListOrderTypeId: map['wineListOrderTypeId'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory WineListFilterModel.fromJson(String source) => WineListFilterModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
