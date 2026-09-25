import 'dart:io';

import 'package:stock_control_master/shared/api_response.dart' show ApiResponse;

abstract class NetworkService {
  Future<bool> checkInternetConnection();
  Future<ApiResponse<dynamic>> get(String url, {Map<String, String>? headers});

  Future<ApiResponse<Map<String, dynamic>>> post(
    String url, {
    dynamic body,
    Map<String, String>? headers,
  });

  Future<ApiResponse<Map<String, dynamic>>> postFile({
    required String url,
    required String key,
    required List<File> files,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  });

  Future<ApiResponse<Map<String, dynamic>>> put(
    String url, {
    dynamic body,
    Map<String, String>? headers,
  });

  Future<ApiResponse<Map<String, dynamic>>> patch(
    String url, {
    dynamic body,
    Map<String, String>? headers,
  });

  Future<ApiResponse<Map<String, dynamic>>> patchFile({
    required String url,
    required String key,
    required File file,
    Map<String, String>? headers,
  });

  Future<ApiResponse<Map<String, dynamic>>> patchFiles({
    required String url,
    required List<MapEntry<String, File>>
    filesWithKeys, // List of file-key pairs
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  });

  Future<ApiResponse<Map<String, dynamic>>> delete(
    String url, {
    dynamic body,
    Map<String, String>? headers,
  });
}
