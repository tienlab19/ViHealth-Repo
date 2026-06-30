class Appointment {
  const Appointment({
    required this.id,
    required this.memberId,
    required this.title,
    required this.hospitalName,
    required this.visitAt,
    required this.note,
  });

  final String id;
  final String memberId;
  final String title;
  final String hospitalName;
  final DateTime visitAt;
  final String note;
}
