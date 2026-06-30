import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum PillTone { green, blue, orange, red, purple }

class StatusPill extends StatelessWidget {
  const StatusPill(this.label, {this.tone = PillTone.green, super.key});

  final String label;
  final PillTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = switch (tone) {
      PillTone.green => (AppColors.primarySoft, AppColors.primaryDark),
      PillTone.blue => (const Color(0xFFE8F2FF), const Color(0xFF1C67B9)),
      PillTone.orange => (const Color(0xFFFFF3E8), const Color(0xFFB96919)),
      PillTone.red => (const Color(0xFFFFECEC), const Color(0xFFB42318)),
      PillTone.purple => (const Color(0xFFF5EAFF), AppColors.purple),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.$1,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: colors.$2,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
