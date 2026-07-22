import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:no_wait/core/animations/animations.dart';
import 'package:no_wait/core/helpers/spacing.dart';
import 'package:no_wait/core/theme/app_colors.dart';
import 'package:no_wait/core/utils/app_text_styles.dart';

/// Bottom sheet shown after a successful register / reset-password /
/// change-number step: checkmark, message, and a single Continue button.
Future<void> showAuthSuccessSheet(
  BuildContext context, {
  required String title,
  required VoidCallback onContinue,
}) {
  final colorScheme = Theme.of(context).colorScheme;

  return showModalBottomSheet<void>(
    context: context,
    isDismissible: false,
    enableDrag: false,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadiusDirectional.only(
        topStart: Radius.circular(24.r),
        topEnd: Radius.circular(24.r),
      ),
    ),
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsetsDirectional.fromSTEB(24.w, 32.h, 24.w, 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64.r,
              height: 64.r,
              decoration: BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check, color: Colors.white, size: 32.r),
            ).fadeInScale(),
            verticalSpace(20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.font18Normal.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            verticalSpace(28),
            AnimatedButton(
              height: 52.h,
              backgroundColor: colorScheme.secondary,
              borderRadius: BorderRadius.circular(16.r),
              onPressed: () {
                Navigator.of(sheetContext).pop();
                onContinue();
              },
              child: Center(
                child: Text(
                  'auth.success.continue_button'.tr(),
                  style: AppTextStyles.font16Normal.copyWith(
                    color: colorScheme.onSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
