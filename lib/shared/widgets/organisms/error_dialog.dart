import 'package:stock_control_master/core/constants/app_assets.dart'
    show AppAssets;
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({
    super.key,
    required this.errorMessage,
    this.title,
    this.onOkay,
  });

  final String errorMessage;
  final String? title;
  final VoidCallback? onOkay;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 15.5),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(AppAssets.errorSvg, height: 80, width: 80),
            SizedBox(height: 32),
            Text(
              title ?? 'Error',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onOkay ?? () => Navigator.of(context).pop(),
                child: Text('Okay'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
