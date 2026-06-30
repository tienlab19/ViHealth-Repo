import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/status_pill.dart';
import '../../domain/entities/family_dashboard.dart';
import '../../domain/entities/family_member.dart';
import '../../domain/entities/health_document.dart';
import '../../domain/entities/health_metric.dart';
import '../../domain/entities/medicine.dart';
import '../../domain/entities/reminder.dart';
import '../controllers/family_dashboard_controller.dart';
import '../widgets/avatar_badge.dart';
import '../widgets/health_list_tile.dart';
import '../widgets/metric_trend_chart.dart';
import '../widgets/quick_action_grid.dart';
import '../widgets/section_header.dart';

class ViHealthAppShell extends StatelessWidget {
  const ViHealthAppShell({required this.controller, super.key});

  final FamilyDashboardController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final dashboard = controller.dashboard;
        if (controller.isLoading || dashboard == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final screens = [
          _HomeScreen(
            controller: controller,
            dashboard: dashboard,
            onMemberTap: controller.selectMember,
          ),
          _MembersScreen(
            controller: controller,
            dashboard: dashboard,
            selectedMemberId: controller.selectedMemberId,
            onMemberTap: controller.selectMember,
          ),
          _CalendarScreen(controller: controller, dashboard: dashboard),
          _DocumentsScreen(controller: controller, dashboard: dashboard),
          _SettingsScreen(controller: controller, dashboard: dashboard),
        ];

        return Scaffold(
          body: SafeArea(
            child: IndexedStack(
              index: controller.selectedIndex.clamp(0, screens.length - 1),
              children: screens,
            ),
          ),
          bottomNavigationBar: _BottomNavShell(
            selectedIndex: controller.selectedIndex,
            onDestinationSelected: controller.selectTab,
          ),
        );
      },
    );
  }
}

