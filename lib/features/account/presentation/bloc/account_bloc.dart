import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_control_master/features/account/domain/usecase/invite_user_usecase.dart';
import 'package:stock_control_master/features/account/domain/usecase/user_image_usecase.dart';
import 'package:stock_control_master/features/account/presentation/view/add_user.dart';
import 'package:stock_control_master/shared/usecase.dart';
import 'package:image_cropper/image_cropper.dart'
    show
        CroppedFile,
        ImageCompressFormat,
        ImageCropper,
        AndroidUiSettings,
        IOSUiSettings;
import 'package:image_picker/image_picker.dart'
    show ImagePicker, ImageSource, XFile;
import 'package:logger/logger.dart';

import 'package:stock_control_master/core/services/session_manager.dart'
    show SessionManager;
import 'package:stock_control_master/features/auth/domain/entities/current_user.dart'
    show CurrentUser;
import 'package:stock_control_master/features/account/domain/params/invite_user_request_params.dart'
    show InviteUserRequestParams;
import 'package:stock_control_master/features/account/domain/params/profile_image_update_params.dart'
    show UpdateProfileImageParams;
import 'package:stock_control_master/features/account/domain/params/resend_invitations_params.dart'
    show ResendInvitationParams;
import 'package:stock_control_master/features/account/domain/usecase/get_pending_invitations.dart'
    show GetPendingInvitationsUseCase;
import 'package:stock_control_master/features/account/domain/usecase/resend_invitation_usecase.dart'
    show ResendInvitationUseCase;
import 'package:stock_control_master/features/account/domain/usecase/user_image_update_usecase.dart'
    show UserImageUpdateUseCase;

import 'package:stock_control_master/features/auth/data/services/google_auth_service.dart'
    show GoogleAuthService;
import 'package:stock_control_master/core/configs/service/storage_service.dart';
import 'package:stock_control_master/core/locator.dart';
import 'package:stock_control_master/shared/widgets/organisms/loading_dialog.dart';
import 'package:stock_control_master/features/auth/presentation/view/sign_in_screen.dart';
import 'package:stock_control_master/core/services/dialog_and_sheet_service/dialog_and_sheet_service.dart';
import 'package:stock_control_master/core/services/navigation_service/navigation_service.dart';

