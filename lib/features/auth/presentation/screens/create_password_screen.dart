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
import 'package:no_wait/features/auth/presentation/widgets/auth_password_field.dart';
import 'package:no_wait/features/auth/presentation/widgets/auth_success_sheet.dart';
import 'package:no_wait/features/auth/presentation/widgets/auth_top_bar.dart';
import 'package:no_wait/features/auth/presentation/widgets/password_policy_checklist.dart';

class CreatePasswordScreen extends StatefulWidget {
  final CreatePasswordArgs args;

  const CreatePasswordScreen({super.key, required this.args});

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_onChanged);
    _confirmController.addListener(_onChanged);
  }

  void _onChanged() => setState(() {});

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  bool get _isValid =>
      AppValidators.isStrongPassword(_passwordController.text) &&
      _confirmController.text.isNotEmpty &&
      _passwordController.text == _confirmController.text;

  void _submit() {
    if (!_isValid) return;
    FocusScope.of(context).unfocus();
    final cubit = context.read<AuthCubit>();
    if (widget.args.flow == PasswordFlow.register) {
      cubit.register(
        phone: widget.args.phone,
        password: _passwordController.text,
      );
    } else {
      cubit.resetPassword(
        phone: widget.args.phone,
        newPassword: _passwordController.text,
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
            AuthTopBar(title: 'auth.create_password.appbar_title'.tr()),
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

                  if (state.action == AuthAction.register) {
                    showAuthSuccessSheet(
                      context,
                      title: 'auth.success.register_title'.tr(),
                      onContinue: () => context.pushNamedAndRemoveUntil(
                        Routes.home,
                        predicate: (_) => false,
                      ),
                    );
                  } else if (state.action == AuthAction.resetPassword) {
                    showAuthSuccessSheet(
                      context,
                      title: 'auth.success.reset_title'.tr(),
                      onContinue: () => context.pushNamedAndRemoveUntil(
                        Routes.login,
                        predicate: (_) => false,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  final isLoading =
                      state.isLoading &&
                      (state.action == AuthAction.register ||
                          state.action == AuthAction.resetPassword);

                  return SingleChildScrollView(
                    padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        verticalSpace(16),
                        Text(
                          'auth.create_password.heading'.tr(),
                          style: AppTextStyles.font24Bold.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ).fadeInSlideUp(),
                        verticalSpace(6),
                        Text(
                          'auth.create_password.subtitle'.tr(),
                          style: AppTextStyles.font14Normal.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ).fadeInSlideUp(delay: AppAnimations.staggerDelay),
                        verticalSpace(28),
                        AuthPasswordField(
                          controller: _passwordController,
                          hint: 'auth.create_password.password_hint'.tr(),
                        ).fadeInSlideUp(delay: AppAnimations.staggerDelay * 2),
                        verticalSpace(16),
                        AuthPasswordField(
                          controller: _confirmController,
                          hint: 'auth.create_password.confirm_hint'.tr(),
                          textInputAction: TextInputAction.done,
                        ).fadeInSlideUp(delay: AppAnimations.staggerDelay * 3),
                        verticalSpace(20),
                        PasswordPolicyChecklist(
                          password: _passwordController.text,
                        ).fadeInSlideUp(delay: AppAnimations.staggerDelay * 4),
                        verticalSpace(28),
                        AnimatedButton(
                          height: 52.h,
                          isLoading: isLoading,
                          backgroundColor: _isValid
                              ? colorScheme.secondary
                              : colorScheme.secondary.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(16.r),
                          onPressed: _isValid ? _submit : null,
                          child: Center(
                            child: Text(
                              'auth.create_password.button'.tr(),
                              style: AppTextStyles.font16Normal.copyWith(
                                color: colorScheme.onSecondary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ).fadeInSlideUp(delay: AppAnimations.staggerDelay * 5),
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
