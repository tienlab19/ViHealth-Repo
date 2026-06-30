import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/status_pill.dart';
import '../../domain/entities/family_member.dart';
import '../../domain/entities/health_metric.dart';
import '../../domain/entities/reminder.dart';

class ViHealthPage extends StatelessWidget {
  const ViHealthPage({
    required this.title,
    required this.subtitle,
    required this.children,
    this.trailing,
    super.key,
  });

  final String title;
  final String subtitle;
  final Widget? trailing;
  final List<Widget> children;

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
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.muted,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[const SizedBox(width: 12), trailing!],
          ],
        ),
        const SizedBox(height: 18),
        ...children,
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 10),
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class MemberAvatar extends StatelessWidget {
  const MemberAvatar({
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
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w900,
            fontSize: size < 40 ? 13 : 16,
          ),
        ),
      ),
    );
  }
}

class IconBubble extends StatelessWidget {
  const IconBubble({
    required this.icon,
    required this.color,
    this.size = 44,
    super.key,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }
}

class StatCard extends StatelessWidget {
  const StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    super.key,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconBubble(icon: icon, color: color, size: 38),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class MetricCard extends StatelessWidget {
  const MetricCard({required this.metric, super.key});

  final HealthMetric metric;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconBubble(
                icon: metricIcon(metric.type),
                color: metricColor(metric.type),
                size: 38,
              ),
              const Spacer(),
              StatusPill(metric.context, tone: PillTone.blue),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            metric.displayValue,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(metric.typeLabel, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          const IconBubble(
            icon: Icons.info_outline_rounded,
            color: AppColors.secondary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}

class FilterPills extends StatelessWidget {
  const FilterPills({required this.labels, this.selectedIndex = 0, super.key});

  final List<String> labels;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var index = 0; index < labels.length; index++)
          StatusPill(
            labels[index],
            tone: index == selectedIndex ? PillTone.green : PillTone.blue,
          ),
      ],
    );
  }
}

class MemberMiniCard extends StatelessWidget {
  const MemberMiniCard({
    required this.member,
    this.onTap,
    this.selected = false,
    super.key,
  });

  final FamilyMember member;
  final VoidCallback? onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        width: 148,
        padding: const EdgeInsets.all(13),
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
            MemberAvatar(
              label: member.avatarLabel,
              color: memberColor(member.id),
              size: 40,
            ),
            const Spacer(),
            Text(
              member.nickname,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              '${member.relationship} - ${member.age} tuổi',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

Color memberColor(String id) {
  return switch (id) {
    'father' => AppColors.secondary,
    'mother' => AppColors.purple,
    'child' => AppColors.warning,
    _ => AppColors.primary,
  };
}

IconData metricIcon(MetricType type) {
  return switch (type) {
    MetricType.bloodPressure => Icons.monitor_heart_rounded,
    MetricType.bloodSugar => Icons.bloodtype_rounded,
    MetricType.weight => Icons.scale_rounded,
    MetricType.height => Icons.height_rounded,
    MetricType.temperature => Icons.thermostat_rounded,
    MetricType.heartRate => Icons.favorite_rounded,
    MetricType.spo2 => Icons.air_rounded,
  };
}

Color metricColor(MetricType type) {
  return switch (type) {
    MetricType.bloodPressure => AppColors.primary,
    MetricType.bloodSugar => AppColors.purple,
    MetricType.weight => AppColors.warning,
    MetricType.height => AppColors.secondary,
    MetricType.temperature => AppColors.danger,
    MetricType.heartRate => AppColors.danger,
    MetricType.spo2 => AppColors.secondary,
  };
}

IconData reminderIcon(ReminderType type) {
  return switch (type) {
    ReminderType.medicine => Icons.medication_rounded,
    ReminderType.metric => Icons.monitor_heart_rounded,
    ReminderType.appointment => Icons.local_hospital_rounded,
    ReminderType.vaccine => Icons.vaccines_rounded,
    ReminderType.buyMedicine => Icons.shopping_bag_rounded,
  };
}

PillTone reminderTone(ReminderType type) {
  return switch (type) {
    ReminderType.medicine => PillTone.orange,
    ReminderType.metric => PillTone.green,
    ReminderType.appointment => PillTone.blue,
    ReminderType.vaccine => PillTone.purple,
    ReminderType.buyMedicine => PillTone.red,
  };
}
