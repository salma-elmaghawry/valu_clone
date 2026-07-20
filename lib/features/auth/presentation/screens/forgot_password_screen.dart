import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:no_wait/core/animations/animations.dart';
import 'package:no_wait/core/helpers/app_validators.dart';
import 'package:no_wait/core/helpers/extensions.dart';
import 'package:no_wait/core/helpers/spacing.dart';
import 'package:no_wait/core/utils/app_text_styles.dart';
import 'package:no_wait/core/widgets/app_text_field.dart';
import 'package:no_wait/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:no_wait/features/auth/presentation/cubit/auth_state.dart';
import 'package:no_wait/features/auth/presentation/widgets/auth_header.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().forgotPassword(
        email: _emailController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state.action != AuthAction.forgotPassword) return;
            if (state.isFailure && state.message != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message!),
                  backgroundColor: colorScheme.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else if (state.isSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('auth.forgot.success'.tr()),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              context.pop();
            }
          },
          builder: (context, state) {
            final isLoading =
                state.isLoading && state.action == AuthAction.forgotPassword;

            return SingleChildScrollView(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AuthHeader(
                      title: 'auth.forgot.title'.tr(),
                      subtitle: 'auth.forgot.subtitle'.tr(),
                    ),
                    verticalSpace(28),
                    AppTextField(
                      label: 'auth.login.email_label'.tr(),
                      hint: 'auth.login.email_hint'.tr(),
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      validator: AppValidators.validateEmail,
                    ).fadeInSlideUp(delay: AppAnimations.staggerDelay * 3),
                    verticalSpace(32),
                    AnimatedButton(
                      height: 52.h,
                      isLoading: isLoading,
                      backgroundColor: colorScheme.primary,
                      borderRadius: BorderRadius.circular(16.r),
                      onPressed: _submit,
                      child: Center(
                        child: Text(
                          'auth.forgot.button'.tr(),
                          style: AppTextStyles.font16Normal.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ).fadeInSlideUp(delay: AppAnimations.staggerDelay * 4),
                    verticalSpace(24),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
