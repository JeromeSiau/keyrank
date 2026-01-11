import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/keyrank_logo.dart';
import '../providers/onboarding_provider.dart';
import '../../integrations/providers/integrations_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _currentStep = 0;

  Future<void> _complete() async {
    await ref.read(onboardingStatusProvider.notifier).complete();
    if (mounted) {
      context.go('/dashboard');
    }
  }

  Future<void> _skip() async {
    await ref.read(onboardingStatusProvider.notifier).skip();
    if (mounted) {
      context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? AppColors.accent : AppColorsLight.accent;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgBase : AppColorsLight.bgBase,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              // Header with logo
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const KeyrankLogoIcon(size: 32),
                      const SizedBox(width: 12),
                      Text(
                        'keyrank',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColorsLight.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: _skip,
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.textMuted
                            : AppColorsLight.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Progress dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  final isActive = index <= _currentStep;
                  return Container(
                    width: index == _currentStep ? 24 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isActive
                          ? accent
                          : (isDark
                              ? AppColors.glassBorder
                              : AppColorsLight.glassBorder),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 48),

              // Content
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _buildStep(isDark, accent),
                ),
              ),

              // Navigation
              const SizedBox(height: 24),
              _buildNavigation(isDark, accent),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep(bool isDark, Color accent) {
    switch (_currentStep) {
      case 0:
        return _WelcomeStep(key: const ValueKey(0), isDark: isDark, accent: accent);
      case 1:
        return _ConnectStep(key: const ValueKey(1), isDark: isDark, accent: accent);
      case 2:
        return _DoneStep(key: const ValueKey(2), isDark: isDark);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildNavigation(bool isDark, Color accent) {
    return Row(
      children: [
        if (_currentStep > 0)
          Expanded(
            child: OutlinedButton(
              onPressed: () => setState(() => _currentStep--),
              style: OutlinedButton.styleFrom(
                foregroundColor: isDark
                    ? AppColors.textSecondary
                    : AppColorsLight.textSecondary,
                side: BorderSide(
                  color: isDark
                      ? AppColors.glassBorder
                      : AppColorsLight.glassBorder,
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Back'),
            ),
          )
        else
          const Spacer(),
        const SizedBox(width: 16),
        Expanded(
          child: FilledButton(
            onPressed: _currentStep == 2
                ? _complete
                : () => setState(() => _currentStep++),
            style: FilledButton.styleFrom(
              backgroundColor: accent,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(_currentStep == 2 ? 'Get Started' : 'Continue'),
          ),
        ),
      ],
    );
  }
}

class _WelcomeStep extends StatelessWidget {
  final bool isDark;
  final Color accent;

  const _WelcomeStep({super.key, required this.isDark, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: accent.withAlpha(25),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(Icons.rocket_launch_outlined, size: 40, color: accent),
        ),
        const SizedBox(height: 32),
        Text(
          'Welcome to Keyrank',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Track your app rankings, manage reviews, and optimize your ASO strategy.',
          style: TextStyle(
            fontSize: 15,
            color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ConnectStep extends ConsumerWidget {
  final bool isDark;
  final Color accent;

  const _ConnectStep({super.key, required this.isDark, required this.accent});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final integrationsAsync = ref.watch(integrationsProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: accent.withAlpha(25),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(Icons.link, size: 40, color: accent),
        ),
        const SizedBox(height: 32),
        Text(
          'Connect Your Store',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Optional: Connect to import apps and reply to reviews.',
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        integrationsAsync.when(
          loading: () => const CircularProgressIndicator(),
          error: (_, _) => Text(
            'Could not load integrations',
            style: TextStyle(
              color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
            ),
          ),
          data: (integrations) {
            final hasIos =
                integrations.any((i) => i.type == 'app_store_connect');
            final hasAndroid =
                integrations.any((i) => i.type == 'google_play_console');

            return Column(
              children: [
                _StoreCard(
                  isDark: isDark,
                  icon: Icons.apple,
                  title: 'App Store Connect',
                  subtitle: hasIos ? 'Connected' : 'Tap to connect',
                  isConnected: hasIos,
                  onTap: hasIos
                      ? null
                      : () => context.push('/onboarding/connect/app-store'),
                ),
                const SizedBox(height: 12),
                _StoreCard(
                  isDark: isDark,
                  icon: Icons.android,
                  title: 'Google Play Console',
                  subtitle: hasAndroid ? 'Connected' : 'Tap to connect',
                  isConnected: hasAndroid,
                  onTap: hasAndroid
                      ? null
                      : () => context.push('/onboarding/connect/google-play'),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _StoreCard extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isConnected;
  final VoidCallback? onTap;

  const _StoreCard({
    required this.isDark,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isConnected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final green = isDark ? AppColors.green : AppColorsLight.green;
    final accent = isDark ? AppColors.accent : AppColorsLight.accent;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color:
                isDark ? AppColors.glassPanelAlpha : AppColorsLight.glassPanelAlpha,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isConnected
                  ? green.withAlpha(100)
                  : (isDark ? AppColors.glassBorder : AppColorsLight.glassBorder),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: (isConnected ? green : accent).withAlpha(20),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 24, color: isConnected ? green : accent),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColorsLight.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: isConnected
                            ? green
                            : (isDark
                                ? AppColors.textMuted
                                : AppColorsLight.textMuted),
                      ),
                    ),
                  ],
                ),
              ),
              if (isConnected)
                Icon(Icons.check_circle, size: 20, color: green)
              else
                Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DoneStep extends StatelessWidget {
  final bool isDark;

  const _DoneStep({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final green = isDark ? AppColors.green : AppColorsLight.green;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: green.withAlpha(25),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.check, size: 40, color: green),
        ),
        const SizedBox(height: 32),
        Text(
          "You're All Set!",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Start by adding an app to track, or explore the keyword inspector.',
          style: TextStyle(
            fontSize: 15,
            color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
