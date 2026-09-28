import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import 'package:stock_control_master/core/services/session_manager.dart'
    show SessionManager;
import 'package:stock_control_master/core/services/firebase/notification_service.dart'
    show NotificationService;
import 'package:stock_control_master/features/account/presentation/bloc/account_bloc.dart'
    show AccountBloc;
import 'package:stock_control_master/features/account/presentation/bloc/account_event.dart'
    show LoadAccount;
import 'package:stock_control_master/features/auth/domain/entities/current_user.dart'
    show CurrentUser;
import 'package:stock_control_master/core/configs/service/storage_service.dart';
import 'package:stock_control_master/core/constants/constant.dart';
import 'package:stock_control_master/core/locator.dart' show locator;
import 'package:stock_control_master/shared/widgets/organisms/error_dialog.dart'
    show ErrorDialog;
import 'package:stock_control_master/shared/widgets/organisms/loading_dialog.dart'
    show LoadingDialog;
import 'package:stock_control_master/features/auth/domain/params/register_user_params.dart'
    show RegisterUserParams;
import 'package:stock_control_master/features/auth/domain/usecases/register_usecase.dart'
    show RegisterUsecase;
import 'package:stock_control_master/features/auth/presentation/view/sign_in_screen.dart'
    show SignInScreen;
import 'package:stock_control_master/features/index/presentation/view/index_screen.dart';
import 'package:stock_control_master/core/services/dialog_and_sheet_service/dialog_and_sheet_service.dart'
    show DialogAndSheetService;
import 'package:stock_control_master/core/services/navigation_service/navigation_service.dart'
    show NavigationService;

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc({
    StorageService? storageService,
    RegisterUsecase? registerUsecase,
    NotificationService? notificationService,
  }) : _storage = storageService ?? StorageService(),
       _registerUsecase = registerUsecase ?? RegisterUsecase(),
       _notificationService = notificationService ?? NotificationService(),
       super(const SignUpInitial()) {
    on<NavigateToSignInEvent>(_navigateToSignIn);
    on<SubmitSignUpEvent>(_submitSignUp);
    on<SignInWithGoogleEvent>(_signInWithGoogle);
    on<SignInWithFacebookEvent>(_signInWithFacebook);
    on<SignInWithAppleEvent>(_signInWithApple);
  }

  final Logger _logger = Logger();

  final NavigationService _navigationService = locator<NavigationService>();
  final NotificationService _notificationService;
  final DialogAndSheetService _dialogAndSheetService =
      locator<DialogAndSheetService>();

  final StorageService _storage;
  final RegisterUsecase _registerUsecase;

  bool _storageInitialized = false;

  Future<void> _ensureStorageInitialized() async {
    if (_storageInitialized) return;
    await _storage.init();
    _storageInitialized = true;
  }

  void _showLoading(String message) {
    _dialogAndSheetService.showAppDialog(
      child: LoadingDialog(message: message),
    );
  }

  void _closeLoadingIfOpen() {
    _navigationService.back();
  }

  void _showError(String message) {
    _dialogAndSheetService.showAppDialog(
      child: ErrorDialog(errorMessage: message),
    );
  }

  Future<void> _saveToken(String? token) async {
    if (token == null || token.isEmpty) return;
    await _storage.setString(AppConstants.STORAGE_TOKEN_KEY, token);
  }

  Future<void> _saveUserJson(Map<String, dynamic> userJson) async {
    final user = CurrentUser.fromJson(userJson);
    await SessionManager.instance.saveUser(user);
  }

  Future<void> _navigateToHome() async {
    _navigationService.navigateToNamed(IndexScreen.routeName);
  }

  FutureOr<void> _navigateToSignIn(
    NavigateToSignInEvent event,
    Emitter<SignUpState> emit,
  ) {
    _navigationService.navigateToNamed(SignInScreen.routeName);
  }

  Future<void> _submitSignUp(
    SubmitSignUpEvent event,
    Emitter<SignUpState> emit,
  ) async {
    await _ensureStorageInitialized();
    final deviceToken = await _notificationService.getDeviceToken();
    _showLoading('Signing up...');

    final res = await _registerUsecase.call(
      RegisterUserParams(
        email: event.email,
        password: event.password,
        passwordConfirmation: event.passwordConfirmation,
        fcmToken: deviceToken,
      ),
    );

    await res.fold(
      (failure) async {
        _logger.e('Sign up failed: ${failure.message}');
        _closeLoadingIfOpen();
        _showError(failure.message);
      },
      (registerResponse) async {
        _logger.i('Sign up success: ${registerResponse.user}');
        _closeLoadingIfOpen();

        await _saveToken(registerResponse.token);

        if (registerResponse.user != null) {
          await _saveUserJson(registerResponse.user!.toJson());
        }
        if (event.context.mounted) {
          event.context.read<AccountBloc>().add(LoadAccount());
        }

        await _navigateToHome();
      },
    );
  }

  FutureOr<void> _signInWithGoogle(
    SignInWithGoogleEvent event,
    Emitter<SignUpState> emit,
  ) {}

  FutureOr<void> _signInWithFacebook(
    SignInWithFacebookEvent event,
    Emitter<SignUpState> emit,
  ) {}

  FutureOr<void> _signInWithApple(
    SignInWithAppleEvent event,
    Emitter<SignUpState> emit,
  ) {}
}
