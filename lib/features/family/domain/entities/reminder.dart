enum ReminderType { medicine, metric, appointment, vaccine, buyMedicine }

class Reminder {
  const Reminder({
    required this.id,
    required this.memberId,
    required this.type,
    required this.title,
    required this.description,
    required this.timeText,
    required this.isEnabled,
  });

  final String id;
  final String memberId;
  final ReminderType type;
  final String title;
  final String description;
  final String timeText;
  final bool isEnabled;
}