class _BottomNavShell extends StatelessWidget {
  const _BottomNavShell({
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      child: Container(
        height: 66,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.line),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 26,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: NavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            height: 64,
            backgroundColor: Colors.transparent,
            indicatorColor: Colors.transparent,
            elevation: 0,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Trang chủ',
              ),
              NavigationDestination(
                icon: Icon(Icons.favorite_border_rounded),
                selectedIcon: Icon(Icons.favorite_rounded),
                label: 'Hồ sơ',
              ),
              NavigationDestination(
                icon: Icon(Icons.calendar_month_outlined),
                selectedIcon: Icon(Icons.calendar_month_rounded),
                label: 'Lịch',
              ),
              NavigationDestination(
                icon: Icon(Icons.description_outlined),
                selectedIcon: Icon(Icons.description_rounded),
                label: 'Tài liệu',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings_rounded),
                label: 'Cài đặt',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Page extends StatelessWidget {
  const _Page({
    required this.title,
    required this.subtitle,
    required this.children,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 110),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.headlineLarge),
                  const SizedBox(height: 6),
                  SubtleText(subtitle),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
        ...children,
      ],
    );
  }
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen({
    required this.controller,
    required this.dashboard,
    required this.onMemberTap,
  });

  final FamilyDashboardController controller;
  final FamilyDashboard dashboard;
  final ValueChanged<String> onMemberTap;

  @override
  Widget build(BuildContext context) {
    return _Page(
      title: 'Chào bạn',
      subtitle:
          'Hôm nay có ${dashboard.reminders.length + dashboard.appointments.length} việc sức khỏe cần theo dõi.',
      trailing: const AvatarBadge(label: 'VH'),
      children: [
        const SizedBox(height: 18),
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
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${dashboard.members.length} hồ sơ - ${dashboard.reminders.length} lịch nhắc - ${dashboard.documents.length} tài liệu',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.82),
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
        const SectionHeader('Thành viên gia đình'),
        if (dashboard.members.isEmpty)
          const _EmptyState(
            text:
                'Bạn chưa có hồ sơ thành viên nào. Hãy tạo hồ sơ đầu tiên để bắt đầu theo dõi sức khỏe.',
          )
        else
          SizedBox(
            height: 122,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: dashboard.members.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final member = dashboard.members[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => onMemberTap(member.id),
                  child: Container(
                    width: 150,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.line),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 22,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AvatarBadge(
                          label: member.avatarLabel,
                          color: _memberColor(member.id),
                          size: 38,
                        ),
                        const Spacer(),
                        Text(
                          member.nickname,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SubtleText(
                          '${member.relationship} - ${member.age} tuổi',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        const SectionHeader('Nhắc nhở hôm nay'),
        if (dashboard.reminders.isEmpty)
          const _EmptyState(
            text:
                'Chưa có lịch nhắc nào. Hãy thêm lịch uống thuốc hoặc lịch tái khám để app nhắc bạn đúng lúc.',
          )
        else
          for (final reminder in dashboard.reminders.take(3))
            _ReminderTile(
              reminder: reminder,
              member: dashboard.memberById(reminder.memberId),
            ),
        const SectionHeader('Thêm nhanh'),
        QuickActionGrid(
          onMetric: dashboard.members.isEmpty
              ? null
              : () => _showMetricSheet(context, controller, dashboard),
          onMedicine: dashboard.members.isEmpty
              ? null
              : () => _showMedicineSheet(context, controller, dashboard),
          onDocument: dashboard.members.isEmpty
              ? null
              : () => _showDocumentSheet(context, controller, dashboard),
          onReminder: dashboard.members.isEmpty
              ? null
              : () => _showReminderSheet(context, controller, dashboard),
        ),
        const SectionHeader('Chỉ số gần đây'),
        if (dashboard.metrics.isEmpty)
          const _EmptyState(
            text: 'Bạn có thể ghi lại chỉ số hôm nay để dễ theo dõi hơn.',
          )
        else
          _MetricGrid(metrics: dashboard.metrics.take(4).toList()),
      ],
    );
  }
}

class _MembersScreen extends StatelessWidget {
  const _MembersScreen({
    required this.controller,
    required this.dashboard,
    required this.selectedMemberId,
    required this.onMemberTap,
  });

  final FamilyDashboardController controller;
  final FamilyDashboard dashboard;
  final String selectedMemberId;
  final ValueChanged<String> onMemberTap;

  @override
  Widget build(BuildContext context) {
    if (dashboard.members.isEmpty) {
      return _Page(
        title: 'Hồ sơ gia đình',
        subtitle: 'Chưa có thành viên nào đang theo dõi.',
        trailing: IconButton.filledTonal(
          onPressed: () => _showMemberSheet(context, controller),
          icon: const Icon(Icons.person_add_alt_1_rounded),
        ),
        children: const [
          SectionHeader('Danh sách thành viên'),
          _EmptyState(
            text:
                'Bạn chưa có hồ sơ thành viên nào. Hãy tạo hồ sơ đầu tiên để bắt đầu theo dõi sức khỏe.',
          ),
        ],
      );
    }

    final member = dashboard.memberById(selectedMemberId);
    final metrics = dashboard.metricsOf(selectedMemberId);
    final medicines = dashboard.medicinesOf(selectedMemberId);
    final documents = dashboard.documentsOf(selectedMemberId);

    return _Page(
      title: 'Hồ sơ gia đình',
      subtitle: '${dashboard.members.length} thành viên đang theo dõi.',
      trailing: IconButton.filledTonal(
        onPressed: () => _showMemberSheet(context, controller),
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
        const SectionHeader('Danh sách thành viên'),
        SizedBox(
          height: 104,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: dashboard.members.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final item = dashboard.members[index];
              final selected = item.id == selectedMemberId;
              return InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => onMemberTap(item.id),
                child: Container(
                  width: 132,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primarySoft : AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected ? AppColors.primary : AppColors.line,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AvatarBadge(
                        label: item.avatarLabel,
                        color: _memberColor(item.id),
                        size: 36,
                      ),
                      const Spacer(),
                      Text(
                        item.nickname,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SubtleText('${item.age} tuổi'),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SectionHeader('Chi tiết thành viên'),
        AppCard(
          padding: const EdgeInsets.all(18),
          gradient: const LinearGradient(
            colors: [Color(0xFF12342B), AppColors.primaryDark],
          ),
          child: Row(
            children: [
              AvatarBadge(label: member.avatarLabel, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.fullName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${member.relationship} - ${member.age} tuổi - Nhóm máu ${member.bloodType}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.78),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      _showMemberSheet(context, controller, member: member),
                  icon: const Icon(Icons.edit_rounded),
                  label: const Text('Sửa hồ sơ'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      _confirmDeleteMember(context, controller, member),
                  icon: const Icon(Icons.delete_outline_rounded),
                  label: const Text('Xóa'),
                ),
              ),
            ],
          ),
        ),
        const SectionHeader('Chỉ số gần nhất'),
        if (metrics.isEmpty)
          const _EmptyState(
            text: 'Bạn có thể ghi lại chỉ số hôm nay để dễ theo dõi hơn.',
          )
        else
          _MetricGrid(metrics: metrics),
        const SectionHeader('Xu hướng huyết áp'),
        MetricTrendChart(metrics: metrics),
        const SectionHeader('Thuốc đang dùng'),
        if (medicines.isEmpty)
          const _EmptyState(
            text:
                'Chưa có thuốc đang dùng. Hãy thêm thuốc để ghi liều lượng, cách dùng và lịch nhắc.',
          )
        else
          for (final medicine in medicines)
            Dismissible(
              key: ValueKey(medicine.id),
              background: const _DismissBackground(),
              onDismissed: (_) => controller.deleteMedicine(medicine.id),
              child: HealthListTile(
                leading: const AvatarBadge(
                  label: 'Rx',
                  color: AppColors.warning,
                ),
                title: '${medicine.name} ${medicine.strength}',
                subtitle: '${medicine.dosage} - ${medicine.instruction}',
                trailing: StatusPill(
                  medicine.status == MedicineStatus.active
                      ? medicine.timeText
                      : 'Đã dừng',
                  tone: medicine.status == MedicineStatus.active
                      ? PillTone.orange
                      : PillTone.red,
                ),
                onTap: () => _showMedicineSheet(
                  context,
                  controller,
                  dashboard,
                  medicine: medicine,
                ),
              ),
            ),
        const SectionHeader('Tài liệu gần đây'),
        if (documents.isEmpty)
          const _EmptyState(
            text:
                'Chưa có tài liệu y tế nào. Bạn có thể chụp ảnh đơn thuốc hoặc tải lên file PDF.',
          )
        else
          for (final document in documents)
            Dismissible(
              key: ValueKey(document.id),
              background: const _DismissBackground(),
              onDismissed: (_) => controller.deleteDocument(document.id),
              child: _DocumentTile(document: document, member: member),
            ),
      ],
    );
  }
}

class _CalendarScreen extends StatelessWidget {
  const _CalendarScreen({required this.controller, required this.dashboard});

  final FamilyDashboardController controller;
  final FamilyDashboard dashboard;

  @override
  Widget build(BuildContext context) {
    final weekdays = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    final days = [
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
    final highlightedDays = {'25', '26', '30', '3'};

    return _Page(
      title: 'Lịch sức khỏe',
      subtitle: 'Theo dõi thuốc, tái khám, tiêm phòng và đo chỉ số.',
      trailing: IconButton.filledTonal(
        onPressed: dashboard.members.isEmpty
            ? null
            : () => _showReminderSheet(context, controller, dashboard),
        icon: const Icon(Icons.add_alert_rounded),
      ),
      children: [
        const SizedBox(height: 18),
        AppCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const IconCircle(
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
                    SubtleText(
                      '${dashboard.reminders.length} lịch nhắc đang theo dõi',
                    ),
                  ],
                ),
              ),
              FilledButton.tonalIcon(
                style: FilledButton.styleFrom(
                  minimumSize: const Size(88, 40),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: dashboard.members.isEmpty
                    ? null
                    : () => _showReminderSheet(context, controller, dashboard),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Thêm'),
              ),
            ],
          ),
        ),
        const SectionHeader('Lịch tháng'),
        AppCard(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  for (final weekday in weekdays)
                    Expanded(
                      child: Center(
                        child: Text(
                          weekday,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.muted,
                              ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              GridView.builder(
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
                  return _CalendarDayCell(
                    day: day,
                    isSelected: day == '30',
                    hasReminder: highlightedDays.contains(day),
                  );
                },
              ),
            ],
          ),
        ),
        const SectionHeader('Hôm nay, 30/06'),
        if (dashboard.reminders.isEmpty)
          const _EmptyState(
            text:
                'Chưa có lịch nhắc nào. Hãy thêm lịch uống thuốc, đo chỉ số hoặc tái khám.',
          )
        else
          Column(
            children: [
              for (final reminder in dashboard.reminders)
                _TimelineReminderCard(
                  reminder: reminder,
                  member: dashboard.memberById(reminder.memberId),
                  onTap: () => _showReminderSheet(
                    context,
                    controller,
                    dashboard,
                    reminder: reminder,
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

class _CalendarDayCell extends StatelessWidget {
  const _CalendarDayCell({
    required this.day,
    required this.isSelected,
    required this.hasReminder,
  });

  final String day;
  final bool isSelected;
  final bool hasReminder;

  @override
  Widget build(BuildContext context) {
    final textColor = isSelected
        ? Colors.white
        : hasReminder
        ? AppColors.primaryDark
        : AppColors.text;

    return Container(
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected || hasReminder ? AppColors.primary : AppColors.line,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: TextStyle(
              color: textColor,
              fontSize: 13,
              fontWeight: isSelected || hasReminder
                  ? FontWeight.w900
                  : FontWeight.w700,
            ),
          ),
          const SizedBox(height: 3),
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: hasReminder
                  ? (isSelected ? Colors.white : AppColors.primary)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineReminderCard extends StatelessWidget {
  const _TimelineReminderCard({
    required this.reminder,
    required this.member,
    required this.onTap,
  });

  final Reminder reminder;
  final FamilyMember member;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _reminderColor(reminder.type);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: AppCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Text(
                    reminder.timeText,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Container(
                    width: 2,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.line,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              IconCircle(icon: _reminderIcon(reminder.type), color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reminder.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 3),
                    SubtleText('${member.nickname} - ${reminder.description}'),
                    const SizedBox(height: 8),
                    StatusPill(
                      _reminderLabel(reminder.type),
                      tone: _reminderPillTone(reminder.type),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
            ],
          ),
        ),
      ),
    );
  }
}

class _DocumentsScreen extends StatelessWidget {
  const _DocumentsScreen({required this.controller, required this.dashboard});

  final FamilyDashboardController controller;
  final FamilyDashboard dashboard;

  @override
  Widget build(BuildContext context) {
    return _Page(
      title: 'Tài liệu y tế',
      subtitle:
          '${dashboard.documents.length} tài liệu - đơn thuốc, xét nghiệm, ảnh chụp và PDF.',
      trailing: IconButton.filledTonal(
        onPressed: dashboard.members.isEmpty
            ? null
            : () => _showDocumentSheet(context, controller, dashboard),
        icon: const Icon(Icons.upload_file_rounded),
      ),
      children: [
        const SectionHeader('Thêm tài liệu'),
        QuickActionGrid(
          onMetric: dashboard.members.isEmpty
              ? null
              : () => _showMetricSheet(context, controller, dashboard),
          onMedicine: dashboard.members.isEmpty
              ? null
              : () => _showMedicineSheet(context, controller, dashboard),
          onDocument: dashboard.members.isEmpty
              ? null
              : () => _showDocumentSheet(context, controller, dashboard),
          onReminder: dashboard.members.isEmpty
              ? null
              : () => _showReminderSheet(context, controller, dashboard),
        ),
        const SectionHeader('Bộ lọc tài liệu'),
        const _FilterChips(labels: ['Tất cả', 'PDF', 'Ảnh', 'Đơn thuốc']),
        const SectionHeader('Tất cả tài liệu'),
        if (dashboard.documents.isEmpty)
          const _EmptyState(
            text:
                'Chưa có tài liệu y tế nào. Bạn có thể chụp ảnh đơn thuốc hoặc tải lên file PDF.',
          )
        else
          for (final document in dashboard.documents)
            Dismissible(
              key: ValueKey(document.id),
              background: const _DismissBackground(),
              onDismissed: (_) => controller.deleteDocument(document.id),
              child: _DocumentTile(
                document: document,
                member: dashboard.memberById(document.memberId),
                onTap: () => _showDocumentSheet(
                  context,
                  controller,
                  dashboard,
                  document: document,
                ),
              ),
            ),
      ],
    );
  }
}

class _SettingsScreen extends StatelessWidget {
  const _SettingsScreen({required this.controller, required this.dashboard});

  final FamilyDashboardController controller;
  final FamilyDashboard dashboard;

  @override
  Widget build(BuildContext context) {
    return _Page(
      title: 'Cài đặt',
      subtitle: 'Quyền riêng tư, sao lưu, xuất dữ liệu và thông báo.',
      trailing: const AvatarBadge(label: 'VH'),
      children: [
        const SectionHeader('Tìm kiếm và xuất dữ liệu'),
        HealthListTile(
          leading: const IconCircle(
            icon: Icons.search_rounded,
            color: AppColors.primary,
          ),
          title: 'Tìm kiếm dữ liệu',
          subtitle: 'Tìm thành viên, thuốc, tài liệu và lịch nhắc đã lưu',
          onTap: () => _showSearchSheet(context, dashboard),
        ),
        HealthListTile(
          leading: const IconCircle(
            icon: Icons.picture_as_pdf_rounded,
            color: AppColors.purple,
          ),
          title: 'Xuất hồ sơ PDF',
          subtitle: 'Lưu hoặc chia sẻ khi đi khám',
          onTap: () => _showExportDialog(context, dashboard),
        ),
        const SectionHeader('Bảo mật dữ liệu'),
        HealthListTile(
          leading: const AvatarBadge(label: '', color: AppColors.primary),
          title: 'Khóa ứng dụng',
          subtitle: 'PIN, Face ID, Touch ID hoặc vân tay Android',
          trailing: const StatusPill('Bật'),
        ),
        HealthListTile(
          leading: const IconCircle(
            icon: Icons.backup_rounded,
            color: AppColors.secondary,
          ),
          title: 'Sao lưu dữ liệu',
          subtitle: 'Lần cuối: hôm nay 09:10',
        ),
        HealthListTile(
          leading: const IconCircle(
            icon: Icons.notifications_active_rounded,
            color: AppColors.warning,
          ),
          title: 'Thông báo',
          subtitle: '${dashboard.reminders.length} lịch nhắc đang bật',
        ),
        HealthListTile(
          leading: const IconCircle(
            icon: Icons.delete_outline_rounded,
            color: AppColors.danger,
          ),
          title: 'Xóa dữ liệu',
          subtitle: 'Xóa từng hồ sơ hoặc toàn bộ dữ liệu sau xác nhận',
          onTap: dashboard.members.isEmpty
              ? null
              : () => _confirmDeleteMember(
                  context,
                  controller,
                  dashboard.memberById(controller.selectedMemberId),
                ),
        ),
        const SectionHeader('Lưu ý y tế'),
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

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.metrics});

  final List<HealthMetric> metrics;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: metrics.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.28,
      ),
      itemBuilder: (context, index) {
        final metric = metrics[index];
        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                metric.typeLabel,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Spacer(),
              Text(
                metric.displayValue,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 21,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                metric.context,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ReminderTile extends StatelessWidget {
  const _ReminderTile({required this.reminder, required this.member});

  final Reminder reminder;
  final FamilyMember member;

  @override
  Widget build(BuildContext context) {
    return HealthListTile(
      leading: IconCircle(
        icon: reminder.type == ReminderType.medicine
            ? Icons.medication_rounded
            : Icons.water_drop_rounded,
        color: reminder.type == ReminderType.medicine
            ? AppColors.warning
            : AppColors.secondary,
      ),
      title: reminder.title,
      subtitle: '${member.nickname} - ${reminder.description}',
      trailing: StatusPill(
        reminder.timeText,
        tone: reminder.type == ReminderType.medicine
            ? PillTone.orange
            : PillTone.blue,
      ),
    );
  }
}

class _DocumentTile extends StatelessWidget {
  const _DocumentTile({
    required this.document,
    required this.member,
    this.onTap,
  });

  final HealthDocument document;
  final FamilyMember member;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return HealthListTile(
      leading: Container(
        width: 48,
        height: 58,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFE8F2FF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFCFE4FF)),
        ),
        child: Text(
          document.type,
          style: const TextStyle(
            color: AppColors.secondary,
            fontWeight: FontWeight.w900,
            fontSize: 12,
          ),
        ),
      ),
      title: document.title,
      subtitle:
          '${member.nickname} - ${document.hospitalName} - ${_formatDate(document.documentDate)}',
      onTap: onTap,
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(child: SubtleText(text)),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.labels});

  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var i = 0; i < labels.length; i++)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
            decoration: BoxDecoration(
              color: i == 0 ? AppColors.primarySoft : AppColors.surface,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.line),
            ),
            child: Text(
              labels[i],
              style: TextStyle(
                color: i == 0 ? AppColors.primaryDark : AppColors.muted,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
      ],
    );
  }
}

class IconCircle extends StatelessWidget {
  const IconCircle({required this.icon, required this.color, super.key});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: color),
    );
  }
}

class _DismissBackground extends StatelessWidget {
  const _DismissBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        color: AppColors.danger,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
    );
  }
}

