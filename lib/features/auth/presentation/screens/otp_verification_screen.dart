import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:no_wait/core/animations/animations.dart';
import 'package:no_wait/core/helpers/extensions.dart';
import 'package:no_wait/core/helpers/spacing.dart';
import 'package:no_wait/core/routes/routes.dart';
import 'package:no_wait/core/utils/app_text_styles.dart';
import 'package:no_wait/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:no_wait/features/auth/presentation/cubit/auth_state.dart';
import 'package:no_wait/features/auth/presentation/models/auth_flow_args.dart';
import 'package:no_wait/features/auth/presentation/widgets/auth_success_sheet.dart';
import 'package:no_wait/features/auth/presentation/widgets/auth_top_bar.dart';
import 'package:no_wait/features/auth/presentation/widgets/otp_box_input.dart';

const _otpDuration = Duration(minutes: 3);

class OtpVerificationScreen extends StatefulWidget {
  final OtpVerificationArgs args;

  const OtpVerificationScreen({super.key, required this.args});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpKey = GlobalKey<State<OtpBoxInput>>();
  Timer? _timer;
  Duration _remaining = _otpDuration;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _remaining = _otpDuration;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining.inSeconds <= 1) {
        timer.cancel();
        setState(() => _remaining = Duration.zero);
      } else {
        setState(() => _remaining -= const Duration(seconds: 1));
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedRemaining {
    final minutes = _remaining.inMinutes.toString().padLeft(2, '0');
    final seconds = (_remaining.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _onCompleted(String code) {
    context.read<AuthCubit>().verifyOtp(phone: widget.args.phone, code: code);
  }

  void _resend() {
    context.read<AuthCubit>().sendOtp(phone: widget.args.phone);
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AuthTopBar(title: 'auth.otp.appbar_title'.tr()),
            Expanded(
              child: BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state.isFailure && state.message != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message!),
                        backgroundColor: colorScheme.error,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    if (state.action == AuthAction.verifyOtp) {
                      // ignore: avoid_dynamic_calls
                      (_otpKey.currentState as dynamic)?.clear();
                    }
                    return;
                  }
                  if (!state.isSuccess) return;

                  if (state.action == AuthAction.verifyOtp) {
                    switch (widget.args.flow) {
                      case OtpFlow.register:
                        context.pushNamed(
                          Routes.createPassword,
                          arguments: CreatePasswordArgs(
                            phone: widget.args.phone,
                            flow: PasswordFlow.register,
                          ),
                        );
                      case OtpFlow.resetPassword:
                        context.pushNamed(
                          Routes.createPassword,
                          arguments: CreatePasswordArgs(
                            phone: widget.args.phone,
                            flow: PasswordFlow.resetPassword,
                          ),
                        );
                      case OtpFlow.changeMobileNumber:
                        context.read<AuthCubit>().changeMobileNumber(
                          nationalId: widget.args.nationalId!,
                          newPhone: widget.args.phone,
                        );
                    }
                  } else if (state.action == AuthAction.changeMobileNumber) {
                    showAuthSuccessSheet(
                      context,
                      title: 'auth.change_mobile.success'.tr(),
                      onContinue: () => context.pushNamedAndRemoveUntil(
                        Routes.login,
                        predicate: (_) => false,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  final isVerifying =
                      state.isLoading && state.action == AuthAction.verifyOtp;

                  return SingleChildScrollView(
                    padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        verticalSpace(16),
                        Text(
                          'auth.otp.heading'.tr(),
                          style: AppTextStyles.font24Bold.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ).fadeInSlideUp(),
                        verticalSpace(6),
                        Text(
                          'auth.otp.subtitle'.tr(),
                          style: AppTextStyles.font14Normal.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ).fadeInSlideUp(delay: AppAnimations.staggerDelay),
                        verticalSpace(28),
                        IgnorePointer(
                          ignoring: isVerifying,
                          child: OtpBoxInput(
                            key: _otpKey,
                            onCompleted: _onCompleted,
                          ),
                        ).fadeInSlideUp(delay: AppAnimations.staggerDelay * 2),
                        verticalSpace(16),
                        if (_remaining > Duration.zero)
                          Text(
                            'auth.otp.expires_in'.tr(
                              args: [_formattedRemaining],
                            ),
                            style: AppTextStyles.font12SemiBold.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          )
                        else
                          AnimatedTap(
                            onTap: _resend,
                            child: Text(
                              'auth.otp.resend'.tr(),
                              style: AppTextStyles.font12SemiBold.copyWith(
                                color: colorScheme.secondary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        verticalSpace(24),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsetsDirectional.all(12.r),
                          decoration: BoxDecoration(
                            color: colorScheme.secondary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: colorScheme.secondary.withValues(
                                alpha: 0.4,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 18.r,
                                color: colorScheme.secondary,
                              ),
                              horizontalSpace(8),
                              Expanded(
                                child: Text(
                                  'auth.otp.demo_hint'.tr(),
                                  style: AppTextStyles.font12SemiBold.copyWith(
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ).fadeInSlideUp(delay: AppAnimations.staggerDelay * 3),
                        verticalSpace(24),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
