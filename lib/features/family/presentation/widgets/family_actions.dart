import 'package:flutter/material.dart';

import '../../domain/entities/family_dashboard.dart';
import '../../domain/entities/family_member.dart';
import '../../domain/entities/health_document.dart';
import '../../domain/entities/health_metric.dart';
import '../../domain/entities/medicine.dart';
import '../../domain/entities/reminder.dart';
import '../controllers/family_dashboard_controller.dart';
import 'vihealth_ui.dart';

Future<void> showMemberForm(
  BuildContext context,
  FamilyDashboardController controller, {
  FamilyMember? member,
}) async {
  final name = TextEditingController(text: member?.fullName ?? '');
  final nickname = TextEditingController(text: member?.nickname ?? '');
  final relationship = TextEditingController(text: member?.relationship ?? '');
  final age = TextEditingController(text: member?.age.toString() ?? '');
  final bloodType = TextEditingController(text: member?.bloodType ?? '');
  final note = TextEditingController(text: member?.healthNote ?? '');

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) {
      return _ActionSheet(
        title: member == null ? 'Thêm thành viên' : 'Sửa hồ sơ',
        children: [
          _TextInput(controller: name, label: 'Họ và tên'),
          _TextInput(controller: nickname, label: 'Biệt danh'),
          _TextInput(controller: relationship, label: 'Quan hệ'),
          _TextInput(
            controller: age,
            label: 'Tuổi',
            keyboardType: TextInputType.number,
          ),
          _TextInput(controller: bloodType, label: 'Nhóm máu'),
          _TextInput(controller: note, label: 'Ghi chú sức khỏe'),
          FilledButton.icon(
            onPressed: () async {
              final fullName = name.text.trim();
              if (fullName.isEmpty) return;
              final saved = FamilyMember(
                id: member?.id ?? _id('member'),
                fullName: fullName,
                nickname: nickname.text.trim().isEmpty
                    ? fullName
                    : nickname.text.trim(),
                relationship: relationship.text.trim().isEmpty
                    ? 'Người thân'
                    : relationship.text.trim(),
                age: int.tryParse(age.text.trim()) ?? member?.age ?? 0,
                bloodType: bloodType.text.trim().isEmpty
                    ? 'Chưa rõ'
                    : bloodType.text.trim(),
                healthNote: note.text.trim().isEmpty
                    ? 'Theo dõi sức khỏe định kỳ'
                    : note.text.trim(),
                avatarLabel: _avatarLabel(fullName),
              );
              await controller.saveMember(saved);
              if (sheetContext.mounted) Navigator.pop(sheetContext);
              if (context.mounted) _snack(context, 'Đã lưu hồ sơ');
            },
            icon: const Icon(Icons.save_rounded),
            label: const Text('Lưu hồ sơ'),
          ),
        ],
      );
    },
  );
}

Future<void> showMetricForm(
  BuildContext context,
  FamilyDashboardController controller,
  FamilyDashboard dashboard, {
  String? memberId,
}) async {
  var selectedMemberId = memberId ?? controller.selectedMemberId;
  var metricType = MetricType.bloodPressure;
  final primaryValue = TextEditingController();
  final secondaryValue = TextEditingController();
  final unit = TextEditingController(text: 'mmHg');
  final contextText = TextEditingController(text: 'Buổi sáng');
  final note = TextEditingController();

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return _ActionSheet(
            title: 'Thêm chỉ số',
            children: [
              _MemberDropdown(
                dashboard: dashboard,
                value: selectedMemberId,
                onChanged: (value) => setState(() => selectedMemberId = value),
              ),
              DropdownButtonFormField<MetricType>(
                initialValue: metricType,
                decoration: const InputDecoration(labelText: 'Loại chỉ số'),
                items: MetricType.values
                    .map(
                      (type) => DropdownMenuItem(
                        value: type,
                        child: Text(_metricLabel(type)),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    metricType = value;
                    unit.text = _defaultUnit(value);
                  });
                },
              ),
              _TextInput(
                controller: primaryValue,
                label: 'Giá trị chính',
                keyboardType: TextInputType.number,
              ),
              _TextInput(
                controller: secondaryValue,
                label: 'Giá trị phụ nếu có',
                keyboardType: TextInputType.number,
              ),
              _TextInput(controller: unit, label: 'Đơn vị'),
              _TextInput(controller: contextText, label: 'Ngữ cảnh đo'),
              _TextInput(controller: note, label: 'Ghi chú'),
              FilledButton.icon(
                onPressed: selectedMemberId.isEmpty
                    ? null
                    : () async {
                        if (primaryValue.text.trim().isEmpty) return;
                        await controller.saveMetric(
                          HealthMetric(
                            id: _id('metric'),
                            memberId: selectedMemberId,
                            type: metricType,
                            primaryValue: primaryValue.text.trim(),
                            secondaryValue: secondaryValue.text.trim().isEmpty
                                ? null
                                : secondaryValue.text.trim(),
                            unit: unit.text.trim(),
                            measuredAt: DateTime.now(),
                            context: contextText.text.trim(),
                            note: note.text.trim(),
                          ),
                        );
                        if (sheetContext.mounted) Navigator.pop(sheetContext);
                        if (context.mounted) _snack(context, 'Đã thêm chỉ số');
                      },
                icon: const Icon(Icons.add_chart_rounded),
                label: const Text('Lưu chỉ số'),
              ),
            ],
          );
        },
      );
    },
  );
}

