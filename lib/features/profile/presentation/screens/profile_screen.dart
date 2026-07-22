import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:no_wait/core/animations/animations.dart';
import 'package:no_wait/core/helpers/spacing.dart';
import 'package:no_wait/core/theme/controller/theme_cubit.dart';
import 'package:no_wait/core/theme/controller/theme_state.dart';
import 'package:no_wait/core/utils/app_text_styles.dart';
import 'package:no_wait/features/profile/presentation/widgets/language_selector_row.dart';
import 'package:no_wait/features/profile/presentation/widgets/settings_nav_row.dart';
import 'package:no_wait/features/profile/presentation/widgets/settings_section_header.dart';
import 'package:no_wait/features/profile/presentation/widgets/settings_toggle_row.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Not wired to a real biometrics / push-notification backend yet —
  // purely visual state until those systems exist.
  bool _biometricEnabled = false;
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text('profile.appbar_title'.tr())),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsetsDirectional.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SettingsSectionHeader(
                title: 'profile.account_settings.title'.tr(),
              ).fadeInSlideUp(),
              verticalSpace(12),
              _SettingsCard(
                children: [
                  SettingsNavRow(
                    title: 'profile.account_settings.password.title'.tr(),
                    subtitle: '••••••••',
                    onTap: () {},
                  ),
                  const _RowDivider(),
                  SettingsToggleRow(
                    title: 'profile.account_settings.biometric.title'.tr(),
                    description:
                        'profile.account_settings.biometric.description'.tr(),
                    value: _biometricEnabled,
                    onChanged: (value) =>
                        setState(() => _biometricEnabled = value),
                  ),
                ],
              ).fadeInSlideUp(delay: AppAnimations.sectionDelay),
              verticalSpace(24),
              SettingsSectionHeader(
                title: 'profile.preferences.title'.tr(),
              ).fadeInSlideUp(delay: AppAnimations.sectionDelay * 2),
              verticalSpace(12),
              _SettingsCard(
                children: [
                  SettingsToggleRow(
                    title: 'profile.preferences.notifications.title'.tr(),
                    description:
                        'profile.preferences.notifications.description'.tr(),
                    value: _notificationsEnabled,
                    onChanged: (value) =>
                        setState(() => _notificationsEnabled = value),
                  ),
                  const _RowDivider(),
                  BlocBuilder<ThemeCubit, ThemeState>(
                    builder: (context, themeState) {
                      return SettingsToggleRow(
                        title: 'profile.preferences.dark_mode.title'.tr(),
                        description:
                            'profile.preferences.dark_mode.description'.tr(),
                        value: themeState.themeMode == ThemeMode.dark,
                        onChanged: (value) =>
                            context.read<ThemeCubit>().setThemeMode(
                              value ? ThemeMode.dark : ThemeMode.system,
                            ),
                      );
                    },
                  ),
                ],
              ).fadeInSlideUp(delay: AppAnimations.sectionDelay * 3),
              verticalSpace(20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'profile.preferences.language.title'.tr(),
                    style: AppTextStyles.font14SemiBold.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  verticalSpace(10),
                  const LanguageSelectorRow(),
                ],
              ).fadeInSlideUp(delay: AppAnimations.sectionDelay * 4),
              verticalSpace(24),
              SettingsSectionHeader(
                title: 'profile.cache.title'.tr(),
              ).fadeInSlideUp(delay: AppAnimations.sectionDelay * 5),
              verticalSpace(12),
              _SettingsCard(
                children: [
                  SettingsNavRow(
                    title: 'profile.cache.clear.title'.tr(),
                    subtitle: 'profile.cache.clear.description'.tr(),
                    onTap: () {},
                  ),
                ],
              ).fadeInSlideUp(delay: AppAnimations.sectionDelay * 6),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 14.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(children: children),
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.4),
    );
  }
}
