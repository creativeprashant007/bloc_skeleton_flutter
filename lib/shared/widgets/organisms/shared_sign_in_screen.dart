import 'package:stock_control_master/shared/widgets/atoms/app_back_button.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' show SizeExtension;

import 'package:stock_control_master/shared/widgets/molecules/form_input_box.dart'
    show FormInputBox;

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class SharedSignInScreen extends StatefulWidget {
  static const String routeName = '/sign-in';

  const SharedSignInScreen({
    super.key,
    required this.onSignInPressed,
    required this.onSignUpPressed,
    required this.onForgotPasswordPressed,
    required this.onSignInWithFacebook,
    required this.onSignInWithGoogle,
    required this.onSignInWithApple,
    required this.onRememberMeChanged,
    required this.appName,
    this.initialEmail = '',
    this.initialPassword = '',
    this.rememberMe = true,
  });

  final void Function({required String email, required String password})
  onSignInPressed;

  final VoidCallback onSignUpPressed;
  final VoidCallback onForgotPasswordPressed;
  final VoidCallback onSignInWithFacebook;
  final VoidCallback onSignInWithGoogle;
  final VoidCallback onSignInWithApple;
  final ValueChanged<bool> onRememberMeChanged;

  final String appName;
  final String initialEmail;
  final String initialPassword;
  final bool rememberMe;

  @override
  State<SharedSignInScreen> createState() => _SharedSignInScreenState();
}

class _SharedSignInScreenState extends State<SharedSignInScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  late bool _rememberMe;

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController(text: widget.initialEmail);
    _passwordController = TextEditingController(text: widget.initialPassword);
    _rememberMe = widget.rememberMe;
  }

  @override
  void didUpdateWidget(covariant SharedSignInScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialEmail != widget.initialEmail &&
        _emailController.text != widget.initialEmail) {
      _emailController.text = widget.initialEmail;
    }

    if (oldWidget.initialPassword != widget.initialPassword &&
        _passwordController.text != widget.initialPassword) {
      _passwordController.text = widget.initialPassword;
    }

    if (oldWidget.rememberMe != widget.rememberMe) {
      _rememberMe = widget.rememberMe;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      widget.onSignInPressed(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    }
  }

  void _toggleRememberMe() {
    final value = !_rememberMe;

    setState(() => _rememberMe = value);
    widget.onRememberMeChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final appColors = context.appColors;

    final primaryColor = colorScheme.primary;
    final titleColor = appColors.primaryText;
    final mutedText = appColors.secondaryText.withValues(alpha: 0.75);
    final softText = appColors.secondaryText;

    return Scaffold(
      backgroundColor: appColors.pageBackground,
      body: SafeArea(
        child: FormBuilder(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBackButton(color: primaryColor),

                SizedBox(height: 48.h),

                Center(
                  child: Column(
                    children: [
                      Text(
                        'Welcome back!',
                        textAlign: TextAlign.center,
                        style: textTheme.headlineMedium?.copyWith(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w900,
                          color: titleColor,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Sign in to manage your shifts',
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

                SizedBox(height: 40.h),

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

                SizedBox(height: 26.h),

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
                  ]),
                ),

                SizedBox(height: 18.h),

                Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(10.r),
                      onTap: _toggleRememberMe,
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            height: 22.h,
                            width: 22.w,
                            decoration: BoxDecoration(
                              color: _rememberMe
                                  ? primaryColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(6.r),
                              border: Border.all(
                                color: _rememberMe
                                    ? primaryColor
                                    : appColors.divider,
                                width: 1.4.w,
                              ),
                            ),
                            child: _rememberMe
                                ? Icon(
                                    Icons.check_rounded,
                                    size: 20.sp,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            'Remember me',
                            style: textTheme.titleMedium?.copyWith(
                              fontSize: 15.sp,
                              color: softText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: widget.onForgotPasswordPressed,
                      style: TextButton.styleFrom(
                        foregroundColor: primaryColor,
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Forgot password?',
                        style: textTheme.titleMedium?.copyWith(
                          fontSize: 14.sp,
                          color: primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 36.h),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 64.h),

                Center(
                  child: RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      style: textTheme.titleMedium?.copyWith(
                        fontSize: 10.sp,
                        color: mutedText,
                        fontWeight: FontWeight.w600,
                      ),
                      children: [
                        const TextSpan(
                          text:
                              'Received an invitation from your organization? ',
                        ),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: GestureDetector(
                            onTap: widget.onSignUpPressed,
                            child: Text(
                              'Activate Account',
                              style: textTheme.titleMedium?.copyWith(
                                fontSize: 12.sp,
                                color: primaryColor,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
