import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:no_wait/core/animations/animations.dart';
import 'package:no_wait/core/helpers/spacing.dart';
import 'package:no_wait/core/utils/app_assets.dart';
import 'package:no_wait/core/utils/app_text_styles.dart';

/// Shared header for auth screens: back button, brand logo, title, subtitle.
class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: BackButton(color: colorScheme.onSurface),
        ),
        verticalSpace(8),
        Image.asset(AppAssets.logo, height: 32.h).fadeInScale(),
        verticalSpace(24),
        Text(
          title,
          style: AppTextStyles.font24Bold.copyWith(
            color: colorScheme.onSurface,
          ),
        ).fadeInSlideUp(delay: AppAnimations.staggerDelay),
        verticalSpace(6),
        Text(
          subtitle,
          style: AppTextStyles.font14Normal.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ).fadeInSlideUp(delay: AppAnimations.staggerDelay * 2),
      ],
    );
  }
}
