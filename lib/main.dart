import 'package:flutter/material.dart';

import 'core/services/local_notification_service.dart';
import 'core/theme/app_theme.dart';
import 'features/family/data/repositories/mock_family_health_repository.dart';
import 'features/family/domain/usecases/get_family_dashboard.dart';
import 'features/family/presentation/controllers/family_dashboard_controller.dart';
import 'features/family/presentation/screens/vihealth_app_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final notificationService = LocalNotificationService();
  await notificationService.initialize();

  final repository = MockFamilyHealthRepository();
  final dashboardController = FamilyDashboardController(
    getFamilyDashboard: GetFamilyDashboard(repository),
    repository: repository,
    notificationService: notificationService,
  )..load();

  runApp(ViHealthApp(dashboardController: dashboardController));
}

class ViHealthApp extends StatelessWidget {
  const ViHealthApp({required this.dashboardController, super.key});

  final FamilyDashboardController dashboardController;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ViHealth',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: ViHealthAppShell(controller: dashboardController),
    );
  }
}
