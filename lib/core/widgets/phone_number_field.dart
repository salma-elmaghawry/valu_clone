import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:no_wait/core/helpers/spacing.dart';
import 'package:no_wait/core/utils/app_text_styles.dart';

class _CountryCode {
  final String flag;
  final String dialCode;
  final String name;

  const _CountryCode({
    required this.flag,
    required this.dialCode,
    required this.name,
  });
}

/// Mobile number field with a leading country-code picker.
///
/// Only Egypt is selectable for now (phone validation is Egypt-only), but
/// the picker itself is functional and structured so more countries can be
/// added later by extending [_countries].
class PhoneNumberField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const PhoneNumberField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.validator,
  });

  @override
  State<PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  static const List<_CountryCode> _countries = [
    _CountryCode(flag: '🇪🇬', dialCode: '+20', name: 'Egypt'),
  ];

  _CountryCode _selectedCountry = _countries.first;

  Future<void> _pickCountry() async {
    final colorScheme = Theme.of(context).colorScheme;

    final picked = await showModalBottomSheet<_CountryCode>(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(20.r)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              verticalSpace(12),
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              verticalSpace(12),
              for (final country in _countries)
                ListTile(
                  leading: Text(country.flag, style: TextStyle(fontSize: 22.sp)),
                  title: Text(
                    country.name,
                    style: AppTextStyles.font14SemiBold.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  trailing: country.dialCode == _selectedCountry.dialCode
                      ? Icon(Icons.check, color: colorScheme.secondary)
                      : Text(
                          country.dialCode,
                          style: AppTextStyles.font14Normal.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                  onTap: () => Navigator.of(sheetContext).pop(country),
                ),
              verticalSpace(8),
            ],
          ),
        );
      },
    );

    if (picked != null && mounted) {
      setState(() => _selectedCountry = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // A plain FormField wraps the row so the error message renders below
    // it, outside the IntrinsicHeight block. Keeping the error text out of
    // that block is what keeps the country-code chip and the input box the
    // same height regardless of whether an error is showing.
    return FormField<String>(
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.label,
              style: AppTextStyles.font14SemiBold.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            verticalSpace(8),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Material(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(14.r),
                    child: InkWell(
                      onTap: _countries.length > 1 ? _pickCountry : null,
                      borderRadius: BorderRadius.circular(14.r),
                      child: Container(
                        padding: EdgeInsetsDirectional.symmetric(
                          horizontal: 12.w,
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _selectedCountry.flag,
                              style: TextStyle(fontSize: 18.sp),
                            ),
                            horizontalSpace(4),
                            Text(
                              _selectedCountry.dialCode,
                              style: AppTextStyles.font14Normal.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              size: 18.r,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  horizontalSpace(10),
                  Expanded(
                    child: TextField(
                      controller: widget.controller,
                      onChanged: field.didChange,
                      keyboardType: TextInputType.phone,
                      textAlignVertical: TextAlignVertical.center,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(11),
                      ],
                      style: AppTextStyles.font14Normal.copyWith(
                        color: colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        hintText: widget.hint,
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
                          borderSide: field.hasError
                              ? BorderSide(color: colorScheme.error)
                              : BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.r),
                          borderSide: BorderSide(
                            color: field.hasError
                                ? colorScheme.error
                                : colorScheme.secondary,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (field.hasError) ...[
              verticalSpace(6),
              Text(
                field.errorText!,
                style: AppTextStyles.font12SemiBold.copyWith(
                  fontWeight: FontWeight.normal,
                  color: colorScheme.error,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
