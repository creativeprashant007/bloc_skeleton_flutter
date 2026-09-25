import 'package:stock_control_master/core/services/dialog_and_sheet_service/dialog_and_sheet_service.dart'
    show DialogAndSheetService;
import 'package:stock_control_master/core/services/navigation_service/i_navigation_service.dart'
    show INavigationService;
import 'package:flutter/material.dart';

class IDialogAndSheetService extends DialogAndSheetService {
  final key = INavigationService.navigatorKey;
  @override
  Future<T?> showAppBottomSheet<T>(Widget child) async {
    return showModalBottomSheet(
      context: key.currentContext!,
      enableDrag: true,
      elevation: 0,
      isScrollControlled: true,
      isDismissible: false,
      useRootNavigator: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
          bottom: Radius.zero,
        ),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: child,
      ),
    );
  }

  @override
  Future<T?> showAppDialog<T>({
    required Widget child,
    bool? isDismissible,
  }) async {
    return showAdaptiveDialog(
      context: key.currentContext!,
      //useRootNavigator: true,
      useSafeArea: true,

      builder: (context) => PopScope(canPop: false, child: child),
    );
  }
}
