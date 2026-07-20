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
import 'package:no_wait/core/widgets/app_text_field.dart';
import 'package:no_wait/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:no_wait/features/auth/presentation/cubit/auth_state.dart';
import 'package:no_wait/features/auth/presentation/widgets/auth_header.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
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
            if (state.action != AuthAction.login) return;
            if (state.isFailure && state.message != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message!),
                  backgroundColor: colorScheme.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else if (state.isSuccess) {
              context.pushNamedAndRemoveUntil(
                Routes.home,
                predicate: (_) => false,
              );
            }
          },
          builder: (context, state) {
            final isLoading = state.isLoading && state.action == AuthAction.login;

            return SingleChildScrollView(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AuthHeader(
                      title: 'auth.login.title'.tr(),
                      subtitle: 'auth.login.subtitle'.tr(),
                    ),
                    verticalSpace(28),
                    AppTextField(
                      label: 'auth.login.email_label'.tr(),
                      hint: 'auth.login.email_hint'.tr(),
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: AppValidators.validateEmail,
                    ).fadeInSlideUp(delay: AppAnimations.staggerDelay * 3),
                    verticalSpace(16),
                    AppTextField(
                      label: 'auth.login.password_label'.tr(),
                      hint: 'auth.login.password_hint'.tr(),
                      controller: _passwordController,
                      isPassword: true,
                      textInputAction: TextInputAction.done,
                      validator: AppValidators.validatePassword,
                    ).fadeInSlideUp(delay: AppAnimations.staggerDelay * 4),
                    verticalSpace(10),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: AnimatedTap(
                        onTap: () => context.pushNamed(Routes.forgotPassword),
                        child: Text(
                          'auth.login.forgot_password'.tr(),
                          style: AppTextStyles.font12SemiBold.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ).fadeInSlideUp(delay: AppAnimations.staggerDelay * 4),
                    verticalSpace(24),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsetsDirectional.all(12.r),
                      decoration: BoxDecoration(
                        color: colorScheme.secondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: colorScheme.secondary.withValues(alpha: 0.4),
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
                              'auth.login.demo_hint'.tr(),
                              style: AppTextStyles.font12SemiBold.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).fadeInSlideUp(delay: AppAnimations.staggerDelay * 5),
                    verticalSpace(24),
                    AnimatedButton(
                      height: 52.h,
                      isLoading: isLoading,
                      backgroundColor: colorScheme.primary,
                      borderRadius: BorderRadius.circular(16.r),
                      onPressed: _submit,
                      child: Center(
                        child: Text(
                          'auth.login.button'.tr(),
                          style: AppTextStyles.font16Normal.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ).fadeInSlideUp(delay: AppAnimations.staggerDelay * 5),
                    verticalSpace(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'auth.login.no_account'.tr(),
                          style: AppTextStyles.font14Normal.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        horizontalSpace(4),
                        AnimatedTap(
                          onTap: () =>
                              context.pushReplacementNamed(Routes.signUp),
                          child: Text(
                            'auth.login.register_link'.tr(),
                            style: AppTextStyles.font14SemiBold.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ).fadeInSlideUp(delay: AppAnimations.staggerDelay * 6),
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
