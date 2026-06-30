import 'appointment.dart';
import 'family_member.dart';
import 'health_document.dart';
import 'health_metric.dart';
import 'medicine.dart';
import 'reminder.dart';

class FamilyDashboard {
  const FamilyDashboard({
    required this.members,
    required this.metrics,
    required this.medicines,
    required this.documents,
    required this.reminders,
    required this.appointments,
  });

  final List<FamilyMember> members;
  final List<HealthMetric> metrics;
  final List<Medicine> medicines;
  final List<HealthDocument> documents;
  final List<Reminder> reminders;
  final List<Appointment> appointments;

  FamilyMember memberById(String id) {
    return members.firstWhere((member) => member.id == id);
  }

  List<HealthMetric> metricsOf(String memberId) {
    return metrics.where((metric) => metric.memberId == memberId).toList();
  }

  List<Medicine> medicinesOf(String memberId) {
    return medicines
        .where((medicine) => medicine.memberId == memberId)
        .toList();
  }

  List<HealthDocument> documentsOf(String memberId) {
    return documents
        .where((document) => document.memberId == memberId)
        .toList();
  }
}
