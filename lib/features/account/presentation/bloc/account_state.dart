import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show ThemeMode;

import 'package:stock_control_master/features/account/domain/entities/pending_invitations_response.dart'
    show PendingInvitationData;

class AccountState extends Equatable {
  final String name;
  final String email;
  final String phone;
  final String avatarAsset;
  final String? avatarUrl;

  final bool isDarkMode;
  final bool showLogoutDialog;
  final bool isLoggedOut;
  final bool isManager;
  final bool isLoading;
  final bool isUploadingImage;

  final bool isSendingInvite;
  final bool isPendingInvitationsLoading;
  final int resendingInvitationId;
  final List<PendingInvitationData> pendingInvitations;
  final String? accountMessage;

  const AccountState({
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarAsset,
    this.avatarUrl,
    required this.isDarkMode,
    this.showLogoutDialog = false,
    this.isLoggedOut = false,
    this.isManager = false,
    this.isLoading = false,
    this.isUploadingImage = false,
    this.isSendingInvite = false,
    this.isPendingInvitationsLoading = false,
    this.resendingInvitationId = 0,
    this.pendingInvitations = const [],
    this.accountMessage,
  });

  ThemeMode get themeMode => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  AccountState copyWith({
    String? name,
    String? email,
    String? phone,
    String? avatarAsset,
    String? avatarUrl,
    bool? isDarkMode,
    bool? showLogoutDialog,
    bool? isLoggedOut,
    bool? isManager,
    bool? isLoading,
    bool? isUploadingImage,
    bool? isSendingInvite,
    bool? isPendingInvitationsLoading,
    int? resendingInvitationId,
    List<PendingInvitationData>? pendingInvitations,
    String? accountMessage,
    bool clearAccountMessage = false,
  }) {
    return AccountState(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarAsset: avatarAsset ?? this.avatarAsset,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      showLogoutDialog: showLogoutDialog ?? this.showLogoutDialog,
      isLoggedOut: isLoggedOut ?? this.isLoggedOut,
      isManager: isManager ?? this.isManager,
      isLoading: isLoading ?? this.isLoading,
      isUploadingImage: isUploadingImage ?? this.isUploadingImage,
      isSendingInvite: isSendingInvite ?? this.isSendingInvite,
      isPendingInvitationsLoading:
          isPendingInvitationsLoading ?? this.isPendingInvitationsLoading,
      resendingInvitationId:
          resendingInvitationId ?? this.resendingInvitationId,
      pendingInvitations: pendingInvitations ?? this.pendingInvitations,
      accountMessage: clearAccountMessage
          ? null
          : accountMessage ?? this.accountMessage,
    );
  }

  @override
  List<Object?> get props => [
    name,
    email,
    phone,
    avatarAsset,
    avatarUrl,
    isDarkMode,
    showLogoutDialog,
    isLoggedOut,
    isManager,
    isLoading,
    isUploadingImage,
    isSendingInvite,
    isPendingInvitationsLoading,
    resendingInvitationId,
    pendingInvitations,
    accountMessage,
  ];
}
