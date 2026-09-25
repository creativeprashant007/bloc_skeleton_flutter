import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' show SizeExtension;

class CountryCodePickerWidget extends StatelessWidget {
  final String initialCountryCode;
  final void Function(String) onCountryCodeChanged;

  const CountryCodePickerWidget({
    super.key,
    required this.initialCountryCode,
    required this.onCountryCodeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(left: 6),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r), // ✅ as requested
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.2),
          width: 0.5.w,
        ),
        color: theme.scaffoldBackgroundColor.withValues(
          alpha: theme.brightness == Brightness.dark ? 0.4 : 0.9,
        ),
      ),
      child: CountryCodePicker(
        onChanged: (CountryCode code) =>
            onCountryCodeChanged(code.dialCode ?? '+44'),

        initialSelection: initialCountryCode,

        showCountryOnly: false,
        showOnlyCountryWhenClosed: false,

        alignLeft: false,

        textStyle: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),

        dialogTextStyle: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
        ),

        searchDecoration: InputDecoration(
          hintText: 'Search country',
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.4),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),

        dialogBackgroundColor: colorScheme.surface,

        boxDecoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),

        flagWidth: 20,

        padding: EdgeInsets.zero,
      ),
    );
  }
}
