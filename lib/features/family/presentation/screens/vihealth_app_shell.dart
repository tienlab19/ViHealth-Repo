import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/family_dashboard.dart';
import '../controllers/family_dashboard_controller.dart';
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
      SettingsScreen(dashboard: dashboard, controller: controller),
    ];

    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.background,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8FBFD), Color(0xFFEAF6F2), Color(0xFFF5F8FB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: IndexedStack(
            index: controller.selectedIndex.clamp(0, screens.length - 1),
            children: screens,
          ),
        ),
      ),
      bottomNavigationBar: _LiquidGlassTabBar(
        selectedIndex: controller.selectedIndex.clamp(0, screens.length - 1),
        onSelected: controller.selectTab,
      ),
    );
  }
}

class _LiquidGlassTabBar extends StatelessWidget {
  const _LiquidGlassTabBar({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const _items = [
    _TabBarItem(Icons.home_rounded, 'Trang chủ'),
    _TabBarItem(Icons.groups_rounded, 'Thành viên'),
    _TabBarItem(Icons.notifications_active_rounded, 'Lịch nhắc'),
    _TabBarItem(Icons.settings_rounded, 'Cài đặt'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(18, 0, 18, 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(36),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            height: 82,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(36),
              border: Border.all(color: Colors.white.withValues(alpha: 0.82)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 34,
                  offset: const Offset(0, 18),
                ),
              ],
            ),
            child: Row(
              children: [
                for (var index = 0; index < _items.length; index++)
                  Expanded(
                    child: _LiquidGlassTab(
                      item: _items[index],
                      selected: index == selectedIndex,
                      onTap: () => onSelected(index),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LiquidGlassTab extends StatelessWidget {
  const _LiquidGlassTab({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _TabBarItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.secondary : AppColors.text;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              color: selected
                  ? const Color(0xFFE8EAF0).withValues(alpha: 0.86)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: selected
                    ? Colors.white.withValues(alpha: 0.72)
                    : Colors.transparent,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: color, size: 28),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    item.label,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: color,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TabBarItem {
  const _TabBarItem(this.icon, this.label);

  final IconData icon;
  final String label;
}
