import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SheetButtons extends StatelessWidget {
  final String primaryText;
  final VoidCallback onSave;

  const SheetButtons({super.key, required this.primaryText, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 42.h,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
        SizedBox(width: 9.w),
        Expanded(
          child: SizedBox(
            height: 42.h,
            child: ElevatedButton.icon(
              onPressed: onSave,
              icon: Icon(Icons.check_rounded, size: 16.sp),
              label: Text(
                primaryText,
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