void _showMemberSheet(
  BuildContext context,
  FamilyDashboardController controller, {
  FamilyMember? member,
}) {
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController(text: member?.fullName ?? '');
  final nickname = TextEditingController(text: member?.nickname ?? '');
  final relationship = TextEditingController(text: member?.relationship ?? '');
  final age = TextEditingController(text: member?.age.toString() ?? '');
  final bloodType = TextEditingController(text: member?.bloodType ?? '');
  final note = TextEditingController(text: member?.healthNote ?? '');

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => _FormSheet(
      title: member == null ? 'Thêm thành viên' : 'Sửa hồ sơ',
      subtitle: 'Lưu thông tin cá nhân và ghi chú y tế quan trọng.',
      child: Form(
        key: formKey,
        child: Column(
          children: [
            _AppTextField(controller: name, label: 'Họ và tên', required: true),
            _AppTextField(controller: nickname, label: 'Biệt danh'),
            _AppTextField(
              controller: relationship,
              label: 'Quan hệ',
              required: true,
            ),
            _AppTextField(
              controller: age,
              label: 'Tuổi',
              keyboardType: TextInputType.number,
            ),
            _AppTextField(controller: bloodType, label: 'Nhóm máu'),
            _AppTextField(controller: note, label: 'Ghi chú sức khỏe'),
            FilledButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                final id = member?.id ?? _newId('member');
                await controller.saveMember(
                  FamilyMember(
                    id: id,
                    fullName: name.text.trim(),
                    nickname: nickname.text.trim().isEmpty
                        ? name.text.trim()
                        : nickname.text.trim(),
                    relationship: relationship.text.trim(),
                    age: int.tryParse(age.text.trim()) ?? 0,
                    bloodType: bloodType.text.trim().isEmpty
                        ? '-'
                        : bloodType.text.trim(),
                    healthNote: note.text.trim().isEmpty
                        ? 'Chưa có ghi chú'
                        : note.text.trim(),
                    avatarLabel: _avatarLabel(name.text),
                  ),
                );
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Lưu hồ sơ'),
            ),
          ],
        ),
      ),
    ),
  );
}

