// features/auth/domain/entities/user_data.dart

class UserData {
  final int id;
  final String name;
  final String email;
  final String phone;

  final String? userType;
  final String? status;

  /// API avatar/base64/image url
  final String? avatar;

  /// Alias for shared widgets usage
  final String? image;

  final String? companyName;
  final String? branchName;

  final int? companyId;
  final int? branchId;
  final String? role;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.userType,
    this.status,
    this.avatar,
    this.image,
    this.companyName,
    this.branchName,
    this.companyId,
    this.branchId,
    this.role,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    final avatarValue =
        json['avatar']?.toString() ?? json['image']?.toString() ?? '';

    return UserData(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      userType: json['user_type']?.toString(),
      status: json['status']?.toString(),

      /// both support
      avatar: avatarValue,
      image: avatarValue,

      companyName: json['company_name']?.toString(),
      branchName: json['branch_name']?.toString(),

      companyId: (json['company_id'] as num?)?.toInt(),
      branchId: (json['branch_id'] as num?)?.toInt(),
      role: json['role']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'user_type': userType,
      'status': status,

      'avatar': avatar,
      'image': image,

      'company_name': companyName,
      'branch_name': branchName,

      'company_id': companyId,
      'branch_id': branchId,
      'role': role,
    };
  }
}
