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
import 'package:no_wait/features/auth/presentation/models/auth_flow_args.dart';
import 'package:no_wait/features/auth/presentation/widgets/auth_top_bar.dart';

class ChangeMobileNumberScreen extends StatefulWidget {
  const ChangeMobileNumberScreen({super.key});

  @override
  State<ChangeMobileNumberScreen> createState() =>
      _ChangeMobileNumberScreenState();
}

class _ChangeMobileNumberScreenState extends State<ChangeMobileNumberScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _nationalIdController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _nationalIdController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().requestMobileNumberChange(
        nationalId: _nationalIdController.text.trim(),
        newPhone: _phoneController.text.trim(),
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
            AuthTopBar(title: 'auth.change_mobile.appbar_title'.tr()),
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
                  } else if (state.action == AuthAction.requestMobileChange &&
                      state.isSuccess) {
                    context.pushNamed(
                      Routes.otpVerification,
                      arguments: OtpVerificationArgs(
                        phone: _phoneController.text.trim(),
                        flow: OtpFlow.changeMobileNumber,
                        nationalId: _nationalIdController.text.trim(),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  final isLoading =
                      state.isLoading &&
                      state.action == AuthAction.requestMobileChange;

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
                            'auth.change_mobile.heading'.tr(),
                            style: AppTextStyles.font24Bold.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ).fadeInSlideUp(),
                          verticalSpace(6),
                          Text(
                            'auth.change_mobile.subtitle'.tr(),
                            style: AppTextStyles.font14Normal.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ).fadeInSlideUp(delay: AppAnimations.staggerDelay),
                          verticalSpace(28),
                          PhoneNumberField(
                            label: 'auth.change_mobile.phone_label'.tr(),
                            hint: 'auth.login.phone_hint'.tr(),
                            controller: _phoneController,
                            validator: AppValidators.validatePhone,
                          ).fadeInSlideUp(
                            delay: AppAnimations.staggerDelay * 2,
                          ),
                          verticalSpace(16),
                          _NationalIdField(
                            controller: _nationalIdController,
                          ).fadeInSlideUp(
                            delay: AppAnimations.staggerDelay * 3,
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
                                'auth.change_mobile.button'.tr(),
                                style: AppTextStyles.font16Normal.copyWith(
                                  color: colorScheme.onSecondary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ).fadeInSlideUp(
                            delay: AppAnimations.staggerDelay * 4,
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

class _NationalIdField extends StatelessWidget {
  final TextEditingController controller;

  const _NationalIdField({required this.controller});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'auth.change_mobile.national_id_label'.tr(),
          style: AppTextStyles.font14SemiBold.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        verticalSpace(8),
        TextFormField(
          controller: controller,
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
              borderSide: BorderSide(color: colorScheme.secondary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide(color: colorScheme.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide(color: colorScheme.error, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
