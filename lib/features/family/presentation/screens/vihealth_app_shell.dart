import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/family_dashboard.dart';
import '../controllers/family_dashboard_controller.dart';
import 'documents_screen.dart';
import 'health_calendar_screen.dart';
import 'home_screen.dart';
import 'onboarding_screen.dart';
import 'profiles_screen.dart';
import 'settings_screen.dart';

class ViHealthAppShell extends StatefulWidget {
  const ViHealthAppShell({required this.controller, super.key});

  final FamilyDashboardController controller;

  @override
  State<ViHealthAppShell> createState() => _ViHealthAppShellState();
}

class _ViHealthAppShellState extends State<ViHealthAppShell> {
  bool _showOnboarding = true;

  @override
  Widget build(BuildContext context) {
    if (_showOnboarding) {
      return OnboardingScreen(
        onStart: () => setState(() => _showOnboarding = false),
      );
    }

    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final dashboard = widget.controller.dashboard;
        if (widget.controller.isLoading || dashboard == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return _ShellScaffold(
          dashboard: dashboard,
          controller: widget.controller,
        );
      },
    );
  }
}

class _ShellScaffold extends StatelessWidget {
  const _ShellScaffold({required this.dashboard, required this.controller});

  final FamilyDashboard dashboard;
  final FamilyDashboardController controller;

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(dashboard: dashboard, controller: controller),
      ProfilesScreen(dashboard: dashboard, controller: controller),
      HealthCalendarScreen(dashboard: dashboard, controller: controller),
      DocumentsScreen(dashboard: dashboard, controller: controller),
      SettingsScreen(dashboard: dashboard, controller: controller),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: controller.selectedIndex.clamp(0, screens.length - 1),
          children: screens,
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(12, 0, 12, 10),
        child: Container(
          height: 66,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.96),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.line),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 26,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: NavigationBar(
              selectedIndex: controller.selectedIndex,
              onDestinationSelected: controller.selectTab,
              height: 64,
              backgroundColor: Colors.transparent,
              indicatorColor: Colors.transparent,
              elevation: 0,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded),
                  label: 'Trang chủ',
                ),
                NavigationDestination(
                  icon: Icon(Icons.favorite_border_rounded),
                  selectedIcon: Icon(Icons.favorite_rounded),
                  label: 'Hồ sơ',
                ),
                NavigationDestination(
                  icon: Icon(Icons.calendar_month_outlined),
                  selectedIcon: Icon(Icons.calendar_month_rounded),
                  label: 'Lịch',
                ),
                NavigationDestination(
                  icon: Icon(Icons.description_outlined),
                  selectedIcon: Icon(Icons.description_rounded),
                  label: 'Tài liệu',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings_rounded),
                  label: 'Cài đặt',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
