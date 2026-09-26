import 'dart:convert';

import 'dart:io';

import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:stock_control_master/core/constants/constant.dart';
import 'package:stock_control_master/shared/api_response.dart' show ApiResponse;
import 'package:stock_control_master/shared/failure.dart' show Failure;
import 'package:stock_control_master/core/services/network_service/auth_interceptor.dart'
    show AuthInterceptor;

import 'package:logger/logger.dart';

import 'package:stock_control_master/core/services/network_service/network_service.dart';
import 'package:stock_control_master/core/services/network_service/network_logger.dart';

class INetworkService extends NetworkService {
  Dio _dio = Dio();
  final _logger = Logger();

  final _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Connection': 'keep-alive',
  };

  INetworkService() {
    _dio = Dio();
    _dio.options.validateStatus = (status) {
      Logger().i("Status code: $status, ${status != null && status < 500}");
      return true;
    };
    _dio.options.connectTimeout = const Duration(seconds: 60);
    _dio.options.receiveTimeout = const Duration(seconds: 60);
    _dio.options.sendTimeout = const Duration(seconds: 60);
    _dio.options.baseUrl = AppConstants.SERVER_API_URL;

    _dio.interceptors.addAll([
      AuthInterceptor(),
      NetworkLoggerInterceptor(),
      AwesomeDioInterceptor(logRequestHeaders: true, logResponseHeaders: true),
    ]);
  }

  @override
  Future<bool> checkInternetConnection() async {
    try {
      final List<ConnectivityResult> connectivityResult = await (Connectivity()
          .checkConnectivity());

      // This condition is for demo purposes only to explain every connection type.
      // Use conditions which work for your requirements.
      if (connectivityResult.contains(ConnectivityResult.mobile)) {
        return true;
      } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
        return true;
      } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
        return true;
      } else if (connectivityResult.contains(ConnectivityResult.other)) {
        return true;
      } else if (connectivityResult.contains(ConnectivityResult.none)) {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> delete(
    String url, {
    dynamic body,
    Map<String, String>? headers,
  }) async {
    try {
      if (headers != null) {
        _headers.addAll(headers);
      }
      final res = await _dio.delete(
        url,
        data: body,
        options: Options(headers: _headers),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        return ApiResponse(data: res.data);
      }
      throw Failure(res.statusMessage!);
    } on DioException catch (e) {
      throw convertException(e);
    } catch (e) {
      _logger.e(e.toString());
      throw Failure(e.toString());
    }
  }

  @override
  Future<ApiResponse<dynamic>> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    _logger.i("received Get url is $url");

    try {
      if (headers != null) {
        _headers.addAll(headers);
      }

      final res = await _dio.get(
        url,
        options: Options(headers: _headers, method: 'GET'),
      );

      _logger.i(
        "Get Response: status code ${res.statusCode}  ${res.data.toString()}",
      );

      // ✅ success codes
      if (res.statusCode == 200 || res.statusCode == 201) {
        dynamic raw = res.data;

        // If backend sends string, decode it
        if (raw is String) {
          _logger.i("Raw is string ${res.statusCode}  ${res.data.toString()}");
          raw = raw.isEmpty ? {} : jsonDecode(raw);
        }

        // Case A: Map wrapper {success, message, data}
        if (raw is Map) {
          _logger.i("Raw is map ${res.statusCode}  ${res.data.toString()}");
          final map = raw.cast<String, dynamic>();
          return ApiResponse<dynamic>(
            data: map.containsKey('data') ? map['data'] : map,
            message: map['message']?.toString(),
            status: map['success'] ?? map['status'],
          );
        }

        // Case B: list directly returned
        if (raw is List) {
          return ApiResponse<dynamic>(data: raw, message: null, status: true);
        }

        // Case C: anything else
        return ApiResponse<dynamic>(data: raw, message: null, status: true);
      }

      // ❌ error codes: try to read message safely
      dynamic rawErr = res.data;
      if (rawErr is String) {
        rawErr = rawErr.isEmpty ? {} : jsonDecode(rawErr);
      }

      if (rawErr is Map && rawErr['message'] != null) {
        throw Failure(
          rawErr['message'].toString(),
          extraData: (rawErr).cast<String, dynamic>(),
        );
      }

      throw Failure(res.statusMessage ?? "Request failed", extraData: rawErr);
    } on DioException catch (e) {
      _logger.e(e.message);
      throw convertException(e);
    } on Failure catch (e) {
      throw Failure(e.message, extraData: e.extraData);
    } catch (e) {
      _logger.e(e.toString());
      throw Failure(e.toString());
    }
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> put(
    String url, {
    dynamic body,
    Map<String, String>? headers,
  }) async {
    _logger.i("received url is $url");
    try {
      if (headers != null) {
        _headers.addAll(headers);
      }

      Logger().i("Set put data: $body");
      final res = await _dio.put(
        url,
        data: body,
        options: Options(headers: _headers),
      );

      Logger().i("Put Response: ${res.data.toString()}");

      if (res.statusCode == 200 || res.statusCode == 201) {
        if (res.data is String) {
          return ApiResponse(
            data: jsonDecode(res.data)["data"] ?? res.data,
            message: res.data["message"],
            status: res.data["success"],
          );
        } else {
          return ApiResponse(
            data: res.data["data"] ?? res.data,
            message: res.data["message"],
            status: res.data["success"],
          );
        }
      }
      throw Failure(res.statusMessage!, extraData: res.data);
    } on DioException catch (e) {
      throw convertException(e);
    } catch (e) {
      _logger.e(e.toString());
      throw Failure(e.toString());
    }
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> post(
    String url, {
    dynamic body,
    Map<String, String>? headers,
  }) async {
    _logger.i("received post url is $url");
    try {
      if (headers != null) {
        _headers.addAll(headers);
      }
      Logger().i("Set post data: $body");
      final res = await _dio.post(
        url,
        data: body,
        options: Options(headers: _headers),
      );

      _logger.d("Post Response: $res");

      if (res.statusCode == 200 ||
          res.statusCode == 201 ||
          res.statusCode == 202) {
        if (res.data is String) {
          return ApiResponse(
            data: jsonDecode(res.data) ?? res,
            message: jsonDecode(res.data)["message"],
            status: jsonDecode(res.data)["success"],
          );
        } else {
          return ApiResponse(
            data: res.data ?? res.data,
            message: res.data['message'],
            status: res.data['status'],
          );
        }
      } else if (res.data["message"] != null) {
        throw Failure(res.data["message"]);
      }
      throw Failure(res.statusMessage!);
    } on AssertionError catch (e) {
      _logger.e(e.toString());
      throw Failure(e.toString());
    } on TypeError catch (e) {
      _logger.e(e.toString());
      throw Failure("An unexpected error occurred");
    } on DioException catch (e) {
      throw convertException(e);
    } on Failure catch (e) {
      throw Failure(e.message);
    } catch (e) {
      _logger.e(e.toString());
      throw Failure("Error ${e.runtimeType} ${e.toString()}");
    }
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> postFile({
    required String url,
    required String key,
    required List<File> files,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      if (headers != null) {
        _headers.addAll(headers);
      }

      List<MultipartFile> multipartFiles = [];
      for (var file in files) {
        String fileName = file.path.split('/').last;
        multipartFiles.add(
          await MultipartFile.fromFile(file.path, filename: fileName),
        );
      }

      //if body is null, create a new map
      body ??= {};

      body[key] = multipartFiles;

      FormData formData = FormData.fromMap(body);

      Logger().i("Set post data: ${formData.fields}");

      final res = await _dio.post(
        url,
        data: formData,
        options: Options(headers: _headers),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        return ApiResponse(data: res.data);
      }
      throw Failure(res.statusMessage!);
    } on DioException catch (e) {
      throw convertException(e);
    } catch (e) {
      _logger.e(e.toString());
      throw Failure(e.toString());
    }
  }

  Failure convertException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return const Failure("Connection Timed Out");
      case DioExceptionType.sendTimeout:
        return const Failure("Connection Timed Out");
      case DioExceptionType.receiveTimeout:
        return const Failure("Connection Timed Out");
      case DioExceptionType.badResponse:
        return Failure(
          e.response?.data['message'] ?? e.response?.data['errors'],
        );
      case DioExceptionType.cancel:
        return Failure(
          e.response?.data['message'] ?? e.response?.data['errors'],
        );
      case DioExceptionType.unknown:
        return Failure(e.toString());
      default:
        return const Failure("No Internet Connection");
    }
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> patch(
    String url, {
    body,
    Map<String, String>? headers,
  }) async {
    try {
      if (headers != null) {
        _headers.addAll(headers);
      }
      Logger().i("Set post data: $body");
      final res = await _dio.patch(
        url,
        data: body,
        options: Options(headers: _headers),
      );

      _logger.d("Patch Response: $res");

      if (res.statusCode == 200 ||
          res.statusCode == 201 ||
          res.statusCode == 202) {
        if (res.data is String) {
          return ApiResponse(
            data: jsonDecode(res.data)["data"] ?? res.data,
            message: jsonDecode(res.data)["message"],
            status: jsonDecode(res.data)["success"],
          );
        } else {
          return ApiResponse(
            data: res.data['data'] ?? res.data,
            message: res.data['message'],
            status: res.data['status'],
          );
        }
      } else if (res.data["message"] != null) {
        throw Failure(res.data["message"]);
      }
      throw Failure(res.statusMessage!);
    } on DioException catch (e) {
      throw convertException(e);
    } on Failure catch (e) {
      throw Failure(e.message);
    } catch (e) {
      _logger.e(e.toString());
      throw Failure(e.toString());
    }
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> patchFile({
    required String url,
    required String key,
    required File file,
    Map<String, String>? headers,
  }) async {
    try {
      if (headers != null) {
        _headers.addAll(headers);
      }
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        key: await MultipartFile.fromFile(file.path, filename: fileName),
      });

      final res = await _dio.patch(
        url,
        data: formData,
        options: Options(headers: _headers),
      );
      if (res.statusCode == 200 ||
          res.statusCode == 201 ||
          res.statusCode == 202) {
        if (res.data is String) {
          return ApiResponse(
            data: jsonDecode(res.data)["data"] ?? res.data,
            message: jsonDecode(res.data)["message"],
            status: jsonDecode(res.data)["success"],
          );
        } else {
          return ApiResponse(
            data: res.data['data'] ?? res.data,
            message: res.data['message'],
            status: res.data['status'],
          );
        }
      } else if (res.data["message"] != null) {
        throw Failure(res.data["message"]);
      }
      throw Failure(res.statusMessage!);
    } on DioException catch (e) {
      throw convertException(e);
    } on Failure catch (e) {
      throw Failure(e.message);
    } catch (e) {
      _logger.e(e.toString());
      throw Failure(e.toString());
    }
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> patchFiles({
    required String url,
    required List<MapEntry<String, File>>
    filesWithKeys, // List of file-key pairs
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      if (headers != null) {
        _headers.addAll(headers);
      }

      // Initialize FormData and populate with files and keys
      FormData formData = FormData();

      // Add files with their respective keys
      for (var entry in filesWithKeys) {
        String key = entry.key;
        File file = entry.value;
        String fileName = file.path.split('/').last;

        // Add file with its corresponding key
        formData.files.add(
          MapEntry(
            key,
            await MultipartFile.fromFile(file.path, filename: fileName),
          ),
        );
      }

      // Add additional body data if provided
      if (body != null) {
        formData.fields.addAll(
          body.entries.map((e) => MapEntry(e.key, e.value.toString())),
        );
      }

      Logger().i(
        "Set patch data: ${formData.fields}, files: ${formData.files.map((f) => f.key).toList()}",
      );

      // Make PATCH request
      final res = await _dio.patch(
        url,
        data: formData,
        options: Options(headers: _headers),
      );

      // Handle response
      if (res.statusCode == 200 ||
          res.statusCode == 201 ||
          res.statusCode == 202) {
        if (res.data is String) {
          return ApiResponse(
            data: jsonDecode(res.data)["data"] ?? res.data,
            message: jsonDecode(res.data)["message"],
            status: jsonDecode(res.data)["success"],
          );
        } else {
          return ApiResponse(
            data: res.data['data'] ?? res.data,
            message: res.data['message'],
            status: res.data['status'],
          );
        }
      } else if (res.data["message"] != null) {
        throw Failure(res.data["message"]);
      }
      throw Failure(res.statusMessage ?? 'Unknown error occurred');
    } on DioException catch (e) {
      throw convertException(e);
    } catch (e) {
      _logger.e(e.toString());
      throw Failure(e.toString());
    }
  }
}
