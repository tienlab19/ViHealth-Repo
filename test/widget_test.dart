import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vihealth/features/family/data/repositories/mock_family_health_repository.dart';
import 'package:vihealth/features/family/domain/usecases/get_family_dashboard.dart';
import 'package:vihealth/features/family/presentation/controllers/family_dashboard_controller.dart';
import 'package:vihealth/main.dart';

void main() {
  testWidgets('renders ViHealth handoff mock UI and main tabs', (tester) async {
    final repository = MockFamilyHealthRepository();
    final controller = FamilyDashboardController(
      getFamilyDashboard: GetFamilyDashboard(repository),
      repository: repository,
    )..load();

    await tester.pumpWidget(ViHealthApp(dashboardController: controller));
    await tester.pumpAndSettle();

    expect(find.text('Sổ Sức Khỏe'), findsOneWidget);
    expect(find.text('Lưu ý y tế'), findsOneWidget);
    expect(find.text('Sổ Sức Khỏe Gia Đình'), findsNothing);

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bắt đầu'));
    await tester.pumpAndSettle();

    expect(find.text('Sổ Sức Khỏe Gia Đình'), findsOneWidget);

    await tester.drag(find.byType(Scrollable).first, const Offset(0, -260));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Vào ứng dụng'));
    await tester.pumpAndSettle();

    expect(find.text('Chào bạn'), findsOneWidget);
    expect(find.text('Gia đình của bạn'), findsOneWidget);

    await tester.tap(find.text('Thành viên').last);
    await tester.pumpAndSettle();

    expect(find.text('Hồ sơ gia đình'), findsOneWidget);
    expect(find.text('Danh sách thành viên'), findsOneWidget);

    await tester.tap(find.text('Lịch nhắc').last);
    await tester.pumpAndSettle();

    expect(find.text('Lịch sức khỏe'), findsOneWidget);
    expect(find.text('Hôm nay'), findsOneWidget);
  });
}
