import '../../domain/entities/family_dashboard.dart';
import '../../domain/entities/family_member.dart';
import '../../domain/entities/health_document.dart';
import '../../domain/entities/health_metric.dart';
import '../../domain/entities/medicine.dart';
import '../../domain/entities/reminder.dart';
import '../../domain/repositories/family_health_repository.dart';

class MockFamilyHealthRepository implements FamilyHealthRepository {
  final List<FamilyMember> _members = [
    const FamilyMember(
      id: 'me',
      fullName: 'Tôi',
      nickname: 'Tôi',
      relationship: 'Cá nhân',
      age: 32,
      bloodType: 'O',
      healthNote: 'Theo dõi sức khỏe định kỳ',
      avatarLabel: 'T',
    ),
    const FamilyMember(
      id: 'father',
      fullName: 'Nguyễn Văn Bình',
      nickname: 'Bố',
      relationship: 'Bố',
      age: 65,
      bloodType: 'B',
      healthNote: 'Tăng huyết áp, cần đo huyết áp buổi sáng',
      avatarLabel: 'B',
    ),
    const FamilyMember(
      id: 'mother',
      fullName: 'Trần Thị Mai',
      nickname: 'Mẹ',
      relationship: 'Mẹ',
      age: 61,
      bloodType: 'A',
      healthNote: 'Theo dõi đường huyết trước ăn sáng',
      avatarLabel: 'M',
    ),
    const FamilyMember(
      id: 'child',
      fullName: 'Bé Ngọc',
      nickname: 'Ngọc',
      relationship: 'Con gái',
      age: 5,
      bloodType: 'O',
      healthNote: 'Lưu lịch tiêm chủng và giấy khám nhi',
      avatarLabel: 'N',
    ),
  ];
  final List<HealthMetric> _metrics = [
    HealthMetric(
      id: 'metric-bp-1',
      memberId: 'father',
      type: MetricType.bloodPressure,
      primaryValue: '125',
      secondaryValue: '80',
      unit: 'mmHg',
      measuredAt: DateTime(2026, 6, 30, 7, 10),
      context: 'Sau khi ngủ dậy',
      note: 'Dễ theo dõi hơn khi đo cùng thời điểm mỗi ngày',
    ),
    HealthMetric(
      id: 'metric-hr-1',
      memberId: 'father',
      type: MetricType.heartRate,
      primaryValue: '75',
      secondaryValue: null,
      unit: 'bpm',
      measuredAt: DateTime(2026, 6, 30, 7, 12),
      context: 'Nghỉ ngơi',
      note: '',
    ),
    HealthMetric(
      id: 'metric-sugar-1',
      memberId: 'mother',
      type: MetricType.bloodSugar,
      primaryValue: '112',
      secondaryValue: null,
      unit: 'mg/dL',
      measuredAt: DateTime(2026, 6, 30, 6, 50),
      context: 'Trước ăn sáng',
      note: 'Ghi lại để mang theo khi tái khám',
    ),
    HealthMetric(
      id: 'metric-weight-1',
      memberId: 'child',
      type: MetricType.weight,
      primaryValue: '18.5',
      secondaryValue: null,
      unit: 'kg',
      measuredAt: DateTime(2026, 6, 28, 19),
      context: 'Buổi tối',
      note: 'Theo dõi tăng trưởng',
    ),
  ];
  final List<Medicine> _medicines = [
    const Medicine(
      id: 'medicine-1',
      memberId: 'father',
      name: 'Amlodipine',
      strength: '5mg',
      dosage: '1 viên / lần',
      instruction: 'Sau ăn sáng',
      timeText: '07:30',
      status: MedicineStatus.active,
    ),
    const Medicine(
      id: 'medicine-2',
      memberId: 'mother',
      name: 'Metformin',
      strength: '500mg',
      dosage: '1 viên / lần',
      instruction: 'Sau ăn tối',
      timeText: '19:00',
      status: MedicineStatus.active,
    ),
  ];
  final List<HealthDocument> _documents = [
    HealthDocument(
      id: 'document-1',
      memberId: 'father',
      title: 'Kết quả xét nghiệm máu',
      type: 'PDF',
      hospitalName: 'Bệnh viện A',
      documentDate: DateTime(2026, 6, 12),
      source: DocumentSource.upload,
      fileName: 'ket-qua-xet-nghiem-mau.pdf',
      fileSizeBytes: 1420000,
    ),
    HealthDocument(
      id: 'document-2',
      memberId: 'father',
      title: 'Đơn thuốc khám tim mạch',
      type: 'IMG',
      hospitalName: 'Phòng khám Tim mạch',
      documentDate: DateTime(2026, 6, 10),
      source: DocumentSource.camera,
      fileName: 'don-thuoc-tim-mach.jpg',
      fileSizeBytes: 860000,
    ),
    HealthDocument(
      id: 'document-3',
      memberId: 'child',
      title: 'Lịch tiêm chủng',
      type: 'PDF',
      hospitalName: 'Phòng khám Nhi B',
      documentDate: DateTime(2026, 6, 5),
      source: DocumentSource.upload,
      fileName: 'lich-tiem-chung.pdf',
      fileSizeBytes: 980000,
    ),
  ];
  final List<Reminder> _reminders = [
    const Reminder(
      id: 'reminder-1',
      memberId: 'father',
      type: ReminderType.medicine,
      title: 'Uống thuốc huyết áp',
      description: 'Amlodipine 5mg sau ăn sáng',
      timeText: '07:30',
      isEnabled: true,
    ),
    const Reminder(
      id: 'reminder-2',
      memberId: 'mother',
      type: ReminderType.metric,
      title: 'Đo đường huyết',
      description: 'Trước ăn sáng',
      timeText: '08:00',
      isEnabled: true,
    ),
    const Reminder(
      id: 'reminder-3',
      memberId: 'child',
      type: ReminderType.vaccine,
      title: 'Tái khám nhi',
      description: 'Mang theo lịch tiêm chủng',
      timeText: '15:00',
      isEnabled: true,
    ),
  ];

