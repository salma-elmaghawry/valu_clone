import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:no_wait/core/utils/app_text_styles.dart';

/// Slim top bar shared by every auth sub-screen: a back button and a
/// centered screen title, mirroring the reference app-bar layout.
///
/// Placed as the first child inside the screen's body `SafeArea` (not as a
/// `Scaffold.appBar`), since it needs no extra chrome beyond what the body's
/// safe area already provides.
class AuthTopBar extends StatelessWidget {
  final String title;

  const AuthTopBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        BackButton(color: colorScheme.onSurface),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.font16Normal.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(width: 48.w),
      ],
    );
  }
}

/// Shared bold heading + subtitle block used below [AuthTopBar].
class AuthHeading extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeading({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.font24Bold.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          subtitle,
          style: AppTextStyles.font14Normal.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
