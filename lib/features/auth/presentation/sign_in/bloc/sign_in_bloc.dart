import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_control_master/features/account/presentation/bloc/account_bloc.dart';
import 'package:stock_control_master/features/account/presentation/bloc/account_event.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:stock_control_master/core/services/session_manager.dart'
    show SessionManager;
import 'package:stock_control_master/core/services/firebase/notification_service.dart'
    show NotificationService;
import 'package:stock_control_master/features/auth/domain/entities/current_user.dart'
    show CurrentUser;
import 'package:stock_control_master/core/configs/service/storage_service.dart';
import 'package:stock_control_master/core/constants/constant.dart';
import 'package:stock_control_master/core/locator.dart';
import 'package:stock_control_master/shared/widgets/dialogs/error_dialog.dart';
import 'package:stock_control_master/shared/widgets/dialogs/loading_dialog.dart';
import 'package:stock_control_master/features/auth/data/services/google_auth_service.dart';
import 'package:stock_control_master/features/auth/domain/params/login_params.dart';
import 'package:stock_control_master/features/auth/domain/usecases/login_usecase.dart';
import 'package:stock_control_master/features/auth/presentation/sign_up/sign_up_screen.dart';
import 'package:stock_control_master/core/services/dialog_and_sheet_service/dialog_and_sheet_service.dart';
import 'package:stock_control_master/core/services/navigation_service/navigation_service.dart';
import 'package:stock_control_master/features/index/presentation/view/index_screen.dart';
import 'sign_in_event.dart';
import 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc({
    StorageService? storageService,
    LoginUsecase? loginUsecase,
    GoogleAuthService? googleAuthService,
    NotificationService? notificationService,
  }) : _storage = storageService ?? StorageService(),
       _loginUsecase = loginUsecase ?? LoginUsecase(),
       _googleAuthService = googleAuthService ?? GoogleAuthService(),
       _notificationService = notificationService ?? NotificationService(),
       super(const SignInInitial()) {
    on<LoadRememberedCredentialsEvent>(_loadRememberedCredentials);
    on<RememberMeChangedEvent>(_rememberMeChanged);
    on<NavigateToSignUpEvent>(_navigateToSignUp);
    on<ForgotPasswordPressedEvent>(_forgotPasswordPressed);
    on<SubmitSignInEvent>(_submitSignIn);
    on<SignInWithGoogleEvent>(_signInWithGoogle);
    on<SignInWithFacebookEvent>(_signInWithFacebook);
    on<SignInWithAppleEvent>(_signInWithApple);
  }

  static const String _rememberMeKey = 'remember_me';
  static const String _rememberEmailKey = 'remember_email';
  static const String _rememberPasswordKey = 'remember_password';
  static const String _forgotPasswordUrl =
      'https://hrmaster.co.uk/forgot-password';

  final NotificationService _notificationService;

  final Logger _logger = Logger();

  final DialogAndSheetService _dialogService = locator<DialogAndSheetService>();
  final NavigationService _navigationService = locator<NavigationService>();

  final StorageService _storage;
  final LoginUsecase _loginUsecase;
  final GoogleAuthService _googleAuthService;

  bool _storageInitialized = false;

  Future<void> _ensureStorageInitialized() async {
    if (_storageInitialized) return;
    await _storage.init();
    _storageInitialized = true;
  }

  Future<void> _loadRememberedCredentials(
    LoadRememberedCredentialsEvent event,
    Emitter<SignInState> emit,
  ) async {
    await _ensureStorageInitialized();

    final rememberMe = _storage.getBool(_rememberMeKey) ?? true;
    final email = _storage.getString(_rememberEmailKey) ?? '';
    final password = _storage.getString(_rememberPasswordKey) ?? '';

    emit(
      SignInInitial(
        rememberMe: rememberMe,
        rememberedEmail: rememberMe ? email : '',
        rememberedPassword: rememberMe ? password : '',
      ),
    );
  }

  Future<void> _rememberMeChanged(
    RememberMeChangedEvent event,
    Emitter<SignInState> emit,
  ) async {
    await _ensureStorageInitialized();

    await _storage.setBool(_rememberMeKey, event.value);

    if (!event.value) {
      await _storage.remove(_rememberEmailKey);
      await _storage.remove(_rememberPasswordKey);
    }

    final current = state;
    if (current is SignInInitial) {
      emit(current.copyWith(rememberMe: event.value));
    }
  }

  Future<void> _saveRememberedCredentials({
    required String email,
    required String password,
  }) async {
    await _ensureStorageInitialized();

    final current = state;
    final rememberMe = current is SignInInitial ? current.rememberMe : true;

    await _storage.setBool(_rememberMeKey, rememberMe);

    if (rememberMe) {
      await _storage.setString(_rememberEmailKey, email);
      await _storage.setString(_rememberPasswordKey, password);
    } else {
      await _storage.remove(_rememberEmailKey);
      await _storage.remove(_rememberPasswordKey);
    }
  }

  void _showLoading(String message) {
    _dialogService.showAppDialog(child: LoadingDialog(message: message));
  }

  void _closeLoadingIfOpen() {
    _navigationService.back();
  }

  void _showError(String message) {
    _dialogService.showAppDialog(child: ErrorDialog(errorMessage: message));
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
    _navigationService.navigateToNamedAndRemoveUntil(IndexScreen.routeName);
  }

  FutureOr<void> _navigateToSignUp(
    NavigateToSignUpEvent event,
    Emitter<SignInState> emit,
  ) {
    _navigationService.navigateToNamed(SignUpScreen.routeName);
  }

  Future<void> _forgotPasswordPressed(
    ForgotPasswordPressedEvent event,
    Emitter<SignInState> emit,
  ) async {
    final uri = Uri.parse(_forgotPasswordUrl);

    try {
      final canOpen = await canLaunchUrl(uri);

      if (!canOpen) {
        _showError('Unable to open forgot password page.');
        return;
      }

      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e, stackTrace) {
      _logger.e(
        'Forgot password launch failed',
        error: e,
        stackTrace: stackTrace,
      );
      _showError('Unable to open forgot password page.');
    }
  }

  Future<void> _submitSignIn(
    SubmitSignInEvent event,
    Emitter<SignInState> emit,
  ) async {
    await _ensureStorageInitialized();
    final deviceToken = await _notificationService.getDeviceToken();

    _showLoading('Signing in...');

    final email = event.email.trim();
    final password = event.password.trim();

    final res = await _loginUsecase.call(
      LoginParams(email: email, password: password, fcmToken: deviceToken),
    );

    await res.fold(
      (failure) async {
        _logger.e('Login failed: ${failure.message}');
        _closeLoadingIfOpen();
        _showError(failure.message);
      },
      (loginResponse) async {
        _logger.i('Login success: ${loginResponse.user}');
        _closeLoadingIfOpen();

        await _saveRememberedCredentials(email: email, password: password);
        await _saveToken(loginResponse.token);

        if (loginResponse.user != null) {
          await _saveUserJson(loginResponse.user!.toJson());
        }

        if (event.context.mounted) {
          event.context.read<AccountBloc>().add(LoadAccount());
        }

        await _navigateToHome();
      },
    );
  }

  Future<void> _signInWithGoogle(
    SignInWithGoogleEvent event,
    Emitter<SignInState> emit,
  ) async {
    await _ensureStorageInitialized();
    _showLoading('Signing in with Google...');

    try {
      final userCredential = await _googleAuthService.signInWithGoogle();
      final user = userCredential.user;

      _closeLoadingIfOpen();

      if (user == null) {
        _showError('Google sign-in failed');
        return;
      }

      final idToken = await user.getIdToken();

      await _saveToken(idToken);

      await _saveUserJson({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'photoURL': user.photoURL,
        'phoneNumber': user.phoneNumber,
      });

      await _navigateToHome();
    } catch (e, stackTrace) {
      _logger.e('Google sign-in failed', error: e, stackTrace: stackTrace);
      _closeLoadingIfOpen();
      _showError(e.toString());
    }
  }

  FutureOr<void> _signInWithFacebook(
    SignInWithFacebookEvent event,
    Emitter<SignInState> emit,
  ) {
    // TODO: implement Facebook sign-in
  }

  FutureOr<void> _signInWithApple(
    SignInWithAppleEvent event,
    Emitter<SignInState> emit,
  ) {
    // TODO: implement Apple sign-in
  }
}
