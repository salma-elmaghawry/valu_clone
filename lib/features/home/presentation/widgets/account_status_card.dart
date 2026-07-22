import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:no_wait/core/animations/animations.dart';
import 'package:no_wait/core/helpers/spacing.dart';
import 'package:no_wait/core/theme/app_colors.dart';
import 'package:no_wait/core/utils/app_assets.dart';
import 'package:no_wait/core/utils/app_text_styles.dart';
import 'package:no_wait/features/home/domain/entities/account_limit_status.dart';

/// Shows the account status banner that needs the user's attention.
/// Renders nothing once the account is fully active — swapping [status]
/// for a value driven by the real API changes what's shown here with no
/// other code changes.
class AccountStatusCard extends StatelessWidget {
  final AccountLimitStatus status;

  const AccountStatusCard({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case AccountLimitStatus.blocked:
        return const _LimitBlockedCard();
      case AccountLimitStatus.pendingActivation:
        return const _RegistrationProgressCard();
      case AccountLimitStatus.active:
        return const SizedBox.shrink();
    }
  }
}

class _LimitBlockedCard extends StatelessWidget {
  const _LimitBlockedCard();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsetsDirectional.all(14.w),
      decoration: BoxDecoration(
        color: colorScheme.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error, color: colorScheme.error, size: 22.r),
          horizontalSpace(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'home.limit_blocked.title'.tr(),
                  style: AppTextStyles.font14SemiBold.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                verticalSpace(2),
                Text(
                  'home.limit_blocked.subtitle'.tr(),
                  style: AppTextStyles.font12SemiBold.copyWith(
                    fontWeight: FontWeight.normal,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          horizontalSpace(8),
          AnimatedTap(
            onTap: () {},
            child: Container(
              height: 30.h,
              padding: EdgeInsetsDirectional.symmetric(horizontal: 14.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colorScheme.error,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                'home.limit_blocked.button'.tr(),
                style: AppTextStyles.font12SemiBold.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RegistrationProgressCard extends StatelessWidget {
  const _RegistrationProgressCard();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsetsDirectional.only(start: 16.w, end: 16.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const _StepDot(isActive: true),
                    horizontalSpace(10),
                    Expanded(
                      child: Text(
                        'home.registration.online'.tr(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.font16Normal.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 8.w),
                  child: Container(
                    width: 1.5.w,
                    height: 22.h,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  ),
                ),
                Row(
                  children: [
                    const _StepDot(isActive: false),
                    horizontalSpace(10),
                    Expanded(
                      child: Text(
                        'home.registration.activate'.tr(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.font14Normal.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
                verticalSpace(18),
                AnimatedTap(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    height: 30.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.darkTeal,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      'home.registration.continue_btn'.tr(),
                      style: AppTextStyles.font14SemiBold.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          horizontalSpace(8),
          Padding(
            padding: EdgeInsets.only(top: 30.r),
            child: SizedBox(
              width: 120.w,
              height: 130.h,
              child: Image.asset(
                AppAssets.carLoanAnnouncementDark,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  final bool isActive;

  const _StepDot({required this.isActive});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (!isActive) {
      return Container(
        width: 16.r,
        height: 16.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            width: 1.5,
          ),
        ),
      );
    }

    return Container(
      width: 16.r,
      height: 16.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.secondary, width: 1.5),
      ),
      child: Container(
        width: 8.r,
        height: 8.r,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.secondary,
        ),
      ),
    );
  }
}
