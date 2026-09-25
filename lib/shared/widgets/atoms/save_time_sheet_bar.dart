import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';

class SaveTimesheetBar extends StatelessWidget {
  final bool isSaving;
  final VoidCallback onPressed;

  const SaveTimesheetBar({
    super.key,
    required this.isSaving,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return SafeArea(
      top: false,
      bottom: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 20.h),
        decoration: BoxDecoration(
          color: appColors.cardBackground,
          border: Border(
            top: BorderSide(color: appColors.divider.withValues(alpha: .45)),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 14.r,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          // height: 46.h,
          child: ElevatedButton.icon(
            onPressed: isSaving ? null : onPressed,
            icon: isSaving
                ? SizedBox(
                    width: 17.w,
                    height: 17.h,
                    child: const CircularProgressIndicator.adaptive(
                      strokeWidth: 2,
                    ),
                  )
                : Icon(Icons.add_circle_rounded, size: 15.sp),
            label: Text(isSaving ? 'Saving...' : 'SAVE TIMESHEET'),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
