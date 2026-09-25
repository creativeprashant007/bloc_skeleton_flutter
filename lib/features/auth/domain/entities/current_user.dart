class CurrentUser {
  final int id;
  final String name;
  final String email;

  final int companyId;
  final String companyName;

  final int branchId;
  final String branchName;

  final String role;

  /// user profile image / avatar
  final String image;

  const CurrentUser({
    required this.id,
    required this.name,
    required this.email,
    required this.companyId,
    required this.companyName,
    required this.branchId,
    required this.branchName,
    required this.role,
    required this.image,
  });

  factory CurrentUser.fromJson(Map<String, dynamic> json) {
    return CurrentUser(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',

      companyId: (json['company_id'] as num?)?.toInt() ?? 0,
      companyName: json['company_name']?.toString() ?? '',

      branchId: (json['branch_id'] as num?)?.toInt() ?? 0,
      branchName: json['branch_name']?.toString() ?? '',

      role: json['role']?.toString() ?? '',

      /// support both avatar & image keys
      image: json['image']?.toString() ?? json['avatar']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,

    "company_id": companyId,
    "company_name": companyName,

    "branch_id": branchId,
    "branch_name": branchName,

    "role": role,

    "image": image,
  };
}