Future<void> showMedicineForm(
  BuildContext context,
  FamilyDashboardController controller,
  FamilyDashboard dashboard, {
  String? memberId,
}) async {
  var selectedMemberId = memberId ?? controller.selectedMemberId;
  final name = TextEditingController();
  final strength = TextEditingController();
  final dosage = TextEditingController(text: '1 viên / lần');
  final instruction = TextEditingController(text: 'Sau ăn');
  final time = TextEditingController(text: '07:30');

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return _ActionSheet(
            title: 'Thêm thuốc',
            children: [
              _MemberDropdown(
                dashboard: dashboard,
                value: selectedMemberId,
                onChanged: (value) => setState(() => selectedMemberId = value),
              ),
              _TextInput(controller: name, label: 'Tên thuốc'),
              _TextInput(controller: strength, label: 'Hàm lượng'),
              _TextInput(controller: dosage, label: 'Liều lượng'),
              _TextInput(controller: instruction, label: 'Cách dùng'),
              _TextInput(controller: time, label: 'Giờ uống'),
              FilledButton.icon(
                onPressed: selectedMemberId.isEmpty
                    ? null
                    : () async {
                        if (name.text.trim().isEmpty) return;
                        await controller.saveMedicine(
                          Medicine(
                            id: _id('medicine'),
                            memberId: selectedMemberId,
                            name: name.text.trim(),
                            strength: strength.text.trim(),
                            dosage: dosage.text.trim(),
                            instruction: instruction.text.trim(),
                            timeText: time.text.trim(),
                            status: MedicineStatus.active,
                          ),
                        );
                        if (sheetContext.mounted) Navigator.pop(sheetContext);
                        if (context.mounted) _snack(context, 'Đã thêm thuốc');
                      },
                icon: const Icon(Icons.medication_rounded),
                label: const Text('Lưu thuốc'),
              ),
            ],
          );
        },
      );
    },
  );
}

Future<void> showDocumentForm(
  BuildContext context,
  FamilyDashboardController controller,
  FamilyDashboard dashboard, {
  String? memberId,
}) async {
  var selectedMemberId = memberId ?? controller.selectedMemberId;
  var type = 'PDF';
  final title = TextEditingController();
  final hospital = TextEditingController();
  final fileName = TextEditingController();

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return _ActionSheet(
            title: 'Thêm tài liệu',
            children: [
              _MemberDropdown(
                dashboard: dashboard,
                value: selectedMemberId,
                onChanged: (value) => setState(() => selectedMemberId = value),
              ),
              DropdownButtonFormField<String>(
                initialValue: type,
                decoration: const InputDecoration(labelText: 'Loại tài liệu'),
                items: const ['PDF', 'IMG', 'Đơn thuốc', 'Xét nghiệm']
                    .map(
                      (item) =>
                          DropdownMenuItem(value: item, child: Text(item)),
                    )
                    .toList(),
                onChanged: (value) => setState(() => type = value ?? type),
              ),
              _TextInput(controller: title, label: 'Tên tài liệu'),
              _TextInput(controller: hospital, label: 'Cơ sở y tế'),
              _TextInput(controller: fileName, label: 'Tên file/ảnh'),
              FilledButton.icon(
                onPressed: selectedMemberId.isEmpty
                    ? null
                    : () async {
                        if (title.text.trim().isEmpty) return;
                        await controller.saveDocument(
                          HealthDocument(
                            id: _id('document'),
                            memberId: selectedMemberId,
                            title: title.text.trim(),
                            type: type,
                            hospitalName: hospital.text.trim().isEmpty
                                ? 'Chưa nhập'
                                : hospital.text.trim(),
                            documentDate: DateTime.now(),
                            source: DocumentSource.upload,
                            fileName: fileName.text.trim().isEmpty
                                ? null
                                : fileName.text.trim(),
                          ),
                        );
                        if (sheetContext.mounted) Navigator.pop(sheetContext);
                        if (context.mounted) {
                          _snack(context, 'Đã thêm tài liệu');
                        }
                      },
                icon: const Icon(Icons.upload_file_rounded),
                label: const Text('Lưu tài liệu'),
              ),
            ],
          );
        },
      );
    },
  );
}

