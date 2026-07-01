import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../widgets/vihealth_ui.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({required this.onStart, super.key});

  final VoidCallback onStart;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool _acceptedMedicalNotice = false;
  bool _showFeatureIntro = false;

  @override
  Widget build(BuildContext context) {
    if (_showFeatureIntro) {
      return _FeatureIntroScreen(onStart: widget.onStart);
    }

    return _MedicalNoticeScreen(
      accepted: _acceptedMedicalNotice,
      onAcceptedChanged: (value) {
        setState(() => _acceptedMedicalNotice = value);
      },
      onContinue: _acceptedMedicalNotice
          ? () => setState(() => _showFeatureIntro = true)
          : null,
    );
  }
}

class _MedicalNoticeScreen extends StatelessWidget {
  const _MedicalNoticeScreen({
    required this.accepted,
    required this.onAcceptedChanged,
    required this.onContinue,
  });

  final bool accepted;
  final ValueChanged<bool> onAcceptedChanged;
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sổ Sức Khỏe',
                style: textTheme.headlineLarge?.copyWith(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Spacer(flex: 2),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 82,
                      height: 82,
                      decoration: BoxDecoration(
                        color: AppColors.primarySoft,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.18),
                        ),
                      ),
                      child: const Icon(
                        Icons.assignment_rounded,
                        color: AppColors.primary,
                        size: 44,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Sổ sức khỏe cho cả gia đình',
                      textAlign: TextAlign.center,
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Lưu thông tin sức khỏe, chỉ số, thuốc, lịch khám và tài liệu y tế trong một nơi.',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.muted,
                        fontSize: 16,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 3),
              AppCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const IconBubble(
                          icon: Icons.medical_information_rounded,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Lưu ý y tế',
                          style: textTheme.titleMedium?.copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Ứng dụng chỉ dùng để ghi chép và theo dõi thông tin sức khỏe cá nhân. Ứng dụng không cung cấp chẩn đoán, điều trị hoặc tư vấn y tế và không thay thế ý kiến của bác sĩ.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.muted,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Tôi hiểu và đồng ý',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Switch(value: accepted, onChanged: onAcceptedChanged),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(onPressed: onContinue, child: const Text('Bắt đầu')),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureIntroScreen extends StatelessWidget {
  const _FeatureIntroScreen({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 28),
          children: [
            Row(
              children: [
                const IconBubble(
                  icon: Icons.health_and_safety_rounded,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 10),
                Text(
                  'ViHealth',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 26),
            AppCard(
              padding: const EdgeInsets.all(22),
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.family_restroom_rounded,
                    color: Colors.white,
                    size: 54,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Sổ Sức Khỏe Gia Đình',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Lưu hồ sơ, chỉ số, thuốc, lịch nhắc và tài liệu y tế của cả nhà ở một nơi dễ nhìn.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.86),
                      height: 1.45,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const _OnboardingItem(
              icon: Icons.folder_shared_rounded,
              title: 'Quản lý hồ sơ gia đình',
              subtitle:
                  'Theo dõi bố mẹ, con cái và chính bạn bằng dữ liệu mẫu.',
            ),
            const _OnboardingItem(
              icon: Icons.notifications_active_rounded,
              title: 'Nhắc lịch chăm sóc',
              subtitle: 'Thuốc, đo chỉ số, tiêm chủng và lịch tái khám.',
            ),
            const _OnboardingItem(
              icon: Icons.description_rounded,
              title: 'Lưu tài liệu y tế',
              subtitle: 'Đơn thuốc, xét nghiệm, PDF và ảnh chụp được gom gọn.',
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onStart,
              icon: const Icon(Icons.arrow_forward_rounded),
              label: const Text('Vào ứng dụng'),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingItem extends StatelessWidget {
  const _OnboardingItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        child: Row(
          children: [
            IconBubble(icon: icon, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 3),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
