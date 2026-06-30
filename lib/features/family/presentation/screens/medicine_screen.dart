import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/status_pill.dart';
import '../../domain/entities/family_dashboard.dart';
import '../../domain/entities/family_member.dart';
import '../../domain/entities/medicine.dart';
import '../controllers/family_dashboard_controller.dart';
import '../widgets/family_actions.dart';
import '../widgets/vihealth_ui.dart';

class MedicineScreen extends StatelessWidget {
  const MedicineScreen({
    required this.member,
    required this.medicines,
    this.controller,
    this.dashboard,
    super.key,
  });

  final FamilyMember member;
  final List<Medicine> medicines;
  final FamilyDashboardController? controller;
  final FamilyDashboard? dashboard;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thuốc đang dùng')),
      body: ViHealthPage(
        title: 'Thuốc của ${member.nickname}',
        subtitle: 'Liều dùng, hướng dẫn uống thuốc và lịch nhắc trong ngày.',
        trailing: IconButton.filledTonal(
          onPressed: controller == null || dashboard == null
              ? null
              : () => showMedicineForm(
                  context,
                  controller!,
                  dashboard!,
                  memberId: member.id,
                ),
          icon: const Icon(Icons.add_rounded),
        ),
        children: [
          const FilterPills(labels: ['Đang dùng', 'Sáng', 'Tối', 'Đã dừng']),
          const SectionTitle('Danh sách thuốc'),
          if (medicines.isEmpty)
            const EmptyState(text: 'Chưa có thuốc đang dùng cho hồ sơ này.')
          else
            for (final medicine in medicines)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AppCard(
                  child: Row(
                    children: [
                      const IconBubble(
                        icon: Icons.medication_rounded,
                        color: AppColors.warning,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${medicine.name} ${medicine.strength}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${medicine.dosage} - ${medicine.instruction}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      StatusPill(
                        medicine.timeText,
                        tone: medicine.status == MedicineStatus.active
                            ? PillTone.orange
                            : PillTone.red,
                      ),
                      if (controller != null)
                        IconButton(
                          tooltip: 'Xóa thuốc',
                          onPressed: () =>
                              controller!.deleteMedicine(medicine.id),
                          icon: const Icon(Icons.delete_outline_rounded),
                        ),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
