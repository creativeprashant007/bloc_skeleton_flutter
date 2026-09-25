import 'package:equatable/equatable.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object?> get props => [];
}

class LoadAccount extends AccountEvent {
  const LoadAccount();
}

class DarkModeChanged extends AccountEvent {
  final bool value;

  const DarkModeChanged(this.value);

  @override
  List<Object?> get props => [value];
}

class LogoutTapped extends AccountEvent {
  const LogoutTapped();
}

class LogoutCancelled extends AccountEvent {
  const LogoutCancelled();
}

class LogoutConfirmed extends AccountEvent {
  const LogoutConfirmed();
}

class EditProfileTapped extends AccountEvent {
  const EditProfileTapped();
}

class DocumentsTapped extends AccountEvent {
  const DocumentsTapped();
}

class PrivacyPolicyTapped extends AccountEvent {
  const PrivacyPolicyTapped();
}

class AddPeopleTap extends AccountEvent {
  const AddPeopleTap();
}

class SendInvitePressed extends AccountEvent {
  final String name;
  final String email;

  const SendInvitePressed({required this.name, required this.email});

  @override
  List<Object?> get props => [name, email];
}

class LoadPendingInvitations extends AccountEvent {
  const LoadPendingInvitations();
}

class ResendInvitationPressed extends AccountEvent {
  final int invitationId;

  const ResendInvitationPressed({required this.invitationId});

  @override
  List<Object?> get props => [invitationId];
}

class ClearAccountMessage extends AccountEvent {
  const ClearAccountMessage();
}

class ProfileImageChangeTapped extends AccountEvent {
  const ProfileImageChangeTapped();
}
