import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:no_wait/core/animations/animations.dart';
import 'package:no_wait/core/helpers/spacing.dart';
import 'package:no_wait/core/theme/app_colors.dart';
import 'package:no_wait/core/utils/app_assets.dart';
import 'package:no_wait/core/utils/app_text_styles.dart';

class BnplSection extends StatelessWidget {
  const BnplSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsetsDirectional.only(
        start: 16.w,
        top: 10.h,
        bottom: 10.h,
        end: 8.w,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                AppAssets.logoMark,
                width: 30.w,
                color: AppColors.primary,
              ),
              horizontalSpace(8),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    'home.bnpl.title'.tr(),
                    maxLines: 1,
                    style: AppTextStyles.font16Normal.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
              horizontalSpace(15),
              AnimatedTap(
                onTap: () {},
                child: Container(
                  height: 30.h,
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'home.bnpl.view_stores'.tr(),
                    style: AppTextStyles.font14SemiBold.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          verticalSpace(16),
          TextField(
            readOnly: true,
            // ScreenUtil reports 0 on the first zero-sized frame; a scaled
            // strut fontSize of 0 trips TextField's assertion.
            strutStyle: StrutStyle.disabled,
            style: AppTextStyles.font14Normal.copyWith(
              color: colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest,
              hintText: 'home.bnpl.search_hint'.tr(),
              hintStyle: AppTextStyles.font14Normal.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              prefixIcon: Icon(
                Icons.search,
                size: 25.r,
                color: colorScheme.onSurfaceVariant,
              ),
              contentPadding: EdgeInsetsDirectional.symmetric(vertical: 12.h),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
