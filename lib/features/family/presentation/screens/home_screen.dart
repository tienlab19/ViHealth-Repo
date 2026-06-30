import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/status_pill.dart';
import '../../domain/entities/family_dashboard.dart';
import '../../domain/entities/reminder.dart';
import '../controllers/family_dashboard_controller.dart';
import '../widgets/family_actions.dart';
import '../widgets/metric_trend_chart.dart';
import '../widgets/vihealth_ui.dart';
import 'member_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.dashboard,
    required this.controller,
    super.key,
  });

  final FamilyDashboard dashboard;
  final FamilyDashboardController controller;

  @override
  Widget build(BuildContext context) {
    return ViHealthPage(
      title: 'Chào bạn',
      subtitle:
          'Hôm nay có ${dashboard.reminders.length + dashboard.appointments.length} việc sức khỏe cần theo dõi.',
      trailing: const MemberAvatar(label: 'VH'),
      children: [
        AppCard(
          padding: const EdgeInsets.all(18),
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Gia đình của bạn',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${dashboard.members.length} hồ sơ - ${dashboard.metrics.length} chỉ số - ${dashboard.documents.length} tài liệu',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.84),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.health_and_safety_rounded,
                color: Colors.white,
                size: 42,
              ),
            ],
          ),
        ),
        const SectionTitle('Tổng quan'),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.1,
          children: [
            StatCard(
              label: 'Hồ sơ',
              value: '${dashboard.members.length}',
              icon: Icons.group_rounded,
              color: AppColors.primary,
            ),
            StatCard(
              label: 'Lịch nhắc',
              value: '${dashboard.reminders.length}',
              icon: Icons.notifications_active_rounded,
              color: AppColors.warning,
            ),
            StatCard(
              label: 'Tài liệu',
              value: '${dashboard.documents.length}',
              icon: Icons.description_rounded,
              color: AppColors.secondary,
            ),
            StatCard(
              label: 'Thuốc',
              value: '${dashboard.medicines.length}',
              icon: Icons.medication_rounded,
              color: AppColors.purple,
            ),
          ],
        ),
        const SectionTitle('Thành viên gia đình'),
        SizedBox(
          height: 118,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: dashboard.members.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final member = dashboard.members[index];
              return MemberMiniCard(
                member: member,
                onTap: () {
                  controller.selectMember(member.id);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MemberDetailScreen(
                        dashboard: dashboard,
                        memberId: member.id,
                        controller: controller,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        const SectionTitle('Nhắc nhở hôm nay'),
        if (dashboard.reminders.isEmpty)
          const EmptyState(text: 'Chưa có lịch nhắc nào cho hôm nay.')
        else
          for (final reminder in dashboard.reminders)
            _ReminderCard(
              reminder: reminder,
              memberName: dashboard.memberById(reminder.memberId).nickname,
            ),
        const SectionTitle('Thêm nhanh'),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.55,
          children: [
            _QuickAction(
              icon: Icons.monitor_heart_rounded,
              label: 'Thêm chỉ số',
              onTap: () => showMetricForm(context, controller, dashboard),
            ),
            _QuickAction(
              icon: Icons.medication_rounded,
              label: 'Thêm thuốc',
              onTap: () => showMedicineForm(context, controller, dashboard),
            ),
            _QuickAction(
              icon: Icons.upload_file_rounded,
              label: 'Thêm tài liệu',
              onTap: () => showDocumentForm(context, controller, dashboard),
            ),
            _QuickAction(
              icon: Icons.add_alert_rounded,
              label: 'Thêm lịch nhắc',
              onTap: () => showReminderForm(context, controller, dashboard),
            ),
          ],
        ),
        const SectionTitle('Xu hướng huyết áp'),
        MetricTrendChart(metrics: dashboard.metrics),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: AppCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            IconBubble(icon: icon, color: AppColors.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReminderCard extends StatelessWidget {
  const _ReminderCard({required this.reminder, required this.memberName});

  final Reminder reminder;
  final String memberName;

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
          ],
        ),
      ),
    );
  }
}
