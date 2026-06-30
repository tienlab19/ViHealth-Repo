import '../entities/family_dashboard.dart';
import '../entities/family_member.dart';
import '../entities/health_document.dart';
import '../entities/health_metric.dart';
import '../entities/medicine.dart';
import '../entities/reminder.dart';

abstract class FamilyHealthRepository {
  Future<FamilyDashboard> getDashboard();

  Future<void> saveMember(FamilyMember member);

  Future<void> deleteMember(String memberId);

  Future<void> saveMetric(HealthMetric metric);

  Future<void> deleteMetric(String metricId);

  Future<void> saveMedicine(Medicine medicine);

  Future<void> deleteMedicine(String medicineId);

  Future<void> saveDocument(HealthDocument document);

  Future<void> deleteDocument(String documentId);

  Future<void> saveReminder(Reminder reminder);

  Future<void> deleteReminder(String reminderId);
}
