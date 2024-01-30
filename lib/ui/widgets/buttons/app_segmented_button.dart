// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class AppSegmentedButton extends StatelessWidget {
  final List<ButtonSegment<dynamic>> segments;
  final Set<dynamic> selected;
  final Function(Set<dynamic>)? onSelectionChanged;

  const AppSegmentedButton({
    Key? key,
    required this.segments,
    required this.selected,
    this.onSelectionChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      segments: segments,
      emptySelectionAllowed: true,
      selected: selected,
      onSelectionChanged: onSelectionChanged,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return AppColors.white;
            }
            return AppColors.grey;
          },
        ),
      ),
    );
  }
}
