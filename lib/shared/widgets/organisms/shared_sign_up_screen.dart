import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' show SizeExtension;
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';
import 'package:stock_control_master/shared/widgets/atoms/app_back_button.dart';

import 'package:stock_control_master/shared/widgets/molecules/form_input_box.dart';

class SharedSignUpScreen extends StatefulWidget {
  static const String routeName = '/sign-up';

  const SharedSignUpScreen({
    super.key,
    required this.onSignInPressed,
    required this.onSignUpPressed,
    required this.onSignInWithFacebook,
    required this.onSignInWithGoogle,
    required this.onSignInWithApple,
    required this.appName,
  });

  final VoidCallback onSignInPressed;

  final void Function({
    required String email,
    required String password,
    required String passwordConfirmation,
  })
  onSignUpPressed;

  final VoidCallback onSignInWithFacebook;
  final VoidCallback onSignInWithGoogle;
  final VoidCallback onSignInWithApple;
  final String appName;

  @override
  State<SharedSignUpScreen> createState() => _SharedSignUpScreenState();
}

class _SharedSignUpScreenState extends State<SharedSignUpScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _termsAccepted = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    final isValid = _formKey.currentState?.saveAndValidate() ?? false;
    if (!isValid) return;

    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the processing of personal data'),
        ),
      );
      return;
    }

    widget.onSignUpPressed(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      passwordConfirmation: _confirmPasswordController.text.trim(),
    );
  }

  void _toggleTerms() {
    setState(() => _termsAccepted = !_termsAccepted);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final appColors = context.appColors;

    final backgroundColor = theme.scaffoldBackgroundColor;
    final primaryColor = colorScheme.primary;
    final titleColor = appColors.primaryText;
    final mutedText = appColors.secondaryText.withValues(alpha: 0.75);
    final softText = appColors.secondaryText;
    final dividerColor = primaryColor.withValues(alpha: 0.30);

    return Scaffold(
      backgroundColor: appColors.pageBackground,
      body: SafeArea(
        child: FormBuilder(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBackButton(color: primaryColor),

                SizedBox(height: 15.h),

                Center(
                  child: Column(
                    children: [
                      Text(
                        'Activate your account',
                        textAlign: TextAlign.center,
                        style: textTheme.headlineMedium?.copyWith(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w900,
                          color: titleColor,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'You have been invited by your organization. '
                        'Create a password to activate your access.',
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium?.copyWith(
                          fontSize: 14.sp,
                          color: mutedText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),

                FormInputBox(
                  titleHeader: 'Email address',
                  fieldName: 'email',
                  fieldController: _emailController,
                  fieldType: TextInputType.emailAddress,
                  textHint: 'Enter your email',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                      errorText: 'Email is required',
                    ),
                    FormBuilderValidators.email(
                      errorText: 'Enter a valid email',
                    ),
                  ]),
                ),

                SizedBox(height: 20.h),

                FormInputBox(
                  titleHeader: 'Password',
                  fieldName: 'password',
                  fieldController: _passwordController,
                  isPassword: true,
                  textHint: '••••••••',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                      errorText: 'Password is required',
                    ),
                    FormBuilderValidators.minLength(
                      6,
                      errorText: 'Password must be at least 6 characters',
                    ),
                  ]),
                ),

                SizedBox(height: 20.h),

                FormInputBox(
                  titleHeader: 'Confirm Password',
                  fieldName: 'password_confirmation',
                  fieldController: _confirmPasswordController,
                  isPassword: true,
                  textHint: '••••••••',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                      errorText: 'Confirm password is required',
                    ),
                    (value) {
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ]),
                ),

                SizedBox(height: 15.h),

                InkWell(
                  borderRadius: BorderRadius.circular(10.r),
                  onTap: _toggleTerms,
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        height: 22.h,
                        width: 22.w,
                        decoration: BoxDecoration(
                          color: _termsAccepted
                              ? primaryColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(
                            color: _termsAccepted
                                ? primaryColor
                                : appColors.divider,
                            width: 1.4.w,
                          ),
                        ),
                        child: _termsAccepted
                            ? Icon(
                                Icons.check_rounded,
                                size: 18.sp,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: textTheme.titleMedium?.copyWith(
                              fontSize: 14.sp,
                              color: softText,
                              height: 1.35,
                              fontWeight: FontWeight.w600,
                            ),
                            children: [
                              const TextSpan(
                                text: 'I agree to the processing of ',
                              ),
                              TextSpan(
                                text: 'Personal data',
                                style: textTheme.titleMedium?.copyWith(
                                  fontSize: 14.sp,
                                  color: primaryColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 25.h),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: Text('Activate Account'),
                  ),
                ),

                SizedBox(height: 15.h),

                // Row(
                //   children: [
                //     Expanded(
                //       child: Container(height: 1.2.h, color: dividerColor),
                //     ),
                //     Padding(
                //       padding: EdgeInsets.symmetric(horizontal: 12.w),
                //       child: Text(
                //         'Sign up with',
                //         style: textTheme.titleMedium?.copyWith(
                //           fontSize: 15.sp,
                //           color: softText,
                //           fontWeight: FontWeight.w600,
                //         ),
                //       ),
                //     ),
                //     Expanded(
                //       child: Container(height: 1.2.h, color: dividerColor),
                //     ),
                //   ],
                // ),
                SizedBox(height: 15.h),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     SocialSignIcon(
                //       assetPath: AppAssets.facebook,
                //       onTap: widget.onSignInWithFacebook,
                //     ),
                //     SocialSignIcon(
                //       assetPath: AppAssets.google,
                //       onTap: widget.onSignInWithGoogle,
                //     ),
                //     SocialSignIcon(
                //       assetPath: AppAssets.apple,
                //       onTap: widget.onSignInWithApple,
                //     ),
                //   ],
                // ),
                SizedBox(height: 20.h),

                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Text(
                        'Already activated your account? ',
                        style: textTheme.titleMedium?.copyWith(
                          fontSize: 15.sp,
                          color: mutedText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.onSignInPressed,
                        child: Text(
                          'Login',
                          style: textTheme.titleMedium?.copyWith(
                            fontSize: 15.sp,
                            color: primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