import 'package:stock_control_master/core/constants/app_assets.dart';
import 'package:stock_control_master/features/account/presentation/bloc/account_event.dart';
import 'package:stock_control_master/features/account/presentation/bloc/account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc({
    NavigationService? navigationService,
    DialogAndSheetService? dialogService,
    StorageService? storageService,
    GoogleAuthService? googleAuthService,
    UserImageUseCase? userImageUseCase,
    UserImageUpdateUseCase? userImageUpdateUseCase,
    GetPendingInvitationsUseCase? getPendingInvitationsUseCase,
    ResendInvitationUseCase? resendInvitationUseCase,
    InviteUserUseCase? inviteUserUseCase,
  }) : _navigationService = navigationService ?? locator<NavigationService>(),
       _getPendingInvitationsUseCase =
           getPendingInvitationsUseCase ?? GetPendingInvitationsUseCase(),
       _resendInvitationUseCase =
           resendInvitationUseCase ?? ResendInvitationUseCase(),
       _dialogService = dialogService ?? locator<DialogAndSheetService>(),
       _storageService = storageService ?? StorageService(),
       _googleAuthService = googleAuthService ?? GoogleAuthService(),
       _userImageUseCase = userImageUseCase ?? UserImageUseCase(),
       _userImageUpdateUseCase =
           userImageUpdateUseCase ?? UserImageUpdateUseCase(),
       _inviteUserUseCase = inviteUserUseCase ?? InviteUserUseCase(),
       super(
         const AccountState(
           name: _defaultName,
           email: _defaultEmail,
           phone: _defaultPhone,
           avatarAsset: AppAssets.defaultProfile,
           avatarUrl: '',
           isDarkMode: false,
         ),
       ) {
    on<LoadAccount>(_onLoadAccount);
    on<DarkModeChanged>(_onDarkModeChanged);
    on<LogoutTapped>(_onLogoutTapped);
    on<LogoutCancelled>(_onLogoutCancelled);
    on<LogoutConfirmed>(_onLogoutConfirmed);
    on<EditProfileTapped>(_onEditProfileTapped);
    on<DocumentsTapped>(_onDocumentsTapped);
    on<PrivacyPolicyTapped>(_onPrivacyPolicyTapped);
    on<AddPeopleTap>(_onAddPeopleTap);
    on<SendInvitePressed>(_onSendInvitePressed);
    on<ProfileImageChangeTapped>(_onProfileImageChangeTapped);
    on<LoadPendingInvitations>(_onLoadPendingInvitations);
    on<ResendInvitationPressed>(_onResendInvitationPressed);
    on<ClearAccountMessage>(_onClearAccountMessage);
  }

  static const String _defaultName = 'User';
  static const String _defaultEmail = 'user@domain.com';
  static const String _defaultPhone = '+44';
  static const String _themeKey = 'is_dark_mode';
  final GetPendingInvitationsUseCase _getPendingInvitationsUseCase;
  final ResendInvitationUseCase _resendInvitationUseCase;
  final NavigationService _navigationService;
  final DialogAndSheetService _dialogService;
  final StorageService _storageService;
  final GoogleAuthService _googleAuthService;
  final UserImageUseCase _userImageUseCase;
  final UserImageUpdateUseCase _userImageUpdateUseCase;
  final InviteUserUseCase _inviteUserUseCase;
  final Logger _logger = Logger();
  final ImagePicker _imagePicker = ImagePicker();
  bool _storageInitialized = false;

  Future<void> _ensureStorageInitialized() async {
    if (_storageInitialized) return;
    await _storageService.init();
    _storageInitialized = true;
  }

  void _showLoader(String message) {
    _dialogService.showAppDialog(child: LoadingDialog(message: message));
  }

  void _hideLoader() {
    _navigationService.back();
  }

  Future<void> _onLoadAccount(
    LoadAccount event,
    Emitter<AccountState> emit,
  ) async {
    try {
      await _ensureStorageInitialized();
      _logger.e("Here is image function");
      final userImageResult = await _userImageUseCase.call(NoParams());
      userImageResult.fold(
        (failure) {
          _logger.e("Here is image Image failure");
        },
        (success) {
          _logger.e("Here is image Image success");
        },
      );

      final userMap = await _storageService.getUserData();
      final bool isDarkMode = _storageService.getBool(_themeKey);

      if (userMap == null || userMap.isEmpty) {
        emit(_fallbackState().copyWith(isDarkMode: isDarkMode));
        return;
      }
      final String role =
          (userMap['role'] as String?)?.trim().toLowerCase() ?? '';

      final bool isManager =
          role == 'branch manager' ||
          role == 'branch_manager' ||
          role == 'company admin' ||
          role == 'company_admin';

      _logger.i(' now i change the branch  userMap: $userMap $isManager');

      final String displayName =
          (userMap['displayName'] as String?)?.trim() ??
          (userMap['name'] as String?)?.trim() ??
          _defaultName;

      final String email =
          (userMap['email'] as String?)?.trim() ?? _defaultEmail;

      final String phone =
          (userMap['phoneNumber'] as String?)?.trim() ??
          (userMap['phone'] as String?)?.trim() ??
          _defaultPhone;

      final String photoUrl =
          (userMap['photoURL'] as String?)?.trim() ??
          (userMap['avatar'] as String?)?.trim() ??
          (userMap['image'] as String?)?.trim() ??
          '';

      _logger.i("where is the image: $photoUrl");

      emit(
        state.copyWith(
          name: displayName.isNotEmpty ? displayName : _defaultName,
          email: email.isNotEmpty ? email : _defaultEmail,
          phone: phone.isNotEmpty ? phone : _defaultPhone,
          avatarUrl: photoUrl,
          avatarAsset: "",
          isDarkMode: isDarkMode,
          isManager: isManager,
        ),
      );
    } catch (e, stackTrace) {
      _logger.e('Error loading account', error: e, stackTrace: stackTrace);
      emit(_fallbackState().copyWith(isDarkMode: false));
    }
  }

  Future<void> _onLoadPendingInvitations(
    LoadPendingInvitations event,
    Emitter<AccountState> emit,
  ) async {
    emit(
      state.copyWith(
        isPendingInvitationsLoading: true,
        clearAccountMessage: true,
      ),
    );

    final result = await _getPendingInvitationsUseCase.call(NoParams());

    result.fold(
      (failure) {
        _logger.e('Pending invitations failed: ${failure.message}');

        emit(
          state.copyWith(
            isPendingInvitationsLoading: false,
            pendingInvitations: const [],
            accountMessage: failure.message,
          ),
        );
      },
      (success) {
        emit(
          state.copyWith(
            isPendingInvitationsLoading: false,
            pendingInvitations: success.data.pendingInvitations,
            accountMessage: success.data.pendingInvitations.isEmpty
                ? 'No pending invitations found.'
                : null,
            clearAccountMessage: success.data.pendingInvitations.isNotEmpty,
          ),
        );
      },
    );
  }

  Future<void> _onResendInvitationPressed(
    ResendInvitationPressed event,
    Emitter<AccountState> emit,
  ) async {
    if (event.invitationId <= 0) {
      emit(state.copyWith(accountMessage: 'Invalid invitation.'));
      return;
    }

    emit(
      state.copyWith(
        resendingInvitationId: event.invitationId,
        clearAccountMessage: true,
      ),
    );

    final result = await _resendInvitationUseCase.call(
      ResendInvitationParams(invitationId: event.invitationId),
    );

    result.fold(
      (failure) {
        _logger.e('Resend invitation failed: ${failure.message}');

        emit(
          state.copyWith(
            resendingInvitationId: 0,
            accountMessage: failure.message,
          ),
        );
      },
      (success) {
        emit(
          state.copyWith(
            resendingInvitationId: 0,
            accountMessage: success.message.isEmpty
                ? 'Invitation resent successfully.'
                : success.message,
          ),
        );

        add(const LoadPendingInvitations());
      },
    );
  }

  void _onClearAccountMessage(
    ClearAccountMessage event,
    Emitter<AccountState> emit,
  ) {
    emit(state.copyWith(clearAccountMessage: true));
  }

  Future<void> _onDarkModeChanged(
    DarkModeChanged event,
    Emitter<AccountState> emit,
  ) async {
    await _ensureStorageInitialized();
    await _storageService.setBool(_themeKey, event.value);

    _logger.i('Theme changed: ${event.value ? 'dark' : 'light'}');

    emit(state.copyWith(isDarkMode: event.value));
  }

  void _onLogoutTapped(LogoutTapped event, Emitter<AccountState> emit) {
    emit(state.copyWith(showLogoutDialog: true));
  }

  void _onLogoutCancelled(LogoutCancelled event, Emitter<AccountState> emit) {
    emit(state.copyWith(showLogoutDialog: false));
  }

  void _onDocumentsTapped(DocumentsTapped event, Emitter<AccountState> emit) {
    // _navigationService.navigateToNamed(UserDocumentsPage.routeName);
  }

  Future<void> _onPrivacyPolicyTapped(
    PrivacyPolicyTapped event,
    Emitter<AccountState> emit,
  ) async {
    // _navigationService.navigateToNamed(PrivacyPolicyPage.routeName);
  }

  Future<void> _onAddPeopleTap(
    AddPeopleTap event,
    Emitter<AccountState> emit,
  ) async {
    _navigationService.navigateToNamed(AddPeoplePage.routeName);
  }

  Future<void> _onLogoutConfirmed(
    LogoutConfirmed event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(showLogoutDialog: false));

    try {
      await _ensureStorageInitialized();

      final startTime = DateTime.now();

      try {
        await _googleAuthService.signOut();
      } catch (e) {
        _logger.w('Google sign out failed: $e');
      }

      await _storageService.logout();

      final elapsed = DateTime.now().difference(startTime);
      _showLoader('Logging out...');
      if (elapsed < const Duration(seconds: 1)) {
        await Future.delayed(const Duration(seconds: 1) - elapsed);
      }

      _hideLoader();

      emit(state.copyWith(isLoggedOut: true));

      _navigationService.navigateToNamedAndRemoveUntil(SignInScreen.routeName);
    } catch (e, stackTrace) {
      _logger.e('Logout failed', error: e, stackTrace: stackTrace);

      _hideLoader();
      emit(state.copyWith(showLogoutDialog: false));
    }
  }

  Future<void> _onEditProfileTapped(
    EditProfileTapped event,
    Emitter<AccountState> emit,
  ) async {
    // _navigationService.navigateToNamed(EditProfilePage.routeName);
  }

  AccountState _fallbackState() {
    return state.copyWith(
      name: _defaultName,
      email: _defaultEmail,
      phone: _defaultPhone,
      avatarUrl: '',
      avatarAsset: "",
    );
  }

  Future<void> _onSendInvitePressed(
    SendInvitePressed event,
    Emitter<AccountState> emit,
  ) async {
    final name = event.name.trim();
    final email = event.email.trim();

    if (name.isEmpty) {
      emit(state.copyWith(accountMessage: 'Name is required.'));
      return;
    }

    if (email.isEmpty) {
      emit(state.copyWith(accountMessage: 'Email is required.'));
      return;
    }

    try {
      emit(state.copyWith(isSendingInvite: true, clearAccountMessage: true));

      final result = await _inviteUserUseCase.call(
        InviteUserRequestParams(name: name, email: email),
      );

      result.fold(
        (failure) {
          _logger.e('Invite user failed: ${failure.message}');

          emit(
            state.copyWith(
              isSendingInvite: false,
              accountMessage: failure.message,
            ),
          );
        },
        (success) {
          _logger.i('Invite user success: ${success.message}');

          emit(
            state.copyWith(
              isSendingInvite: false,
              accountMessage: success.message.isEmpty
                  ? 'Invitation sent successfully.'
                  : success.message,
            ),
          );

          add(const LoadPendingInvitations());
        },
      );
    } catch (e, st) {
      _logger.e('Invite user error', error: e, stackTrace: st);

      emit(
        state.copyWith(
          isSendingInvite: false,
          accountMessage: 'Something went wrong: $e',
        ),
      );
    }
  }

  Future<void> _onProfileImageChangeTapped(
    ProfileImageChangeTapped event,
    Emitter<AccountState> emit,
  ) async {
    try {
      final XFile? pickedImage = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50, // 0-100 (lower = smaller file)
        maxWidth: 800,
        maxHeight: 800,
      );

      if (pickedImage == null) return;

      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedImage.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 50,

        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Profile Photo',
            lockAspectRatio: true,
            hideBottomControls: false,
          ),
          IOSUiSettings(
            title: 'Crop Profile Photo',
            aspectRatioLockEnabled: true,
          ),
        ],
      );

      if (croppedFile == null) return;

      emit(state.copyWith(isUploadingImage: true));

      final result = await _userImageUpdateUseCase.call(
        UpdateProfileImageParams(image: XFile(croppedFile.path)),
      );

      result.fold(
        (failure) {
          _logger.e('Profile image update failed: ${failure.message}');
          emit(state.copyWith(isUploadingImage: false));
        },
        (success) async {
          _logger.e('Profile image update : ${success.user!.image}');

          emit(
            state.copyWith(
              avatarUrl: success.user!.image!,
              avatarAsset: '',
              isUploadingImage: false,
            ),
          );
          _saveUserJson(success.user!.toJson());
        },
      );
    } catch (e, st) {
      _logger.e('Image pick/update failed', error: e, stackTrace: st);
      emit(state.copyWith(isUploadingImage: false));
    }
  }

  Future<void> _saveUserJson(Map<String, dynamic> userJson) async {
    final user = CurrentUser.fromJson(userJson);
    await SessionManager.instance.saveUser(user);
  }
}
