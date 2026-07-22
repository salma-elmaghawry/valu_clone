import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:no_wait/core/animations/animations.dart';
import 'package:no_wait/core/helpers/extensions.dart';
import 'package:no_wait/core/helpers/spacing.dart';
import 'package:no_wait/core/injection/injection_container.dart';
import 'package:no_wait/core/routes/routes.dart';
import 'package:no_wait/features/auth/repository/auth_repository.dart';
import 'package:no_wait/core/utils/app_assets.dart';
import 'package:no_wait/core/utils/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 2400), () {
      if (!mounted) return;
      final isLoggedIn = getIt<AuthRepository>().isLoggedIn;
      context.pushReplacementNamed(isLoggedIn ? Routes.home : Routes.intro);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppAssets.logo,
              width: 200.w,
            ).popIn(duration: AppAnimations.verySlow).shimmer(),
            verticalSpace(16),
            Text(
              'auth.splash.tagline'.tr(),
              textAlign: TextAlign.center,
              style: AppTextStyles.font16Normal.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ).fadeInSlideUp(delay: AppAnimations.slow),
          ],
        ),
      ),
    );
  }
}
