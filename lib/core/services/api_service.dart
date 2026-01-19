import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;

  ApiService({String? baseUrl}) : _dio = _createDio(baseUrl ?? '');

  static Dio _createDio(String baseUrl) {
    return Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
      ),
    );
  }

  Future<Response<T>> request<T>({
    required String path,
    String method = 'GET',
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.request<T>(
      path,
      data: body,
      queryParameters: queryParameters,
      options: options?.copyWith(method: method) ?? Options(method: method),
    );
  }
}
