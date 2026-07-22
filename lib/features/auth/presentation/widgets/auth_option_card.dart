import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:no_wait/core/animations/animations.dart';
import 'package:no_wait/core/utils/app_text_styles.dart';

/// Tappable option row with a title and trailing chevron, used on the
/// "Can't Login" screen (Forgot Password / Change Mobile Number).
class AuthOptionCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const AuthOptionCard({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedTap(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: 16.w,
          vertical: 18.h,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.font14SemiBold.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: colorScheme.onSurfaceVariant,
              size: 22.r,
            ),
          ],
        ),
      ),
    );
  }
}
