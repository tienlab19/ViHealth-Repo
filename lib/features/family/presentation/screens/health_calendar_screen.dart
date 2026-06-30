import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/status_pill.dart';
import '../../domain/entities/family_dashboard.dart';
import '../../domain/entities/reminder.dart';
import '../controllers/family_dashboard_controller.dart';
import '../widgets/family_actions.dart';
import '../widgets/vihealth_ui.dart';

class HealthCalendarScreen extends StatelessWidget {
  const HealthCalendarScreen({
    required this.dashboard,
    required this.controller,
    super.key,
  });

  final FamilyDashboard dashboard;
  final FamilyDashboardController controller;

  @override
  Widget build(BuildContext context) {
    const days = [
      '22',
      '23',
      '24',
      '25',
      '26',
      '27',
      '28',
      '29',
      '30',
      '1',
      '2',
      '3',
      '4',
      '5',
    ];
    const markedDays = {'25', '26', '30', '3'};

    return ViHealthPage(
      title: 'Lịch sức khỏe',
      subtitle: 'Theo dõi thuốc, tái khám, tiêm phòng và đo chỉ số.',
      trailing: IconButton.filledTonal(
        onPressed: () => showReminderForm(context, controller, dashboard),
        icon: const Icon(Icons.add_alert_rounded),
      ),
      children: [
        AppCard(
          child: Row(
            children: [
              const IconBubble(
                icon: Icons.calendar_month_rounded,
                color: AppColors.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tháng 6, 2026',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${dashboard.reminders.length} lịch nhắc đang bật',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SectionTitle('Lịch tháng'),
        AppCard(
          padding: const EdgeInsets.all(12),
          child: GridView.builder(
            itemCount: days.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final day = days[index];
              final selected = day == '30';
              final marked = markedDays.contains(day);
              return Container(
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : AppColors.surfaceSoft,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected || marked
                        ? AppColors.primary
                        : AppColors.line,
                  ),
                ),
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      color: selected ? Colors.white : AppColors.text,
                      fontWeight: marked || selected
                          ? FontWeight.w900
                          : FontWeight.w700,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SectionTitle('Hôm nay'),
        if (dashboard.reminders.isEmpty)
          const EmptyState(text: 'Chưa có lịch nhắc nào.')
        else
          for (final reminder in dashboard.reminders)
            _ReminderTimeline(
              reminder: reminder,
              memberName: dashboard.memberById(reminder.memberId).nickname,
              onDelete: () => controller.deleteReminder(reminder.id),
            ),
      ],
    );
  }
}

class _ReminderTimeline extends StatelessWidget {
  const _ReminderTimeline({
    required this.reminder,
    required this.memberName,
    required this.onDelete,
  });

  final Reminder reminder;
  final String memberName;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        child: Row(
          children: [
            Text(
              reminder.timeText,
              style: const TextStyle(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: 12),
            IconBubble(
              icon: reminderIcon(reminder.type),
              color: AppColors.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reminder.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '$memberName - ${reminder.description}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            StatusPill('Bật', tone: reminderTone(reminder.type)),
            IconButton(
              tooltip: 'Xóa lịch nhắc',
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