  @override
  Future<FamilyDashboard> getDashboard() async {
    return FamilyDashboard(
      members: List.unmodifiable(_members),
      metrics: List.unmodifiable(_metrics),
      medicines: List.unmodifiable(_medicines),
      documents: List.unmodifiable(_documents),
      reminders: List.unmodifiable(_reminders),
      appointments: [],
    );
  }

  @override
  Future<void> saveMember(FamilyMember member) async {
    _upsert(_members, member.id, member, (item) => item.id);
  }

  @override
  Future<void> deleteMember(String memberId) async {
    _members.removeWhere((item) => item.id == memberId);
    _metrics.removeWhere((item) => item.memberId == memberId);
    _medicines.removeWhere((item) => item.memberId == memberId);
    _documents.removeWhere((item) => item.memberId == memberId);
    _reminders.removeWhere((item) => item.memberId == memberId);
  }

  @override
  Future<void> saveMetric(HealthMetric metric) async {
    _upsert(_metrics, metric.id, metric, (item) => item.id);
  }

  @override
  Future<void> deleteMetric(String metricId) async {
    _metrics.removeWhere((item) => item.id == metricId);
  }

  @override
  Future<void> saveMedicine(Medicine medicine) async {
    _upsert(_medicines, medicine.id, medicine, (item) => item.id);
  }

  @override
  Future<void> deleteMedicine(String medicineId) async {
    _medicines.removeWhere((item) => item.id == medicineId);
  }

  @override
  Future<void> saveDocument(HealthDocument document) async {
    _upsert(_documents, document.id, document, (item) => item.id);
  }

  @override
  Future<void> deleteDocument(String documentId) async {
    _documents.removeWhere((item) => item.id == documentId);
  }

  @override
  Future<void> saveReminder(Reminder reminder) async {
    _upsert(_reminders, reminder.id, reminder, (item) => item.id);
  }

  @override
  Future<void> deleteReminder(String reminderId) async {
    _reminders.removeWhere((item) => item.id == reminderId);
  }
}

void _upsert<T>(List<T> items, String id, T value, String Function(T) idOf) {
  final index = items.indexWhere((item) => idOf(item) == id);
  if (index == -1) {
    items.add(value);
  } else {
    items[index] = value;
  }
}
