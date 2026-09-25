// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' show SizeExtension;

class FormInputBox extends StatefulWidget {
  const FormInputBox({
    super.key,
    required this.titleHeader,
    required this.fieldName,
    required this.fieldController,
    this.fieldType = TextInputType.text,
    this.validator,
    required this.textHint,
    this.onChanged,
    this.isPassword = false,

    // Kept for old calls, but phone is fixed UK only.
    this.initialPhoneCode = '+44',
    this.onPhoneCountryChange,

    this.maxLines = 1,
    this.minLines,
    this.enabled = true,
    this.prefixIcon,
    this.textCapitalization = TextCapitalization.none,
  });

  final String? titleHeader;
  final String fieldName;
  final TextEditingController fieldController;
  final TextInputType fieldType;
  final String? Function(String?)? validator;
  final String textHint;
  final void Function(String?)? onChanged;
  final bool isPassword;

  final String initialPhoneCode;
  final void Function(String)? onPhoneCountryChange;

  final int maxLines;
  final int? minLines;
  final bool enabled;
  final IconData? prefixIcon;
  final TextCapitalization textCapitalization;

  @override
  State<FormInputBox> createState() => _FormInputBoxState();
}

class _FormInputBoxState extends State<FormInputBox> {
  bool _obscure = true;

  static const String _fixedPhoneCode = '+44';

  @override
  void initState() {
    super.initState();
    _obscure = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = colorScheme.primary;
    final onSurface = colorScheme.onSurface;
    final surface = colorScheme.surface;
    final errorColor = colorScheme.error;

    final labelColor = onSurface.withValues(alpha: .76);
    final hintColor = onSurface.withValues(alpha: .38);
    final textColor = onSurface.withValues(alpha: .94);

    final fillColor = isDark
        ? surface.withValues(alpha: .46)
        : primaryColor.withValues(alpha: .045);

    final borderColor = isDark
        ? onSurface.withValues(alpha: .18)
        : primaryColor.withValues(alpha: .25);

    final focusedBorderColor = primaryColor.withValues(alpha: .85);

    final isPhoneField = widget.fieldType == TextInputType.phone;
    final isMultiline = widget.maxLines > 1;
    final hasPrefix = isPhoneField || widget.prefixIcon != null;

    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: BorderSide(color: borderColor, width: 1.05.w),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.titleHeader != null && widget.titleHeader!.trim().isNotEmpty)
          Padding(
            padding: EdgeInsets.only(left: 5.w, bottom: 7.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 4.w,
                  height: 4.w,
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: .75),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  widget.titleHeader!,
                  style: textTheme.labelLarge?.copyWith(
                    color: labelColor,
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .08,
                  ),
                ),
              ],
            ),
          ),

        FormBuilderTextField(
          name: widget.fieldName,
          controller: widget.fieldController,
          enabled: widget.enabled,
          keyboardType: isMultiline
              ? TextInputType.multiline
              : widget.fieldType,
          textInputAction: isMultiline
              ? TextInputAction.newline
              : TextInputAction.done,
          textCapitalization: widget.textCapitalization,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          minLines: widget.isPassword ? 1 : widget.minLines,
          obscureText: widget.isPassword ? _obscure : false,
          onChanged: widget.onChanged,
          validator: widget.validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: textTheme.bodyMedium?.copyWith(
            color: textColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
          cursorColor: primaryColor,
          decoration: InputDecoration(
            hintText: widget.textHint,
            hintStyle: textTheme.bodyMedium?.copyWith(
              color: hintColor,
              fontSize: 13.2.sp,
              fontWeight: FontWeight.w600,
            ),
            filled: true,
            fillColor: fillColor,
            isDense: true,
            alignLabelWithHint: isMultiline,
            contentPadding: EdgeInsets.only(
              left: hasPrefix ? 10.w : 15.w,
              right: widget.isPassword ? 8.w : 15.w,
              top: isMultiline ? 15.h : 14.h,
              bottom: isMultiline ? 15.h : 14.h,
            ),

            prefixIconConstraints: BoxConstraints(
              minWidth: hasPrefix ? 48.w : 0,
              minHeight: 44.h,
            ),
            prefixIcon: _buildPrefixIcon(
              context: context,
              isPhoneField: isPhoneField,
              icon: widget.prefixIcon,
              primaryColor: primaryColor,
              onSurface: onSurface,
              borderColor: borderColor,
              isDark: isDark,
            ),

            suffixIconConstraints: BoxConstraints(
              minWidth: widget.isPassword ? 48.w : 0,
              minHeight: 44.h,
            ),
            suffixIcon: widget.isPassword
                ? Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: Center(
                      widthFactor: 1,
                      child: Material(
                        color: primaryColor.withValues(alpha: .08),
                        borderRadius: BorderRadius.circular(12.r),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12.r),
                          onTap: () => setState(() => _obscure = !_obscure),
                          child: SizedBox(
                            height: 34.w,
                            width: 34.w,
                            child: Icon(
                              _obscure
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 18.5.sp,
                              color: primaryColor.withValues(alpha: .82),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : null,

            errorStyle: textTheme.labelSmall?.copyWith(
              color: errorColor,
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),

            enabledBorder: inputBorder,
            focusedBorder: inputBorder.copyWith(
              borderSide: BorderSide(color: focusedBorderColor, width: 1.35.w),
            ),
            errorBorder: inputBorder.copyWith(
              borderSide: BorderSide(
                color: errorColor.withValues(alpha: .86),
                width: 1.2.w,
              ),
            ),
            focusedErrorBorder: inputBorder.copyWith(
              borderSide: BorderSide(color: errorColor, width: 1.35.w),
            ),
            disabledBorder: inputBorder.copyWith(
              borderSide: BorderSide(
                color: borderColor.withValues(alpha: .45),
                width: 1.w,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget? _buildPrefixIcon({
    required BuildContext context,
    required bool isPhoneField,
    required IconData? icon,
    required Color primaryColor,
    required Color onSurface,
    required Color borderColor,
    required bool isDark,
  }) {
    final textTheme = Theme.of(context).textTheme;

    if (isPhoneField) {
      return Padding(
        padding: EdgeInsets.only(left: 12.w, right: 8.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: .09),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: primaryColor.withValues(alpha: .12)),
              ),
              child: Text(
                _fixedPhoneCode,
                style: textTheme.bodyMedium?.copyWith(
                  color: onSurface.withValues(alpha: .90),
                  fontSize: 12.8.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            SizedBox(width: 8.w),
          ],
        ),
      );
    }

    if (icon != null) {
      return Padding(
        padding: EdgeInsets.only(left: 10.w, right: 7.w),
        child: Container(
          width: 30.w,
          height: 30.w,
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: isDark ? .13 : .09),
            borderRadius: BorderRadius.circular(11.r),
          ),
          child: Icon(
            icon,
            size: 17.5.sp,
            color: primaryColor.withValues(alpha: .80),
          ),
        ),
      );
    }

    return null;
  }
}
