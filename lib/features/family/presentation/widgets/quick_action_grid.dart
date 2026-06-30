import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class QuickActionGrid extends StatelessWidget {
  const QuickActionGrid({
    this.onMetric,
    this.onMedicine,
    this.onDocument,
    this.onReminder,
    super.key,
  });

  final VoidCallback? onMetric;
  final VoidCallback? onMedicine;
  final VoidCallback? onDocument;
  final VoidCallback? onReminder;

  @override
  Widget build(BuildContext context) {
    final actions = [
      (Icons.add_chart_rounded, 'Chỉ số', onMetric),
      (Icons.medication_rounded, 'Thuốc', onMedicine),
      (Icons.description_rounded, 'Tài liệu', onDocument),
      (Icons.event_available_rounded, 'Lịch', onReminder),
    ];

    return GridView.builder(
      itemCount: actions.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 9,
        mainAxisSpacing: 9,
        childAspectRatio: 0.82,
      ),
      itemBuilder: (context, index) {
        final action = actions[index];
        return InkWell(
          borderRadius: BorderRadius.circular(17),
          onTap: action.$3,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.line),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 9),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(action.$1, color: AppColors.primary, size: 23),
                  const SizedBox(height: 7),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      action.$2,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
