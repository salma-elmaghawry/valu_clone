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
import 'package:no_wait/core/widgets/phone_number_field.dart';
import 'package:no_wait/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:no_wait/features/auth/presentation/cubit/auth_state.dart';
import 'package:no_wait/features/auth/presentation/widgets/auth_password_field.dart';
import 'package:no_wait/features/auth/presentation/widgets/auth_top_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().login(
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
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
            AuthTopBar(title: 'auth.login.appbar_title'.tr()),
            Expanded(
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
                  final isLoading =
                      state.isLoading && state.action == AuthAction.login;

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
                            'auth.login.title'.tr(),
                            style: AppTextStyles.font24Bold.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ).fadeInSlideUp(),
                          verticalSpace(6),
                          Text(
                            'auth.login.subtitle'.tr(),
                            style: AppTextStyles.font14Normal.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ).fadeInSlideUp(delay: AppAnimations.staggerDelay),
                          verticalSpace(28),
                          PhoneNumberField(
                            label: 'auth.login.phone_label'.tr(),
                            hint: 'auth.login.phone_hint'.tr(),
                            controller: _phoneController,
                            validator: AppValidators.validatePhone,
                          ).fadeInSlideUp(
                            delay: AppAnimations.staggerDelay * 2,
                          ),
                          verticalSpace(16),
                          AuthPasswordField(
                            controller: _passwordController,
                            hint: 'auth.login.password_hint'.tr(),
                            textInputAction: TextInputAction.done,
                            validator: AppValidators.validatePasswordRequired,
                          ).fadeInSlideUp(
                            delay: AppAnimations.staggerDelay * 3,
                          ),
                          verticalSpace(10),
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: AnimatedTap(
                              onTap: () => context.pushNamed(Routes.cantLogin),
                              child: Text(
                                'auth.login.cant_login'.tr(),
                                style: AppTextStyles.font12SemiBold.copyWith(
                                  color: colorScheme.secondary,
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ).fadeInSlideUp(
                            delay: AppAnimations.staggerDelay * 3,
                          ),
                          verticalSpace(24),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsetsDirectional.all(12.r),
                            decoration: BoxDecoration(
                              color: colorScheme.secondary.withValues(
                                alpha: 0.1,
                              ),
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
                                    'auth.login.demo_hint'.tr(),
                                    style: AppTextStyles.font12SemiBold
                                        .copyWith(color: colorScheme.onSurface),
                                  ),
                                ),
                              ],
                            ),
                          ).fadeInSlideUp(
                            delay: AppAnimations.staggerDelay * 4,
                          ),
                          verticalSpace(24),
                          AnimatedButton(
                            height: 52.h,
                            isLoading: isLoading,
                            backgroundColor: colorScheme.secondary,
                            borderRadius: BorderRadius.circular(16.r),
                            onPressed: _submit,
                            child: Center(
                              child: Text(
                                'auth.login.button'.tr(),
                                style: AppTextStyles.font16Normal.copyWith(
                                  color: colorScheme.onSecondary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ).fadeInSlideUp(
                            delay: AppAnimations.staggerDelay * 4,
                          ),
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
                                    color: colorScheme.secondary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ).fadeInSlideUp(
                            delay: AppAnimations.staggerDelay * 5,
                          ),
                          verticalSpace(24),
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
    );
  }
}
