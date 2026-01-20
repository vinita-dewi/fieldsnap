import 'package:dio/dio.dart';
import 'package:fieldsnap/core/enums/api_method.dart';
import '../config/env.dart';
import '../logging/app_logger.dart';

class ApiService {
  final Dio _dio;
  final _log = AppLogger.instance;

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
    ApiMethod method = ApiMethod.GET,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool useApiKey = false,
  }) {
    Options requestOptions =
        options?.copyWith(method: method.name) ?? Options(method: method.name);
    if (useApiKey) {
      final headers = Map<String, dynamic>.from(requestOptions.headers ?? {});
      headers["X-API-CO-ID"] = Env.apiKey;
      requestOptions = requestOptions.copyWith(headers: headers);
    }

    _log.i(
      '[ApiService.request] ${method.name} $path '
      'query=${queryParameters ?? {}} '
      'useApiKey=$useApiKey',
    );

    return _dio.request<T>(
      path,
      data: body,
      queryParameters: queryParameters,
      options: requestOptions,
    );
  }
}
