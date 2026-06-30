import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class AvatarBadge extends StatelessWidget {
  const AvatarBadge({
    required this.label,
    this.color = AppColors.primary,
    this.size = 44,
    super.key,
  });

  final String label;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(size * 0.36),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: size * 0.38,
        ),
      ),
    );
  }
}
