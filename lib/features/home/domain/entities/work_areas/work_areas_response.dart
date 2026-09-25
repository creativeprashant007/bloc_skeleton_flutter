class WorkAreaResponse {
  final bool status;
  final String message;
  final List<WorkAreaData> data;

  const WorkAreaResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory WorkAreaResponse.fromJson(Map<String, dynamic> json) {
    return WorkAreaResponse(
      status: _parseStatus(json['status'] ?? json['success']),
      message: json['message']?.toString() ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map(
            (item) =>
                WorkAreaData.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }

  static bool _parseStatus(dynamic value) {
    if (value == true) return true;

    final text = value?.toString().toLowerCase().trim() ?? '';

    return text == 'true' || text == 'success' || text == '1';
  }
}

class WorkAreaData {
  final int id;
  final int branchId;
  final String name;

  const WorkAreaData({
    required this.id,
    required this.branchId,
    required this.name,
  });

  factory WorkAreaData.fromJson(Map<String, dynamic> json) {
    return WorkAreaData(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      branchId: int.tryParse(json['branch_id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'branch_id': branchId, 'name': name};
  }
}
