import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/status_pill.dart';
import '../../domain/entities/family_dashboard.dart';
import '../controllers/family_dashboard_controller.dart';
import '../widgets/family_actions.dart';
import '../widgets/metric_trend_chart.dart';
import '../widgets/vihealth_ui.dart';
import 'health_metric_screen.dart';
import 'medicine_screen.dart';

class MemberDetailScreen extends StatelessWidget {
  const MemberDetailScreen({
    required this.dashboard,
    required this.memberId,
    this.controller,
    super.key,
  });

  final FamilyDashboard dashboard;
  final String memberId;
  final FamilyDashboardController? controller;

  @override
  Widget build(BuildContext context) {
    final member = dashboard.memberById(memberId);
    final metrics = dashboard.metricsOf(memberId);
    final medicines = dashboard.medicinesOf(memberId);
    final documents = dashboard.documentsOf(memberId);

    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết hồ sơ')),
      body: ViHealthPage(
        title: member.fullName,
        subtitle:
            '${member.relationship} - ${member.age} tuổi - Nhóm máu ${member.bloodType}',
        trailing: MemberAvatar(
          label: member.avatarLabel,
          color: memberColor(member.id),
        ),
        children: [
          AppCard(
            child: Text(
              member.healthNote,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SectionTitle('Lối tắt chăm sóc'),
          Row(
            children: [
              Expanded(
                child: _DetailAction(
                  icon: Icons.monitor_heart_rounded,
                  label: 'Chỉ số',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => HealthMetricScreen(
                        member: member,
                        metrics: metrics,
                        controller: controller,
                        dashboard: dashboard,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _DetailAction(
                  icon: Icons.medication_rounded,
                  label: 'Thuốc',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MedicineScreen(
                        member: member,
                        medicines: medicines,
                        controller: controller,
                        dashboard: dashboard,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SectionTitle('Chỉ số sức khỏe'),
          if (metrics.isEmpty)
            const EmptyState(text: 'Chưa có chỉ số sức khỏe.')
          else
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.05,
              children: [
                for (final metric in metrics) MetricCard(metric: metric),
              ],
            ),
          const SectionTitle('Biểu đồ theo dõi'),
          MetricTrendChart(metrics: metrics),
          const SectionTitle('Thuốc và tài liệu'),
          if (controller != null)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => showMetricForm(
                      context,
                      controller!,
                      dashboard,
                      memberId: memberId,
                    ),
                    icon: const Icon(Icons.add_chart_rounded),
                    label: const Text('Chỉ số'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => showDocumentForm(
                      context,
                      controller!,
                      dashboard,
                      memberId: memberId,
                    ),
                    icon: const Icon(Icons.upload_file_rounded),
                    label: const Text('Tài liệu'),
                  ),
                ),
              ],
            ),
          if (controller != null) const SizedBox(height: 10),
          AppCard(
            child: Row(
              children: [
                const IconBubble(
                  icon: Icons.medication_rounded,
                  color: AppColors.warning,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${medicines.length} thuốc đang theo dõi',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                StatusPill('${documents.length} tài liệu', tone: PillTone.blue),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailAction extends StatelessWidget {
  const _DetailAction({
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconBubble(icon: icon, color: AppColors.primary),
            const SizedBox(height: 12),
            Text(label, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
