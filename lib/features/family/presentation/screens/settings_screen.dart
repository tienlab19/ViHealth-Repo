import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/status_pill.dart';
import '../../domain/entities/family_dashboard.dart';
import '../controllers/family_dashboard_controller.dart';
import '../widgets/family_actions.dart';
import '../widgets/vihealth_ui.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    required this.dashboard,
    required this.controller,
    super.key,
  });

  final FamilyDashboard dashboard;
  final FamilyDashboardController controller;

  @override
  Widget build(BuildContext context) {
    return ViHealthPage(
      title: 'Cài đặt',
      subtitle: 'Quyền riêng tư, sao lưu, xuất dữ liệu và thông báo.',
      trailing: const MemberAvatar(label: 'VH'),
      children: [
        const SectionTitle('Dữ liệu'),
        _SettingTile(
          icon: Icons.search_rounded,
          color: AppColors.primary,
          title: 'Tìm kiếm dữ liệu',
          subtitle: 'Tìm thành viên, thuốc, tài liệu và lịch nhắc',
          onTap: () => showSearchSheet(context, dashboard),
        ),
        _SettingTile(
          icon: Icons.picture_as_pdf_rounded,
          color: AppColors.purple,
          title: 'Xuất hồ sơ PDF',
          subtitle: 'Chuẩn bị bản tóm tắt khi đi khám',
          onTap: () => showFeatureSnack(context, 'Xuất hồ sơ PDF'),
        ),
        const SectionTitle('Bảo mật'),
        _SettingTile(
          icon: Icons.lock_rounded,
          color: AppColors.primary,
          title: 'Khóa ứng dụng',
          subtitle: 'PIN, Face ID, Touch ID hoặc vân tay Android',
          trailing: const StatusPill('Bật'),
          onTap: () => showFeatureSnack(context, 'Khóa ứng dụng'),
        ),
        _SettingTile(
          icon: Icons.backup_rounded,
          color: AppColors.secondary,
          title: 'Sao lưu dữ liệu',
          subtitle: 'Lần cuối: hôm nay 09:10',
          onTap: () => showFeatureSnack(context, 'Sao lưu dữ liệu'),
        ),
        _SettingTile(
          icon: Icons.notifications_active_rounded,
          color: AppColors.warning,
          title: 'Thông báo',
          subtitle: '${dashboard.reminders.length} lịch nhắc đang bật',
          onTap: () => showReminderForm(context, controller, dashboard),
        ),
        const SectionTitle('Lưu ý y tế'),
        const AppCard(
          child: Text(
            'ViHealth chỉ dùng để ghi chép và theo dõi thông tin sức khỏe cá nhân, không thay thế chẩn đoán hoặc tư vấn y tế.',
            style: TextStyle(color: AppColors.muted, height: 1.45),
          ),
        ),
      ],
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: AppCard(
          child: Row(
            children: [
              IconBubble(icon: icon, color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[const SizedBox(width: 8), trailing!],
            ],
          ),
        ),
      ),
    );
  }
}
