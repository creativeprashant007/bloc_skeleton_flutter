import 'package:equatable/equatable.dart';

/// A safe API wrapper:
/// - data can be Map / List / String / null
/// - never forces Map<String,dynamic>
/// - you can still ask for typed forms using helpers
class ApiResponse<T> extends Equatable {
  final T? data;
  final String? message;
  final dynamic status;

  const ApiResponse({this.data, this.message, this.status});

  bool get hasData => data != null;

  /// If your API uses success:true/false or status:true/false
  bool get isSuccess {
    if (status is bool) return status as bool;
    if (status is String) return (status as String).toLowerCase() == 'success';
    if (data is Map) {
      final m = data as Map;
      final s = m['success'];
      if (s is bool) return s;
    }
    return false;
  }

  /// Convenience: safely read data as Map
  Map<String, dynamic>? asMap() {
    final d = data;
    if (d is Map<String, dynamic>) return d;
    if (d is Map) return d.cast<String, dynamic>();
    return null;
  }

  /// Convenience: safely read data as List
  List<dynamic>? asList() {
    final d = data;
    if (d is List) return d;
    return null;
  }

  /// Convenience: safely read data as List<E>
  List<E>? asListOf<E>() {
    final list = asList();
    if (list == null) return null;
    try {
      return list.cast<E>();
    } catch (_) {
      return null;
    }
  }

  /// Factory that can parse common backend shapes:
  /// 1) {success, message, data}
  /// 2) {status, message, data}
  /// 3) {message, data}
  /// 4) []  -> treated as data=list
  /// 5) "..." -> treated as message/data string
  factory ApiResponse.fromRaw(dynamic raw) {
    try {
      if (raw == null) {
        return const ApiResponse(data: null, message: null, status: null);
      }

      // If backend returns a list directly
      if (raw is List) {
        return ApiResponse<T>(data: raw as T);
      }

      // If backend returns a map wrapper
      if (raw is Map) {
        final map = raw.cast<String, dynamic>();

        final dynamic status = map['status'] ?? map['success'];
        final String? message = map['message']?.toString();

        // Many APIs use "data" key, but sometimes payload is the whole map
        final dynamic payload = map.containsKey('data') ? map['data'] : map;

        // payload can be List/Map/String/etc.
        return ApiResponse<T>(
          data: payload as T?,
          message: message,
          status: status,
        );
      }

      // If backend returns string directly
      if (raw is String) {
        return ApiResponse<T>(data: raw as T, message: raw, status: null);
      }

      // Fallback
      return ApiResponse<T>(data: raw as T, message: null, status: null);
    } catch (_) {
      // If casting fails, return as dynamic payload
      return ApiResponse<T>(data: raw as T?, message: null, status: null);
    }
  }

  ApiResponse<T> copyWith({
    T? data,
    String? message,
    dynamic status,
    bool clearData = false,
  }) {
    return ApiResponse<T>(
      data: clearData ? null : (data ?? this.data),
      message: message ?? this.message,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [data, message, status];

  @override
  String toString() =>
      'ApiResponse(status: $status, message: $message, data: $data)';
}
