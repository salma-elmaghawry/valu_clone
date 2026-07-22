import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:no_wait/core/helpers/app_validators.dart';
import 'package:no_wait/core/helpers/spacing.dart';
import 'package:no_wait/core/theme/app_colors.dart';
import 'package:no_wait/core/utils/app_text_styles.dart';

/// Live-validated password policy checklist shown under the "create
/// password" fields, each rule turning green as it's satisfied.
class PasswordPolicyChecklist extends StatelessWidget {
  final String password;

  const PasswordPolicyChecklist({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final rules = <bool>[
      AppValidators.hasValidPasswordLength(password),
      AppValidators.hasMixedCaseAndDigit(password),
      AppValidators.hasNoCharacterRepeatedMoreThan3Times(password),
      AppValidators.hasPasswordSpecialCharacter(password),
    ];
    final labels = [
      'auth.create_password.policy_length'.tr(),
      'auth.create_password.policy_case_digit'.tr(),
      'auth.create_password.policy_repeat'.tr(),
      'auth.create_password.policy_special'.tr(),
    ];

    // Before the user has typed anything there's nothing to grade yet, so
    // rules stay neutral instead of showing a misleading pass/fail against
    // an empty string (e.g. "no repeated characters" is vacuously true).
    final isUntouched = password.isEmpty;
    final neutralColor = colorScheme.onSurfaceVariant;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'auth.create_password.policy_title'.tr(),
          style: AppTextStyles.font14SemiBold.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        verticalSpace(8),
        for (var i = 0; i < rules.length; i++) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                isUntouched
                    ? Icons.circle_outlined
                    : (rules[i] ? Icons.check_circle : Icons.cancel),
                size: 16.r,
                color: isUntouched
                    ? neutralColor
                    : (rules[i] ? AppColors.success : colorScheme.error),
              ),
              horizontalSpace(8),
              Expanded(
                child: Text(
                  labels[i],
                  style: AppTextStyles.font12SemiBold.copyWith(
                    color: isUntouched
                        ? neutralColor
                        : (rules[i] ? AppColors.success : colorScheme.error),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          if (i != rules.length - 1) verticalSpace(6),
        ],
      ],
    );
  }
}
