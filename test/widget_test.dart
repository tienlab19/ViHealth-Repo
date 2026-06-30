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

    expect(find.text('Chào bạn'), findsOneWidget);
    expect(find.text('Gia đình của bạn'), findsOneWidget);
    expect(find.text('Bố'), findsOneWidget);

    await tester.tap(find.text('Hồ sơ'));
    await tester.pumpAndSettle();

    expect(find.text('Hồ sơ gia đình'), findsOneWidget);
    expect(find.text('Danh sách thành viên'), findsOneWidget);

    await tester.tap(find.text('Lịch'));
    await tester.pumpAndSettle();

    expect(find.text('Lịch sức khỏe'), findsOneWidget);
    expect(find.text('Hôm nay, 30/06'), findsOneWidget);
  });
}
