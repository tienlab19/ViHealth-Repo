enum MetricType {
  bloodPressure,
  bloodSugar,
  weight,
  height,
  temperature,
  heartRate,
  spo2,
}

class HealthMetric {
  const HealthMetric({
    required this.id,
    required this.memberId,
    required this.type,
    required this.primaryValue,
    required this.secondaryValue,
    required this.unit,
    required this.measuredAt,
    required this.context,
    required this.note,
  });

  final String id;
  final String memberId;
  final MetricType type;
  final String primaryValue;
  final String? secondaryValue;
  final String unit;
  final DateTime measuredAt;
  final String context;
  final String note;

  String get displayValue {
    if (secondaryValue == null) return '$primaryValue $unit';
    return '$primaryValue/$secondaryValue $unit';
  }

  String get typeLabel {
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
}
