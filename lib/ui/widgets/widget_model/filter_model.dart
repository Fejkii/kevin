import 'package:flutter/material.dart';

class FilterModel {
  bool isFilterActive;
  String title;
  Widget filterBody;
  int activeFilters;

  FilterModel({
    required this.isFilterActive,
    required this.title,
    required this.filterBody,
    required this.activeFilters,
  });
}
