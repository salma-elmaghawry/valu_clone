import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:no_wait/core/animations/animations.dart';
import 'package:no_wait/core/helpers/spacing.dart';
import 'package:no_wait/core/injection/injection_container.dart';
import 'package:no_wait/core/theme/app_colors.dart';
import 'package:no_wait/core/utils/app_text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSelectorRow extends StatelessWidget {
  const LanguageSelectorRow({super.key});

  @override
  Widget build(BuildContext context) {
    final isEnglish = context.locale.languageCode == 'en';

    return Row(
      children: [
        Expanded(
          child: _LanguageOption(
            label: 'profile.preferences.language.english'.tr(),
            isSelected: isEnglish,
            onTap: () => _setLocale(context, const Locale('en')),
          ),
        ),
        horizontalSpace(10),
        Expanded(
          child: _LanguageOption(
            label: 'profile.preferences.language.arabic'.tr(),
            isSelected: !isEnglish,
            onTap: () => _setLocale(context, const Locale('ar')),
          ),
        ),
      ],
    );
  }

  Future<void> _setLocale(BuildContext context, Locale locale) async {
    await context.setLocale(locale);
    await getIt<SharedPreferences>().setString('app_locale', locale.languageCode);
  }
}

class _LanguageOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedTap(
      onTap: onTap,
      child: Container(
        height: 36.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.secondary.withValues(alpha: 0.15)
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(10.r),
          border: isSelected
              ? Border.all(color: AppColors.secondary, width: 1.5)
              : null,
        ),
        child: Text(
          label,
          style: AppTextStyles.font14SemiBold.copyWith(
            fontWeight: FontWeight.w700,
            color: isSelected ? AppColors.secondary : colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
