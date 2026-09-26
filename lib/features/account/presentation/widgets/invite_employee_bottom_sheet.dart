import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/app_theme_colors.dart';
import 'package:stock_control_master/shared/widgets/molecules/form_input_box.dart';

class InviteEmployeeBottomSheet extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final String? Function(String? value, String fieldName) requiredValidator;
  final String? Function(String? value) emailValidator;
  final bool isSending;
  final VoidCallback onSend;

  const InviteEmployeeBottomSheet({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.requiredValidator,
    required this.emailValidator,
    required this.isSending,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;
    final isDark = theme.brightness == Brightness.dark;

    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 14.h),
        decoration: BoxDecoration(
          color: appColors.cardBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(26.r)),
          border: Border(
            top: BorderSide(
              color: appColors.divider.withValues(alpha: isDark ? .40 : .50),
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? .30 : .12),
              blurRadius: 26.r,
              offset: Offset(0, -8.h),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: FormBuilder(
            key: formKey,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 42.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: appColors.divider.withValues(alpha: .75),
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Row(
                    children: [
                      Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: appColors.accent.withValues(alpha: .12),
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Icon(
                          Icons.person_add_alt_1_rounded,
                          color: appColors.accent,
                          size: 21.sp,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Add employee',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: appColors.primaryText,
                                fontWeight: FontWeight.w800,
                                fontSize: 15.sp,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Send an invitation to join your team.',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: appColors.secondaryText,
                                fontWeight: FontWeight.w500,
                                fontSize: 10.5.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: isSending
                            ? null
                            : () {
                                Navigator.of(context).pop();
                              },
                        icon: Icon(
                          Icons.close_rounded,
                          color: appColors.secondaryText,
                          size: 22.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(13.w),
                    decoration: BoxDecoration(
                      color: appColors.pageBackground.withValues(
                        alpha: isDark ? .52 : .70,
                      ),
                      borderRadius: BorderRadius.circular(22.r),
                      border: Border.all(
                        color: appColors.divider.withValues(
                          alpha: isDark ? .36 : .48,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        FormInputBox(
                          titleHeader: 'Full Name',
                          fieldName: 'name',
                          fieldController: nameController,
                          textHint: 'Enter full name',
                          fieldType: TextInputType.name,
                          prefixIcon: Icons.person_outline_rounded,
                          textCapitalization: TextCapitalization.words,
                          validator: (value) =>
                              requiredValidator(value, 'Name'),
                        ),
                        SizedBox(height: 13.h),
                        FormInputBox(
                          titleHeader: 'Email Address',
                          fieldName: 'email',
                          fieldController: emailController,
                          textHint: 'Enter email address',
                          fieldType: TextInputType.emailAddress,
                          prefixIcon: Icons.alternate_email_rounded,
                          validator: emailValidator,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    width: double.infinity,
                    height: 46.h,
                    child: ElevatedButton.icon(
                      onPressed: isSending ? null : onSend,
                      icon: isSending
                          ? SizedBox(
                              width: 18.w,
                              height: 18.w,
                              child: const CircularProgressIndicator.adaptive(
                                strokeWidth: 2,
                              ),
                            )
                          : Icon(Icons.send_rounded, size: 18.sp),
                      label: Text(
                        isSending ? 'Sending...' : 'Send invite',
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
