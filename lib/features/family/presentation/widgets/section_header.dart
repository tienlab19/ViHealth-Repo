import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {this.action, super.key});

  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.titleMedium),
          ),
          if (action != null) action!,
        ],
      ),
    );
  }
}

class SubtleText extends StatelessWidget {
  const SubtleText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: AppColors.muted),
    );
  }
}
