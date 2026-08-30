import 'dart:convert';
import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import '../../data/models/server_config_model.dart';

class ApiResponse {
  final bool isSuccess;
  final int statusCode;
  final dynamic data;
  final String? message;
  final String? rawResponse;

  ApiResponse({
    required this.isSuccess,
    required this.statusCode,
    this.data,
    this.message,
    this.rawResponse,
  });
}

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  late Dio _dio;
  ServerConfig _config = const ServerConfig();
  String? _sessionCookie;

  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 15),
        responseType: ResponseType.plain,
      ),
    );

    // Logging & Cookie Interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_sessionCookie != null && _sessionCookie!.isNotEmpty) {
            options.headers['Cookie'] = _sessionCookie;
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Extract Set-Cookie if returned
          final setCookie = response.headers['set-cookie'];
          if (setCookie != null && setCookie.isNotEmpty) {
            _sessionCookie = setCookie.first.split(';').first;
          }
          return handler.next(response);
        },
      ),
    );
  }

  ServerConfig get config => _config;
  String? get sessionCookie => _sessionCookie;

  void updateConfig(ServerConfig newConfig) {
    _config = newConfig;
  }

  void setSessionCookie(String? cookie) {
    _sessionCookie = cookie;
  }

  /// Thực thi mã hàm API (1 trong 49 F_* codes)
  Future<ApiResponse> callFunction(
    int funcCode, {
    Map<String, dynamic>? params,
  }) async {
    final payload = <String, dynamic>{
      ApiParamKeys.func: funcCode,
      if (_sessionCookie != null) ApiParamKeys.cookie: _sessionCookie,
      ...?params,
    };

    try {
      final response = await _dio.post(
        _config.fullEndpointUrl,
        data: FormData.fromMap(payload),
        options: Options(contentType: 'application/x-www-form-urlencoded'),
      );

      final rawString = response.data.toString();
      dynamic parsedData;
      try {
        parsedData = jsonDecode(rawString);
      } catch (_) {
        parsedData = rawString;
      }

      return ApiResponse(
        isSuccess: (response.statusCode ?? 0) >= 200 && (response.statusCode ?? 0) < 300,
        statusCode: response.statusCode ?? 200,
        data: parsedData,
        rawResponse: rawString,
      );
    } on DioException catch (e) {
      return ApiResponse(
        isSuccess: false,
        statusCode: e.response?.statusCode ?? 500,
        message: e.message ?? 'Lỗi kết nối mạng đến máy chủ',
        rawResponse: e.response?.data?.toString(),
      );
    } catch (e) {
      return ApiResponse(
        isSuccess: false,
        statusCode: 500,
        message: 'Lỗi không xác định: $e',
      );
    }
  }

  /// Ping kiểm tra máy chủ (F_PINGSERVER = 39)
  Future<bool> pingServer() async {
    try {
      final res = await callFunction(ApiFunctionCodes.fPingServer);
      return res.isSuccess;
    } catch (_) {
      return false;
    }
  }
}
