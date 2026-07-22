import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:no_wait/core/animations/animations.dart';
import 'package:no_wait/core/helpers/app_validators.dart';
import 'package:no_wait/core/helpers/extensions.dart';
import 'package:no_wait/core/helpers/spacing.dart';
import 'package:no_wait/core/routes/routes.dart';
import 'package:no_wait/core/utils/app_text_styles.dart';
import 'package:no_wait/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:no_wait/features/auth/presentation/cubit/auth_state.dart';
import 'package:no_wait/features/auth/presentation/models/auth_flow_args.dart';
import 'package:no_wait/features/auth/presentation/widgets/auth_top_bar.dart';

/// First step of the "forgot password" journey: identify the account by
/// national ID, then move on to OTP verification of its registered number.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nationalIdController = TextEditingController();

  @override
  void dispose() {
    _nationalIdController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().lookupNationalId(
        nationalId: _nationalIdController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AuthTopBar(title: 'auth.national_id.appbar_title'.tr()),
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
                    return;
                  }
                  if (!state.isSuccess) return;
                  if (state.action == AuthAction.lookupNationalId &&
                      state.resolvedPhone != null) {
                    context.read<AuthCubit>().sendOtp(
                      phone: state.resolvedPhone!,
                    );
                  } else if (state.action == AuthAction.sendOtp &&
                      state.resolvedPhone != null) {
                    context.pushNamed(
                      Routes.otpVerification,
                      arguments: OtpVerificationArgs(
                        phone: state.resolvedPhone!,
                        flow: OtpFlow.resetPassword,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return SingleChildScrollView(
                    padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          verticalSpace(16),
                          Text(
                            'auth.national_id.title'.tr(),
                            style: AppTextStyles.font24Bold.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ).fadeInSlideUp(),
                          verticalSpace(6),
                          Text(
                            'auth.national_id.subtitle'.tr(),
                            style: AppTextStyles.font14Normal.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ).fadeInSlideUp(delay: AppAnimations.staggerDelay),
                          verticalSpace(28),
                          TextFormField(
                            controller: _nationalIdController,
                            keyboardType: TextInputType.number,
                            maxLength: 14,
                            validator: AppValidators.validateNationalId,
                            style: AppTextStyles.font14Normal.copyWith(
                              color: colorScheme.onSurface,
                            ),
                            decoration: InputDecoration(
                              hintText: 'auth.national_id.hint'.tr(),
                              hintStyle: AppTextStyles.font14Normal.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                              counterText: '',
                              filled: true,
                              fillColor: colorScheme.surfaceContainerHighest,
                              contentPadding: EdgeInsetsDirectional.symmetric(
                                horizontal: 16.w,
                                vertical: 14.h,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.r),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.r),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.r),
                                borderSide: BorderSide(
                                  color: colorScheme.secondary,
                                  width: 1.5,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.r),
                                borderSide: BorderSide(
                                  color: colorScheme.error,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.r),
                                borderSide: BorderSide(
                                  color: colorScheme.error,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ).fadeInSlideUp(
                            delay: AppAnimations.staggerDelay * 2,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(24.w, 0, 24.w, 16.h),
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              final isLoading =
                  state.isLoading &&
                  (state.action == AuthAction.lookupNationalId ||
                      state.action == AuthAction.sendOtp);
              return AnimatedButton(
                height: 52.h,
                isLoading: isLoading,
                backgroundColor: colorScheme.secondary,
                borderRadius: BorderRadius.circular(16.r),
                onPressed: _submit,
                child: Center(
                  child: Text(
                    'auth.national_id.button'.tr(),
                    style: AppTextStyles.font16Normal.copyWith(
                      color: colorScheme.onSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
