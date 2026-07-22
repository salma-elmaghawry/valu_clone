import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:no_wait/core/animations/animations.dart';
import 'package:no_wait/core/theme/app_colors.dart';
import 'package:no_wait/core/utils/app_assets.dart';
import 'package:no_wait/core/utils/app_text_styles.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Image.asset(AppAssets.logo, height: 26.h),
        const Spacer(),
        AnimatedTap(
          onTap: () {},
          child: Container(
            height: 28.h,
            padding: EdgeInsetsDirectional.symmetric(horizontal: 14.w),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              'home.header.consumer_loans'.tr(),
              style: AppTextStyles.font12SemiBold.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.backgroundDark,
              ),
            ),
          ),
        ),
        SizedBox(width: 16.w),
        AnimatedTap(
          onTap: () {},
          child: SvgPicture.asset(
            AppAssets.notification,
            height: 22.r,
            colorFilter: ColorFilter.mode(
              colorScheme.onSurface,
              BlendMode.srcIn,
            ),
          ),
        ),
      ],
    );
  }
}
