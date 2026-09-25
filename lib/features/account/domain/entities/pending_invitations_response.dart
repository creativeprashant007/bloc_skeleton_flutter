class PendingInvitationsResponse {
  final bool success;
  final String message;
  final PendingInvitationsData data;

  const PendingInvitationsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PendingInvitationsResponse.fromJson(Map<String, dynamic> json) {
    return PendingInvitationsResponse(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: PendingInvitationsData.fromJson(
        Map<String, dynamic>.from(json['data'] as Map? ?? {}),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }
}

class PendingInvitationsData {
  final List<PendingInvitationData> pendingInvitations;

  const PendingInvitationsData({required this.pendingInvitations});

  factory PendingInvitationsData.fromJson(Map<String, dynamic> json) {
    return PendingInvitationsData(
      pendingInvitations: (json['pendingInvitations'] as List<dynamic>? ?? [])
          .map(
            (item) => PendingInvitationData.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pendingInvitations': pendingInvitations
          .map((item) => item.toJson())
          .toList(),
    };
  }
}

class PendingInvitationData {
  final int id;
  final String name;
  final String email;
  final String role;
  final int? branchId;
  final String branchName;
  final String invitedBy;
  final String status;
  final String createdAt;
  final String expiresAt;

  const PendingInvitationData({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.branchId,
    required this.branchName,
    required this.invitedBy,
    required this.status,
    required this.createdAt,
    required this.expiresAt,
  });

  factory PendingInvitationData.fromJson(Map<String, dynamic> json) {
    return PendingInvitationData(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      branchId: json['branch_id'] == null
          ? null
          : int.tryParse(json['branch_id'].toString()),
      branchName: json['branch_name']?.toString() ?? '',
      invitedBy: json['invited_by']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      expiresAt: json['expires_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'branch_id': branchId,
      'branch_name': branchName,
      'invited_by': invitedBy,
      'status': status,
      'created_at': createdAt,
      'expires_at': expiresAt,
    };
  }

  bool get isPending => status.toLowerCase().trim() == 'pending';

  bool get isExpired => status.toLowerCase().trim() == 'expired';

  bool get hasBranch => branchId != null && branchId != 0;

  String get branchDisplayName {
    final value = branchName.trim();

    if (value.isEmpty || value == '-') {
      return 'No branch assigned';
    }

    return value;
  }
}
