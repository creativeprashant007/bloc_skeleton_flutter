import 'package:dio/dio.dart';
import 'package:stock_control_master/core/constants/constant.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() {
    return _instance;
  }
  late Dio dio;
  ApiService._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: AppConstants.SERVER_API_URL,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {},
      contentType: "application/json:charset=utf-8",
      responseType: ResponseType.json,
    );
    dio = Dio(options);
  }
  Future post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    dynamic response;

    try {
      response = await dio.post(
        path,
        data: FormData.fromMap(data),
        queryParameters: queryParameters,
      );
    } catch (e) {
      print("here is try exception: ${e.toString()}");
    }
    return response.data;
  }
}
