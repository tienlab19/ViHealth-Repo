import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/health_metric.dart';

class MetricTrendChart extends StatelessWidget {
  const MetricTrendChart({required this.metrics, super.key});

  final List<HealthMetric> metrics;

  @override
  Widget build(BuildContext context) {
    final bloodPressureMetrics =
        metrics
            .where((metric) => metric.type == MetricType.bloodPressure)
            .toList()
          ..sort((a, b) => a.measuredAt.compareTo(b.measuredAt));
    final chartMetrics = bloodPressureMetrics.isEmpty
        ? _fallbackBloodPressureMetrics()
        : bloodPressureMetrics;

    final systolicSpots = <FlSpot>[];
    final diastolicSpots = <FlSpot>[];
    for (var i = 0; i < chartMetrics.length; i++) {
      final metric = chartMetrics[i];
      final systolic = double.tryParse(metric.primaryValue);
      final diastolic = double.tryParse(metric.secondaryValue ?? '');
      if (systolic != null) systolicSpots.add(FlSpot(i.toDouble(), systolic));
      if (diastolic != null) {
        diastolicSpots.add(FlSpot(i.toDouble(), diastolic));
      }
    }

    return Container(
      height: 176,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 14, 14, 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            children: const [
              _LegendDot(color: AppColors.primary, label: 'Tâm thu'),
              SizedBox(width: 14),
              _LegendDot(color: AppColors.secondary, label: 'Tâm trương'),
            ],
          ),
          const SizedBox(height: 14),
          Expanded(
            child: LineChart(
              LineChartData(
                minY: 60,
                maxY: 150,
                minX: 0,
                maxX: (chartMetrics.length - 1).toDouble(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 30,
                  getDrawingHorizontalLine: (_) =>
                      const FlLine(color: AppColors.line, strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 38,
                      interval: 30,
                      getTitlesWidget: _leftTitle,
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (spots) {
                      return spots.map((spot) {
                        final label = spot.barIndex == 0
                            ? 'Tâm thu'
                            : 'Tâm trương';
                        return LineTooltipItem(
                          '$label: ${spot.y.toStringAsFixed(0)} mmHg',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: [
                  _lineBar(systolicSpots, AppColors.primary),
                  _lineBar(diastolicSpots, AppColors.secondary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

LineChartBarData _lineBar(List<FlSpot> spots, Color color) {
  return LineChartBarData(
    spots: spots,
    isCurved: true,
    curveSmoothness: 0.28,
    barWidth: 4,
    color: color,
    isStrokeCapRound: true,
    dotData: FlDotData(
      show: true,
      getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
        radius: 4,
        color: color,
        strokeWidth: 2,
        strokeColor: Colors.white,
      ),
    ),
    belowBarData: BarAreaData(show: true, color: color.withValues(alpha: 0.08)),
  );
}

Widget _leftTitle(double value, TitleMeta meta) {
  if (value % 30 != 0) return const SizedBox.shrink();

  return SideTitleWidget(
    meta: meta,
    space: 8,
    child: SizedBox(
      width: 30,
      child: Text(
        value.toInt().toString(),
        maxLines: 1,
        textAlign: TextAlign.right,
        overflow: TextOverflow.visible,
        style: const TextStyle(
          color: AppColors.muted,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
    ),
  );
}

List<HealthMetric> _fallbackBloodPressureMetrics() {
  return [
    HealthMetric(
      id: 'fallback-bp-1',
      memberId: 'fallback',
      type: MetricType.bloodPressure,
      primaryValue: '132',
      secondaryValue: '84',
      unit: 'mmHg',
      measuredAt: DateTime(2026, 6, 24),
      context: 'Mẫu hiển thị',
      note: '',
    ),
    HealthMetric(
      id: 'fallback-bp-2',
      memberId: 'fallback',
      type: MetricType.bloodPressure,
      primaryValue: '128',
      secondaryValue: '82',
      unit: 'mmHg',
      measuredAt: DateTime(2026, 6, 26),
      context: 'Mẫu hiển thị',
      note: '',
    ),
    HealthMetric(
      id: 'fallback-bp-3',
      memberId: 'fallback',
      type: MetricType.bloodPressure,
      primaryValue: '125',
      secondaryValue: '80',
      unit: 'mmHg',
      measuredAt: DateTime(2026, 6, 30),
      context: 'Mẫu hiển thị',
      note: '',
    ),
  ];
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}