void _showMetricSheet(
  BuildContext context,
  FamilyDashboardController controller,
  FamilyDashboard dashboard,
) {
  final formKey = GlobalKey<FormState>();
  var memberId = controller.selectedMemberId.isNotEmpty
      ? controller.selectedMemberId
      : dashboard.members.first.id;
  var type = MetricType.bloodPressure;
  final primary = TextEditingController();
  final secondary = TextEditingController();
  final contextText = TextEditingController();
  final note = TextEditingController();

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => _FormSheet(
        title: 'Ghi chỉ số',
        subtitle:
            'Nhập giá trị, đơn vị và bối cảnh đo. Dữ liệu dùng để theo dõi, không chẩn đoán.',
        child: Form(
          key: formKey,
          child: Column(
            children: [
              _MemberDropdown(
                dashboard: dashboard,
                value: memberId,
                onChanged: (value) => setState(() => memberId = value),
              ),
              DropdownButtonFormField<MetricType>(
                initialValue: type,
                decoration: const InputDecoration(labelText: 'Loại chỉ số'),
                items: MetricType.values
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(_metricLabel(item)),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => type = value ?? type),
              ),
              _AppTextField(
                controller: primary,
                label: 'Giá trị chính',
                required: true,
              ),
              _AppTextField(controller: secondary, label: 'Giá trị phụ'),
              _AppTextField(controller: contextText, label: 'Bối cảnh đo'),
              _AppTextField(controller: note, label: 'Ghi chú'),
              FilledButton(
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;
                  await controller.saveMetric(
                    HealthMetric(
                      id: _newId('metric'),
                      memberId: memberId,
                      type: type,
                      primaryValue: primary.text.trim(),
                      secondaryValue: secondary.text.trim().isEmpty
                          ? null
                          : secondary.text.trim(),
                      unit: _metricUnit(type),
                      measuredAt: DateTime.now(),
                      context: contextText.text.trim().isEmpty
                          ? 'Hôm nay'
                          : contextText.text.trim(),
                      note: note.text.trim(),
                    ),
                  );
                  if (context.mounted) Navigator.pop(context);
                },
                child: const Text('Lưu chỉ số'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

void _showMedicineSheet(
  BuildContext context,
  FamilyDashboardController controller,
  FamilyDashboard dashboard, {
  Medicine? medicine,
}) {
  final formKey = GlobalKey<FormState>();
  var memberId =
      medicine?.memberId ??
      (controller.selectedMemberId.isNotEmpty
          ? controller.selectedMemberId
          : dashboard.members.first.id);
  final name = TextEditingController(text: medicine?.name ?? '');
  final strength = TextEditingController(text: medicine?.strength ?? '');
  final dosage = TextEditingController(text: medicine?.dosage ?? '');
  final instruction = TextEditingController(text: medicine?.instruction ?? '');
  final time = TextEditingController(text: medicine?.timeText ?? '');
  var status = medicine?.status ?? MedicineStatus.active;

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => _FormSheet(
        title: medicine == null ? 'Thêm thuốc' : 'Sửa thuốc',
        subtitle:
            'Lưu tên thuốc, hàm lượng, liều lượng, cách dùng và thời gian uống.',
        child: Form(
          key: formKey,
          child: Column(
            children: [
              _MemberDropdown(
                dashboard: dashboard,
                value: memberId,
                onChanged: (value) => setState(() => memberId = value),
              ),
              _AppTextField(
                controller: name,
                label: 'Tên thuốc',
                required: true,
              ),
              _AppTextField(controller: strength, label: 'Hàm lượng'),
              _AppTextField(
                controller: dosage,
                label: 'Liều lượng',
                required: true,
              ),
              _AppTextField(controller: instruction, label: 'Cách dùng'),
              _AppTextField(
                controller: time,
                label: 'Giờ uống',
                required: true,
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Đang dùng'),
                value: status == MedicineStatus.active,
                onChanged: (value) => setState(
                  () => status = value
                      ? MedicineStatus.active
                      : MedicineStatus.stopped,
                ),
              ),
              FilledButton(
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;
                  await controller.saveMedicine(
                    Medicine(
                      id: medicine?.id ?? _newId('medicine'),
                      memberId: memberId,
                      name: name.text.trim(),
                      strength: strength.text.trim(),
                      dosage: dosage.text.trim(),
                      instruction: instruction.text.trim(),
                      timeText: time.text.trim(),
                      status: status,
                    ),
                  );
                  if (context.mounted) Navigator.pop(context);
                },
                child: const Text('Lưu thuốc'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

void _showDocumentSheet(
  BuildContext context,
  FamilyDashboardController controller,
  FamilyDashboard dashboard, {
  HealthDocument? document,
}) {
  final formKey = GlobalKey<FormState>();
  var memberId =
      document?.memberId ??
      (controller.selectedMemberId.isNotEmpty
          ? controller.selectedMemberId
          : dashboard.members.first.id);
  final title = TextEditingController(text: document?.title ?? '');
  final type = TextEditingController(text: document?.type ?? 'PDF');
  final hospital = TextEditingController(text: document?.hospitalName ?? '');

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => _FormSheet(
        title: document == null ? 'Thêm tài liệu' : 'Sửa tài liệu',
        subtitle:
            'Gắn tài liệu y tế với đúng thành viên để dễ tìm lại khi đi khám.',
        child: Form(
          key: formKey,
          child: Column(
            children: [
              _MemberDropdown(
                dashboard: dashboard,
                value: memberId,
                onChanged: (value) => setState(() => memberId = value),
              ),
              _AppTextField(
                controller: title,
                label: 'Tên tài liệu',
                required: true,
              ),
              _AppTextField(controller: type, label: 'Loại tài liệu'),
              _AppTextField(controller: hospital, label: 'Cơ sở y tế'),
              FilledButton(
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;
                  await controller.saveDocument(
                    HealthDocument(
                      id: document?.id ?? _newId('document'),
                      memberId: memberId,
                      title: title.text.trim(),
                      type: type.text.trim().isEmpty
                          ? 'PDF'
                          : type.text.trim().toUpperCase(),
                      hospitalName: hospital.text.trim().isEmpty
                          ? 'Chưa nhập'
                          : hospital.text.trim(),
                      documentDate: DateTime.now(),
                    ),
                  );
                  if (context.mounted) Navigator.pop(context);
                },
                child: const Text('Lưu tài liệu'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

void _showReminderSheet(
  BuildContext context,
  FamilyDashboardController controller,
  FamilyDashboard dashboard, {
  Reminder? reminder,
}) {
  final formKey = GlobalKey<FormState>();
  var memberId =
      reminder?.memberId ??
      (controller.selectedMemberId.isNotEmpty
          ? controller.selectedMemberId
          : dashboard.members.first.id);
  var type = reminder?.type ?? ReminderType.medicine;
  final title = TextEditingController(text: reminder?.title ?? '');
  final description = TextEditingController(text: reminder?.description ?? '');
  final time = TextEditingController(text: reminder?.timeText ?? '');
  var enabled = reminder?.isEnabled ?? true;

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => _FormSheet(
        title: reminder == null ? 'Thêm lịch nhắc' : 'Sửa lịch nhắc',
        subtitle:
            'Tạo nhắc uống thuốc, đo chỉ số, tái khám, tiêm phòng hoặc mua thuốc.',
        child: Form(
          key: formKey,
          child: Column(
            children: [
              _MemberDropdown(
                dashboard: dashboard,
                value: memberId,
                onChanged: (value) => setState(() => memberId = value),
              ),
              DropdownButtonFormField<ReminderType>(
                initialValue: type,
                decoration: const InputDecoration(labelText: 'Loại nhắc'),
                items: ReminderType.values
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(_reminderLabel(item)),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => type = value ?? type),
              ),
              _AppTextField(
                controller: title,
                label: 'Tiêu đề',
                required: true,
              ),
              _AppTextField(controller: description, label: 'Mô tả'),
              _AppTextField(
                controller: time,
                label: 'Giờ nhắc',
                required: true,
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Bật nhắc nhở'),
                value: enabled,
                onChanged: (value) => setState(() => enabled = value),
              ),
              FilledButton(
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;
                  await controller.saveReminder(
                    Reminder(
                      id: reminder?.id ?? _newId('reminder'),
                      memberId: memberId,
                      type: type,
                      title: title.text.trim(),
                      description: description.text.trim(),
                      timeText: time.text.trim(),
                      isEnabled: enabled,
                    ),
                  );
                  if (context.mounted) Navigator.pop(context);
                },
                child: const Text('Lưu lịch nhắc'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _FormSheet extends StatelessWidget {
  const _FormSheet({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        18,
        6,
        18,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 6),
            SubtleText(subtitle),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _AppTextField extends StatelessWidget {
  const _AppTextField({
    required this.controller,
    required this.label,
    this.required = false,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final bool required;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        ),
        validator: required
            ? (value) => (value == null || value.trim().isEmpty)
                  ? 'Vui lòng nhập $label'
                  : null
            : null,
      ),
    );
  }
}

class _MemberDropdown extends StatelessWidget {
  const _MemberDropdown({
    required this.dashboard,
    required this.value,
    required this.onChanged,
  });

  final FamilyDashboard dashboard;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        decoration: InputDecoration(
          labelText: 'Thành viên',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        ),
        items: dashboard.members
            .map(
              (member) => DropdownMenuItem(
                value: member.id,
                child: Text(member.fullName),
              ),
            )
            .toList(),
        onChanged: (value) {
          if (value != null) onChanged(value);
        },
      ),
    );
  }
}

Future<void> _confirmDeleteMember(
  BuildContext context,
  FamilyDashboardController controller,
  FamilyMember member,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Xóa hồ sơ?'),
      content: Text(
        'Xóa ${member.fullName} sẽ xóa cả chỉ số, thuốc, tài liệu và lịch nhắc liên quan.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Hủy'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Xóa'),
        ),
      ],
    ),
  );
  if (confirmed == true) {
    await controller.deleteMember(member.id);
  }
}

void _showExportDialog(BuildContext context, FamilyDashboard dashboard) {
  final summary =
      'Hồ sơ: ${dashboard.members.length}\nChỉ số: ${dashboard.metrics.length}\nThuốc: ${dashboard.medicines.length}\nTài liệu: ${dashboard.documents.length}\nLịch nhắc: ${dashboard.reminders.length}';
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Bản xuất hồ sơ'),
      content: Text(
        'Bản MVP đang tạo nội dung xuất dữ liệu dạng tóm tắt.\n\n$summary',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Đóng'),
        ),
      ],
    ),
  );
}

void _showSearchSheet(BuildContext context, FamilyDashboard dashboard) {
  var query = '';
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        final normalized = query.toLowerCase().trim();
        final results = normalized.isEmpty
            ? <String>[]
            : [
                ...dashboard.members
                    .where(
                      (item) =>
                          item.fullName.toLowerCase().contains(normalized) ||
                          item.healthNote.toLowerCase().contains(normalized),
                    )
                    .map((item) => 'Hồ sơ - ${item.fullName}'),
                ...dashboard.medicines
                    .where(
                      (item) => item.name.toLowerCase().contains(normalized),
                    )
                    .map((item) => 'Thuốc - ${item.name} ${item.strength}'),
                ...dashboard.documents
                    .where(
                      (item) =>
                          item.title.toLowerCase().contains(normalized) ||
                          item.hospitalName.toLowerCase().contains(normalized),
                    )
                    .map((item) => 'Tài liệu - ${item.title}'),
                ...dashboard.reminders
                    .where(
                      (item) =>
                          item.title.toLowerCase().contains(normalized) ||
                          item.description.toLowerCase().contains(normalized),
                    )
                    .map((item) => 'Lịch nhắc - ${item.title}'),
              ];

        return _FormSheet(
          title: 'Tìm kiếm dữ liệu',
          subtitle: 'Tìm theo tên, thuốc, tài liệu, cơ sở y tế hoặc ghi chú.',
          child: Column(
            children: [
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Từ khóa',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onChanged: (value) => setState(() => query = value),
              ),
              const SizedBox(height: 12),
              if (query.trim().isEmpty)
                const _EmptyState(
                  text: 'Nhập từ khóa để tìm trong dữ liệu đã lưu.',
                )
              else if (results.isEmpty)
                const _EmptyState(text: 'Không tìm thấy dữ liệu phù hợp.')
              else
                for (final result in results)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: AppCard(child: Text(result)),
                  ),
            ],
          ),
        );
      },
    ),
  );
}

String _newId(String prefix) {
  return '$prefix-${DateTime.now().microsecondsSinceEpoch}';
}

String _avatarLabel(String text) {
  final trimmed = text.trim();
  if (trimmed.isEmpty) return 'VH';
  return trimmed.characters.first.toUpperCase();
}

String _metricLabel(MetricType type) {
  return switch (type) {
    MetricType.bloodPressure => 'Huyết áp',
    MetricType.bloodSugar => 'Đường huyết',
    MetricType.weight => 'Cân nặng',
    MetricType.height => 'Chiều cao',
    MetricType.temperature => 'Nhiệt độ',
    MetricType.heartRate => 'Nhịp tim',
    MetricType.spo2 => 'SpO2',
  };
}

String _metricUnit(MetricType type) {
  return switch (type) {
    MetricType.bloodPressure => 'mmHg',
    MetricType.bloodSugar => 'mg/dL',
    MetricType.weight => 'kg',
    MetricType.height => 'cm',
    MetricType.temperature => '°C',
    MetricType.heartRate => 'bpm',
    MetricType.spo2 => '%',
  };
}

String _reminderLabel(ReminderType type) {
  return switch (type) {
    ReminderType.medicine => 'Uống thuốc',
    ReminderType.metric => 'Đo chỉ số',
    ReminderType.appointment => 'Tái khám',
    ReminderType.vaccine => 'Tiêm phòng',
    ReminderType.buyMedicine => 'Mua thuốc',
  };
}

Color _memberColor(String id) {
  return switch (id) {
    'father' => AppColors.secondary,
    'mother' => AppColors.purple,
    'child' => AppColors.danger,
    _ => AppColors.primary,
  };
}

Color _reminderColor(ReminderType type) {
  return switch (type) {
    ReminderType.medicine => AppColors.warning,
    ReminderType.metric => AppColors.secondary,
    ReminderType.appointment => AppColors.primary,
    ReminderType.vaccine => AppColors.purple,
    ReminderType.buyMedicine => AppColors.danger,
  };
}

IconData _reminderIcon(ReminderType type) {
  return switch (type) {
    ReminderType.medicine => Icons.medication_rounded,
    ReminderType.metric => Icons.monitor_heart_rounded,
    ReminderType.appointment => Icons.local_hospital_rounded,
    ReminderType.vaccine => Icons.vaccines_rounded,
    ReminderType.buyMedicine => Icons.shopping_bag_rounded,
  };
}

PillTone _reminderPillTone(ReminderType type) {
  return switch (type) {
    ReminderType.medicine => PillTone.orange,
    ReminderType.metric => PillTone.blue,
    ReminderType.appointment => PillTone.green,
    ReminderType.vaccine => PillTone.purple,
    ReminderType.buyMedicine => PillTone.red,
  };
}

String _formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}