Future<void> showReminderForm(
  BuildContext context,
  FamilyDashboardController controller,
  FamilyDashboard dashboard, {
  String? memberId,
}) async {
  var selectedMemberId = memberId ?? controller.selectedMemberId;
  var type = ReminderType.medicine;
  final title = TextEditingController();
  final description = TextEditingController();
  final time = TextEditingController(text: '08:00');

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return _ActionSheet(
            title: 'Thêm lịch nhắc',
            children: [
              _MemberDropdown(
                dashboard: dashboard,
                value: selectedMemberId,
                onChanged: (value) => setState(() => selectedMemberId = value),
              ),
              DropdownButtonFormField<ReminderType>(
                initialValue: type,
                decoration: const InputDecoration(labelText: 'Loại nhắc nhở'),
                items: ReminderType.values
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(_reminderLabel(item)),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => type = value ?? type),
              ),
              _TextInput(controller: title, label: 'Tiêu đề'),
              _TextInput(controller: description, label: 'Mô tả'),
              _TextInput(controller: time, label: 'Giờ nhắc'),
              FilledButton.icon(
                onPressed: selectedMemberId.isEmpty
                    ? null
                    : () async {
                        if (title.text.trim().isEmpty) return;
                        await controller.saveReminder(
                          Reminder(
                            id: _id('reminder'),
                            memberId: selectedMemberId,
                            type: type,
                            title: title.text.trim(),
                            description: description.text.trim(),
                            timeText: time.text.trim(),
                            isEnabled: true,
                          ),
                        );
                        if (sheetContext.mounted) Navigator.pop(sheetContext);
                        if (context.mounted) {
                          _snack(context, 'Đã thêm lịch nhắc');
                        }
                      },
                icon: const Icon(Icons.add_alert_rounded),
                label: const Text('Lưu lịch nhắc'),
              ),
            ],
          );
        },
      );
    },
  );
}

Future<void> showSearchSheet(
  BuildContext context,
  FamilyDashboard dashboard,
) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) {
      return _ActionSheet(
        title: 'Tìm kiếm dữ liệu',
        children: [
          TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search_rounded),
              labelText: 'Tên thành viên, thuốc, tài liệu, ghi chú',
            ),
            onChanged: (_) {},
          ),
          const SizedBox(height: 8),
          const FilterPills(
            labels: ['Thành viên', 'Thuốc', 'Chỉ số', 'Tài liệu'],
          ),
          const SectionTitle('Kết quả mẫu'),
          for (final member in dashboard.members.take(3))
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: MemberAvatar(
                label: member.avatarLabel,
                color: memberColor(member.id),
              ),
              title: Text(member.fullName),
              subtitle: Text(member.healthNote),
            ),
        ],
      );
    },
  );
}

void showFeatureSnack(BuildContext context, String label) {
  _snack(context, '$label sẽ được kết nối ở bước dữ liệu thật');
}

Future<void> confirmDeleteMember(
  BuildContext context,
  FamilyDashboardController controller,
  FamilyMember member,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Xóa hồ sơ?'),
      content: Text(
        'Hồ sơ ${member.nickname} và dữ liệu liên quan sẽ được xóa khỏi phiên hiện tại.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Hủy'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Xóa'),
        ),
      ],
    ),
  );
  if (confirmed != true) return;
  await controller.deleteMember(member.id);
  if (context.mounted) _snack(context, 'Đã xóa hồ sơ');
}

class _ActionSheet extends StatelessWidget {
  const _ActionSheet({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 18,
          right: 18,
          top: 14,
          bottom: MediaQuery.viewInsetsOf(context).bottom + 18,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...children.expand(
                (child) => [child, const SizedBox(height: 12)],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TextInput extends StatelessWidget {
  const _TextInput({
    required this.controller,
    required this.label,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: label),
    );
  }
}

class _MemberDropdown extends StatelessWidget {
  const _MemberDropdown({
    required this.dashboard,
    required this.value,
    required this.onChanged,
  });

  final FamilyDashboard dashboard;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: dashboard.members.any((member) => member.id == value)
          ? value
          : null,
      decoration: const InputDecoration(labelText: 'Thành viên'),
      items: dashboard.members
          .map(
            (member) => DropdownMenuItem(
              value: member.id,
              child: Text(member.nickname),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}

String _id(String prefix) {
  return '$prefix-${DateTime.now().microsecondsSinceEpoch}';
}

String _avatarLabel(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return 'VH';
  return trimmed.characters.first.toUpperCase();
}

String _metricLabel(MetricType type) {
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

String _defaultUnit(MetricType type) {
  return switch (type) {
    MetricType.bloodPressure => 'mmHg',
    MetricType.bloodSugar => 'mg/dL',
    MetricType.weight => 'kg',
    MetricType.height => 'cm',
    MetricType.temperature => '°C',
    MetricType.heartRate => 'bpm',
    MetricType.spo2 => '%',
  };
}

String _reminderLabel(ReminderType type) {
  return switch (type) {
    ReminderType.medicine => 'Uống thuốc',
    ReminderType.metric => 'Đo chỉ số',
    ReminderType.appointment => 'Tái khám',
    ReminderType.vaccine => 'Tiêm phòng',
    ReminderType.buyMedicine => 'Mua thuốc',
  };
}

void _snack(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
