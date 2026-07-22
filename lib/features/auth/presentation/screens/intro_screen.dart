import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:no_wait/core/animations/animations.dart';
import 'package:no_wait/core/helpers/extensions.dart';
import 'package:no_wait/core/helpers/spacing.dart';
import 'package:no_wait/core/routes/routes.dart';
import 'package:no_wait/core/theme/app_colors.dart';
import 'package:no_wait/core/utils/app_assets.dart';
import 'package:no_wait/core/utils/app_text_styles.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadiusDirectional.only(
                  bottomStart: Radius.circular(32.r),
                  bottomEnd: Radius.circular(32.r),
                ),
              ),
              child: Center(
                child: Image.asset(
                  AppAssets.logo,
                  width: 190.w,
                ).pulse().shimmer().fadeInScale(duration: AppAnimations.slow),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(24.w, 28.h, 24.w, 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: AnimationBuilder.staggerColumn(
                staggerDelay: AppAnimations.sectionDelay,
                children: [
                  Text(
                    'auth.intro.title'.tr(),
                    style: AppTextStyles.font24Bold.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  verticalSpace(8),
                  Text(
                    'auth.intro.subtitle'.tr(),
                    style: AppTextStyles.font14Normal.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  verticalSpace(24),
                  AnimatedButton(
                    height: 52.h,
                    backgroundColor: colorScheme.primary,
                    borderRadius: BorderRadius.circular(16.r),
                    onPressed: () => context.pushNamed(Routes.login),
                    child: Center(
                      child: Text(
                        'auth.intro.login_btn'.tr(),
                        style: AppTextStyles.font16Normal.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  verticalSpace(12),
                  AnimatedTap(
                    onTap: () => context.pushNamed(Routes.signUp),
                    child: Container(
                      height: 52.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: colorScheme.primary,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'auth.intro.register_btn'.tr(),
                          style: AppTextStyles.font16Normal.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
