import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import 'package:stock_control_master/core/constants/app_assets.dart';

enum LessonStatus { notStarted, inProgress, completed }

LessonStatus parseLessonStatus(String? status) {
  switch (status?.toLowerCase()) {
    case 'in_progress':
      return LessonStatus.inProgress;
    case 'completed':
      return LessonStatus.completed;
    case 'not_started':
    default:
      return LessonStatus.notStarted;
  }
}

Widget lessonStatusWidget({required String? status, double size = 25}) {
  final parsed = parseLessonStatus(status);

  switch (parsed) {
    case LessonStatus.inProgress:
      return Lottie.asset(
        AppAssets.inProgress,
        height: size.h,
        width: size.w,
        options: LottieOptions(enableMergePaths: true),
        fit: BoxFit.cover,
      );

    case LessonStatus.completed:
      return Lottie.asset(
        AppAssets.done,
        height: size.h,
        width: size.w,
        fit: BoxFit.cover,
      );

    case LessonStatus.notStarted:
      return Icon(Icons.play_arrow, color: Colors.grey, size: size.sp);
  }
}
