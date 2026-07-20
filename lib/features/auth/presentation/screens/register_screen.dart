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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().register(
        name: _nameController.text.trim(),
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
            if (state.action != AuthAction.register) return;
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
            final isLoading =
                state.isLoading && state.action == AuthAction.register;

            return SingleChildScrollView(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AuthHeader(
                      title: 'auth.signup.title'.tr(),
                      subtitle: 'auth.signup.subtitle'.tr(),
                    ),
                    verticalSpace(28),
                    AppTextField(
                      label: 'auth.signup.name_label'.tr(),
                      hint: 'auth.signup.name_hint'.tr(),
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      validator: AppValidators.validateName,
                    ).fadeInSlideUp(delay: AppAnimations.staggerDelay * 3),
                    verticalSpace(16),
                    AppTextField(
                      label: 'auth.login.email_label'.tr(),
                      hint: 'auth.login.email_hint'.tr(),
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: AppValidators.validateEmail,
                    ).fadeInSlideUp(delay: AppAnimations.staggerDelay * 4),
                    verticalSpace(16),
                    AppTextField(
                      label: 'auth.login.password_label'.tr(),
                      hint: 'auth.login.password_hint'.tr(),
                      controller: _passwordController,
                      isPassword: true,
                      validator: AppValidators.validatePassword,
                    ).fadeInSlideUp(delay: AppAnimations.staggerDelay * 5),
                    verticalSpace(16),
                    AppTextField(
                      label: 'auth.signup.confirm_label'.tr(),
                      hint: 'auth.signup.confirm_hint'.tr(),
                      controller: _confirmController,
                      isPassword: true,
                      textInputAction: TextInputAction.done,
                      validator: (value) =>
                          AppValidators.validateConfirmPassword(
                            value,
                            _passwordController.text,
                          ),
                    ).fadeInSlideUp(delay: AppAnimations.staggerDelay * 6),
                    verticalSpace(32),
                    AnimatedButton(
                      height: 52.h,
                      isLoading: isLoading,
                      backgroundColor: colorScheme.primary,
                      borderRadius: BorderRadius.circular(16.r),
                      onPressed: _submit,
                      child: Center(
                        child: Text(
                          'auth.signup.button'.tr(),
                          style: AppTextStyles.font16Normal.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ).fadeInSlideUp(delay: AppAnimations.staggerDelay * 7),
                    verticalSpace(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'auth.signup.have_account'.tr(),
                          style: AppTextStyles.font14Normal.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        horizontalSpace(4),
                        AnimatedTap(
                          onTap: () =>
                              context.pushReplacementNamed(Routes.login),
                          child: Text(
                            'auth.signup.login_link'.tr(),
                            style: AppTextStyles.font14SemiBold.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ).fadeInSlideUp(delay: AppAnimations.staggerDelay * 8),
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
