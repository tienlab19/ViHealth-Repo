import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.gradient,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? AppColors.surface : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: gradient == null ? AppColors.line : Colors.transparent,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}
