import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/status_pill.dart';
import '../../domain/entities/family_dashboard.dart';
import '../../domain/entities/health_document.dart';
import '../controllers/family_dashboard_controller.dart';
import '../widgets/family_actions.dart';
import '../widgets/vihealth_ui.dart';

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({
    required this.dashboard,
    required this.controller,
    super.key,
  });

  final FamilyDashboard dashboard;
  final FamilyDashboardController controller;

  @override
  Widget build(BuildContext context) {
    return ViHealthPage(
      title: 'Tài liệu y tế',
      subtitle:
          '${dashboard.documents.length} tài liệu gồm đơn thuốc, xét nghiệm, ảnh chụp và PDF.',
      trailing: IconButton.filledTonal(
        onPressed: () => showDocumentForm(context, controller, dashboard),
        icon: const Icon(Icons.upload_file_rounded),
      ),
      children: [
        const FilterPills(labels: ['Tất cả', 'PDF', 'Ảnh', 'Đơn thuốc']),
        const SectionTitle('Tất cả tài liệu'),
        if (dashboard.documents.isEmpty)
          const EmptyState(text: 'Chưa có tài liệu y tế nào.')
        else
          for (final document in dashboard.documents)
            _DocumentCard(
              document: document,
              memberName: dashboard.memberById(document.memberId).nickname,
              onDelete: () => controller.deleteDocument(document.id),
            ),
      ],
    );
  }
}

class _DocumentCard extends StatelessWidget {
  const _DocumentCard({
    required this.document,
    required this.memberName,
    required this.onDelete,
  });

  final HealthDocument document;
  final String memberName;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isPdf = document.type.toUpperCase() == 'PDF';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        child: Row(
          children: [
            IconBubble(
              icon: isPdf ? Icons.picture_as_pdf_rounded : Icons.image_rounded,
              color: isPdf ? AppColors.danger : AppColors.secondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    document.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '$memberName - ${document.hospitalName}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            StatusPill(
              document.type,
              tone: isPdf ? PillTone.red : PillTone.blue,
            ),
            IconButton(
              tooltip: 'Xóa tài liệu',
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
