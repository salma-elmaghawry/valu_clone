import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:no_wait/core/animations/animations.dart';
import 'package:no_wait/core/helpers/extensions.dart';
import 'package:no_wait/core/helpers/spacing.dart';
import 'package:no_wait/core/routes/routes.dart';
import 'package:no_wait/features/auth/presentation/widgets/auth_option_card.dart';
import 'package:no_wait/features/auth/presentation/widgets/auth_top_bar.dart';

/// Mirrors the reference app's "Can't Login" screen: lets the user choose
/// between resetting their password or changing their mobile number.
class CantLoginScreen extends StatelessWidget {
  const CantLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AuthTopBar(title: 'auth.cant_login.appbar_title'.tr()),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AuthHeading(
                      title: 'auth.cant_login.title'.tr(),
                      subtitle: 'auth.cant_login.subtitle'.tr(),
                    ).fadeInSlideUp(),
                    verticalSpace(28),
                    AuthOptionCard(
                      title: 'auth.cant_login.forgot_password'.tr(),
                      onTap: () => context.pushNamed(Routes.forgotPassword),
                    ).fadeInSlideUp(delay: AppAnimations.staggerDelay),
                    verticalSpace(12),
                    AuthOptionCard(
                      title: 'auth.cant_login.change_mobile'.tr(),
                      onTap: () => context.pushNamed(Routes.changeMobileNumber),
                    ).fadeInSlideUp(delay: AppAnimations.staggerDelay * 2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
