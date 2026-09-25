import 'dart:async';

import 'package:stock_control_master/core/constants/app_assets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pinput.dart';

const int timerMaxSeconds = 60;

class SharedEnterPinScreen extends StatefulWidget {
  const SharedEnterPinScreen({
    super.key,
    required this.email,
    required this.onPinEntered,
    required this.onResendCode,
    required this.onNotYou,
  });

  final String email;
  final Function(String) onPinEntered;
  final VoidCallback onResendCode;
  final VoidCallback onNotYou;

  @override
  State<SharedEnterPinScreen> createState() => _SharedEnterPinScreenState();
}

class _SharedEnterPinScreenState extends State<SharedEnterPinScreen> {
  final TextEditingController _pinController = TextEditingController();
  late TapGestureRecognizer _onTapRecognizer;
  final interval = const Duration(seconds: 1);
  int resendTimeCount = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _onTapRecognizer = TapGestureRecognizer()..onTap = _handleOnTap;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pinController.dispose();
    _onTapRecognizer.dispose();
    super.dispose();
  }

  void _handleOnTap() {
    if (resendTimeCount == 0) {
      widget.onResendCode();
      _countDownTimer();
    }
  }

  String get resendTimer =>
      '${((timerMaxSeconds - resendTimeCount) ~/ 60).toString().padLeft(2, '0')}:${((timerMaxSeconds - resendTimeCount) % 60).toString().padLeft(2, '0')}';

  void _countDownTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(interval, (timer) {
      setState(() {
        resendTimeCount = timer.tick;
        if (timer.tick >= timerMaxSeconds) {
          timer.cancel();
          resendTimeCount = 0;
        }
      });
    });
  }

  void _submitIfComplete() {
    if (_pinController.text.length == 4) {
      widget.onPinEntered(_pinController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final defaultPinTheme = PinTheme(
      height: 60,
      width: 56,
      textStyle: textTheme.headlineSmall?.copyWith(
        color: textTheme.headlineSmall?.color ?? colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: colorScheme.primary, width: 1.5),
    );

    final secondaryText =
        textTheme.bodySmall?.color ??
        colorScheme.onSurface.withValues(alpha: 0.7);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color:
                          textTheme.bodyLarge?.color ?? colorScheme.onSurface,
                    ),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  const Spacer(),
                  SvgPicture.asset(AppAssets.emailSvg, height: 32, width: 32),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Verify Email',
                style: textTheme.headlineLarge?.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'A 4 digit code has been sent to\n${widget.email}',
                style: textTheme.bodyMedium?.copyWith(
                  color: secondaryText,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text.rich(
                TextSpan(
                  text: 'Wrong email? ',
                  style: textTheme.bodySmall?.copyWith(color: secondaryText),
                  children: [
                    TextSpan(
                      text: 'Try another method',
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onNotYou,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Input OTP',
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Pinput(
                length: 4,
                controller: _pinController,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                onChanged: (_) => setState(() {}),
                onCompleted: (_) => _submitIfComplete(),
              ),
              const SizedBox(height: 24),
              Text.rich(
                TextSpan(
                  text: "Didn't receive the code? ",
                  style: textTheme.bodySmall?.copyWith(color: secondaryText),
                  children: [
                    resendTimeCount == 0
                        ? TextSpan(
                            text: 'Resend',
                            recognizer: _onTapRecognizer,
                            mouseCursor: SystemMouseCursors.click,
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : TextSpan(
                            text: 'Resend in $resendTimer',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _pinController.text.length == 4
                      ? _submitIfComplete
                      : null,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text('Verify and Create Account'),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
