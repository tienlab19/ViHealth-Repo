import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/status_pill.dart';
import '../../domain/entities/family_dashboard.dart';
import '../controllers/family_dashboard_controller.dart';
import '../widgets/family_actions.dart';
import '../widgets/vihealth_ui.dart';
import 'health_metric_screen.dart';
import 'medicine_screen.dart';
import 'member_detail_screen.dart';

class ProfilesScreen extends StatelessWidget {
  const ProfilesScreen({
    required this.dashboard,
    required this.controller,
    super.key,
  });

  final FamilyDashboard dashboard;
  final FamilyDashboardController controller;

  @override
  Widget build(BuildContext context) {
    if (dashboard.members.isEmpty) {
      return ViHealthPage(
        title: 'Hồ sơ gia đình',
        subtitle: 'Chưa có thành viên nào đang theo dõi.',
        trailing: IconButton.filledTonal(
          onPressed: () => showMemberForm(context, controller),
          icon: const Icon(Icons.person_add_alt_1_rounded),
        ),
        children: const [
          EmptyState(
            text:
                'Bạn chưa có hồ sơ thành viên nào. Hãy tạo hồ sơ đầu tiên để bắt đầu theo dõi sức khỏe.',
          ),
        ],
      );
    }

    final selectedMember = dashboard.memberById(controller.selectedMemberId);
    final metrics = dashboard.metricsOf(selectedMember.id);
    final medicines = dashboard.medicinesOf(selectedMember.id);

    return ViHealthPage(
      title: 'Hồ sơ gia đình',
      subtitle: '${dashboard.members.length} thành viên đang theo dõi.',
      trailing: IconButton.filledTonal(
        onPressed: () => showMemberForm(context, controller),
        icon: const Icon(Icons.person_add_alt_1_rounded),
      ),
      children: [
        AppCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.search_rounded, color: AppColors.muted),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Tìm theo tên, quan hệ hoặc ghi chú sức khỏe',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
        const SectionTitle('Danh sách thành viên'),
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
                selected: member.id == selectedMember.id,
                onTap: () => controller.selectMember(member.id),
              );
            },
          ),
        ),
        const SectionTitle('Chi tiết nhanh'),
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => MemberDetailScreen(
                dashboard: dashboard,
                memberId: selectedMember.id,
                controller: controller,
              ),
            ),
          ),
          child: AppCard(
            padding: const EdgeInsets.all(18),
            gradient: const LinearGradient(
              colors: [Color(0xFF12342B), AppColors.primaryDark],
            ),
            child: Row(
              children: [
                MemberAvatar(
                  label: selectedMember.avatarLabel,
                  color: Colors.white,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedMember.fullName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${selectedMember.relationship} - ${selectedMember.age} tuổi - Nhóm máu ${selectedMember.bloodType}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.78),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: Colors.white),
              ],
            ),
          ),
        ),
        const SectionTitle('Lối tắt hồ sơ'),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () =>
                    showMemberForm(context, controller, member: selectedMember),
                icon: const Icon(Icons.edit_rounded),
                label: const Text('Sửa'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () =>
                    confirmDeleteMember(context, controller, selectedMember),
                icon: const Icon(Icons.delete_outline_rounded),
                label: const Text('Xóa'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _ShortcutButton(
                icon: Icons.monitor_heart_rounded,
                label: 'Chỉ số',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => HealthMetricScreen(
                      member: selectedMember,
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
              child: _ShortcutButton(
                icon: Icons.medication_rounded,
                label: 'Thuốc',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => MedicineScreen(
                      member: selectedMember,
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
        const SectionTitle('Chỉ số gần nhất'),
        if (metrics.isEmpty)
          const EmptyState(text: 'Chưa có chỉ số sức khỏe cho thành viên này.')
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
        const SectionTitle('Thuốc đang dùng'),
        if (medicines.isEmpty)
          const EmptyState(text: 'Chưa có thuốc đang dùng.')
        else
          for (final medicine in medicines)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AppCard(
                child: Row(
                  children: [
                    const IconBubble(
                      icon: Icons.medication_rounded,
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${medicine.name} ${medicine.strength}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${medicine.dosage} - ${medicine.instruction}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    StatusPill(medicine.timeText, tone: PillTone.orange),
                  ],
                ),
              ),
            ),
      ],
    );
  }
}

class _ShortcutButton extends StatelessWidget {
  const _ShortcutButton({
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
