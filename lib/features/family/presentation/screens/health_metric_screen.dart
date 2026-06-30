import 'package:flutter/material.dart';

import '../../domain/entities/family_dashboard.dart';
import '../../domain/entities/family_member.dart';
import '../../domain/entities/health_metric.dart';
import '../controllers/family_dashboard_controller.dart';
import '../widgets/family_actions.dart';
import '../widgets/metric_trend_chart.dart';
import '../widgets/vihealth_ui.dart';

class HealthMetricScreen extends StatelessWidget {
  const HealthMetricScreen({
    required this.member,
    required this.metrics,
    this.controller,
    this.dashboard,
    super.key,
  });

  final FamilyMember member;
  final List<HealthMetric> metrics;
  final FamilyDashboardController? controller;
  final FamilyDashboard? dashboard;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chỉ số sức khỏe')),
      body: ViHealthPage(
        title: 'Chỉ số của ${member.nickname}',
        subtitle: 'Huyết áp, đường huyết, cân nặng và các chỉ số theo dõi.',
        trailing: IconButton.filledTonal(
          onPressed: controller == null || dashboard == null
              ? null
              : () => showMetricForm(
                  context,
                  controller!,
                  dashboard!,
                  memberId: member.id,
                ),
          icon: const Icon(Icons.add_chart_rounded),
        ),
        children: [
          const FilterPills(
            labels: ['Tất cả', 'Huyết áp', 'Đường huyết', 'Cân nặng'],
          ),
          const SectionTitle('Biểu đồ huyết áp'),
          MetricTrendChart(metrics: metrics),
          const SectionTitle('Danh sách chỉ số'),
          if (metrics.isEmpty)
            const EmptyState(text: 'Chưa có dữ liệu chỉ số cho hồ sơ này.')
          else
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.05,
              children: [
                for (final metric in metrics)
                  Stack(
                    children: [
                      MetricCard(metric: metric),
                      if (controller != null)
                        Positioned(
                          top: 4,
                          right: 4,
                          child: IconButton(
                            tooltip: 'Xóa chỉ số',
                            onPressed: () =>
                                controller!.deleteMetric(metric.id),
                            icon: const Icon(Icons.close_rounded, size: 18),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          const SectionTitle('Gợi ý ghi chú'),
          const EmptyState(
            text:
                'Nên đo cùng thời điểm mỗi ngày và ghi thêm bối cảnh như trước ăn, sau ngủ dậy hoặc sau vận động.',
          ),
        ],
      ),
    );
  }
}
