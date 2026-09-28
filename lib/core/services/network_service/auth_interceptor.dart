import 'dart:async';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:stock_control_master/core/locator.dart' show locator;
import 'package:stock_control_master/features/auth/presentation/view/sign_in_screen.dart'
    show SignInScreen;
import 'package:stock_control_master/shared/widgets/organisms/info_dialog.dart'
    show InfoDialog;
import 'package:stock_control_master/core/services/dialog_and_sheet_service/dialog_and_sheet_service.dart'
    show DialogAndSheetService;
import 'package:stock_control_master/core/services/navigation_service/navigation_service.dart'
    show NavigationService;
import 'package:stock_control_master/core/constants/constant.dart'
    show AppConstants;

class AuthInterceptor extends Interceptor {
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogAndSheetService>();
  final _log = Logger();

  bool _isLoggingOut = false;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.STORAGE_TOKEN_KEY);

      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      options.headers['Accept'] = 'application/json';
      options.headers['Content-Type'] = 'application/json';
    } catch (e) {
      _log.e("AuthInterceptor token read error: $e");
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _log.e(
      '---ENDPOINT: ${err.requestOptions.uri}\n'
      '---STATUSCODE: ${err.response?.statusCode}\n'
      '---ERROR: ${err.error}\n'
      '---MESSAGE: ${err.response?.data ?? err.message}',
    );

    // 401 → force logout
    if (err.response?.statusCode == 401) {
      _safeLogoutAndRedirect();
    }

    // Backend session expired flag
    final data = err.response?.data;
    if (_extractMessage(data) == 'SESSION_OUT') {
      _safeLogoutAndRedirect();
    }

    return handler.next(err);
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    _log.d("Response (${response.statusCode}): ${response.requestOptions.uri}");

    final msg = _extractMessage(response.data);

    if (msg == "Unauthorized access. Please log in and try again.") {
      await _safeLogoutAndRedirect(showDialog: true);
    }

    return handler.next(response);
  }

  String? _extractMessage(dynamic data) {
    try {
      if (data == null) return null;
      if (data is Map) return data['message']?.toString();
      if (data is String) return data;
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> _safeLogoutAndRedirect({bool showDialog = false}) async {
    if (_isLoggingOut) return;
    _isLoggingOut = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // or remove(AppConstants.STORAGE_TOKEN_KEY)

      if (showDialog) {
        await _dialogService.showAppDialog(
          child: InfoDialog(
            title: "Session Expired",
            message: "Kindly log in again.",
            onOkay: () async {
              await _navigationService.navigateToOffAllNamed(
                SignInScreen.routeName,
                (route) => false,
              );
            },
          ),
        );
      } else {
        _navigationService.navigateToOffAllNamed(
          SignInScreen.routeName,
          (route) => false,
        );
      }
    } catch (e) {
      _log.e("Logout failed: $e");
    } finally {
      _isLoggingOut = false;
    }
  }
}
