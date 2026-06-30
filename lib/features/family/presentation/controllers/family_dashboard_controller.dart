import 'package:flutter/foundation.dart';

import '../../domain/entities/family_dashboard.dart';
import '../../domain/entities/family_member.dart';
import '../../domain/entities/health_document.dart';
import '../../domain/entities/health_metric.dart';
import '../../domain/entities/medicine.dart';
import '../../domain/entities/reminder.dart';
import '../../domain/repositories/family_health_repository.dart';
import '../../domain/usecases/get_family_dashboard.dart';

class FamilyDashboardController extends ChangeNotifier {
  FamilyDashboardController({
    required this.getFamilyDashboard,
    required this.repository,
  });

  final GetFamilyDashboard getFamilyDashboard;
  final FamilyHealthRepository repository;

  FamilyDashboard? dashboard;
  bool isLoading = true;
  int selectedIndex = 0;
  String selectedMemberId = '';

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    dashboard = await getFamilyDashboard();
    final members = dashboard?.members ?? [];
    if (members.isEmpty) {
      selectedMemberId = '';
    } else if (!members.any((member) => member.id == selectedMemberId)) {
      selectedMemberId = members.first.id;
    }
    isLoading = false;
    notifyListeners();
  }

  void selectTab(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void selectMember(String memberId) {
    selectedMemberId = memberId;
    selectedIndex = 1;
    notifyListeners();
  }

  Future<void> saveMember(FamilyMember member) async {
    await repository.saveMember(member);
    selectedMemberId = member.id;
    await load();
    selectedIndex = 1;
    notifyListeners();
  }

  Future<void> deleteSelectedMember() async {
    if (selectedMemberId.isEmpty) return;
    await deleteMember(selectedMemberId);
  }

  Future<void> deleteMember(String memberId) async {
    await repository.deleteMember(memberId);
    await load();
    selectedIndex = 1;
    notifyListeners();
  }

  Future<void> saveMetric(HealthMetric metric) async {
    await repository.saveMetric(metric);
    await load();
  }

  Future<void> deleteMetric(String metricId) async {
    await repository.deleteMetric(metricId);
    await load();
  }

  Future<void> saveMedicine(Medicine medicine) async {
    await repository.saveMedicine(medicine);
    await load();
  }

  Future<void> deleteMedicine(String medicineId) async {
    await repository.deleteMedicine(medicineId);
    await load();
  }

  Future<void> saveDocument(HealthDocument document) async {
    await repository.saveDocument(document);
    await load();
  }

  Future<void> deleteDocument(String documentId) async {
    await repository.deleteDocument(documentId);
    await load();
  }

  Future<void> saveReminder(Reminder reminder) async {
    await repository.saveReminder(reminder);
    await load();
  }

  Future<void> deleteReminder(String reminderId) async {
    await repository.deleteReminder(reminderId);
    await load();
  }
}
