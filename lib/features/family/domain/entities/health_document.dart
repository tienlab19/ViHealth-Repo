class HealthDocument {
  const HealthDocument({
    required this.id,
    required this.memberId,
    required this.title,
    required this.type,
    required this.hospitalName,
    required this.documentDate,
  });

  final String id;
  final String memberId;
  final String title;
  final String type;
  final String hospitalName;
  final DateTime documentDate;
}
