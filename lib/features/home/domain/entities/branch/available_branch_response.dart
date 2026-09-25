class AvailableBranchResponse {
  final bool status;
  final String message;
  final List<AvailableBranch> data;

  const AvailableBranchResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AvailableBranchResponse.fromJson(Map<String, dynamic> json) {
    return AvailableBranchResponse(
      status: json['status']?.toString() == "success" || json['status'] == true
          ? true
          : false,
      message: json['message']?.toString() ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => AvailableBranch.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class AvailableBranch {
  final int companyId;
  final String companyName;
  final int branchId;
  final String branchName;
  final String role;

  const AvailableBranch({
    required this.companyId,
    required this.companyName,
    required this.branchId,
    required this.branchName,
    required this.role,
  });

  factory AvailableBranch.fromJson(Map<String, dynamic> json) {
    return AvailableBranch(
      companyId: int.tryParse(json['company_id']?.toString() ?? '') ?? 0,
      companyName: json['company_name']?.toString() ?? '',
      branchId: int.tryParse(json['branch_id']?.toString() ?? '') ?? 0,
      branchName: json['branch_name']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
    );
  }
}
