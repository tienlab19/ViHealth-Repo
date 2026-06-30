enum MedicineStatus { active, stopped }

class Medicine {
  const Medicine({
    required this.id,
    required this.memberId,
    required this.name,
    required this.strength,
    required this.dosage,
    required this.instruction,
    required this.timeText,
    required this.status,
  });

  final String id;
  final String memberId;
  final String name;
  final String strength;
  final String dosage;
  final String instruction;
  final String timeText;
  final MedicineStatus status;
}
