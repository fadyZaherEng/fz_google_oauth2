import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Custom Dio Interceptor with token injection and refresh logic.
class CustomInterceptors extends InterceptorsWrapper {
  final Future<String> Function()? getToken;
  final Future<void> Function(String token)? saveToken;
  final Future<Map<String, dynamic>> Function()? refreshToken;

  CustomInterceptors({
    required this.getToken,
    required this.saveToken,
    required this.refreshToken,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await getToken?.call() ?? '';
      if (token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      debugPrint(
        "✅ REQUEST [${options.method}] => ${options.uri} \n"
        "HEADERS: ${options.headers} \n"
        "QUERY: ${options.queryParameters} \n"
        "BODY: ${options.data}",
      );
    } catch (e) {
      debugPrint("❌ Failed to attach token: $e");
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
      "✅ RESPONSE [${response.statusCode}] => ${response.requestOptions.uri} \n"
      "${jsonEncode(response.data)}",
    );
    handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    debugPrint(
      "❌ ERROR [${err.response?.statusCode}] => ${err.requestOptions.uri} \n"
      "BODY: ${err.response?.data}",
    );

    if (err.response?.statusCode == 401 && refreshToken != null) {
      try {
        // Attempt to refresh the token
        final newTokenData = await refreshToken!.call();
        final newAccessToken = newTokenData['access_token'] ?? '';

        if (newAccessToken.isNotEmpty) {
          await saveToken?.call(newAccessToken);

          // Clone the original request with new token
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $newAccessToken';

          final response = await Dio().fetch(
            options,
          ); // لا تعيّن requestOptions على dio.options
          return handler.resolve(response);
        }
      } catch (e) {
        debugPrint("❌ Token refresh failed: $e");
        return handler.reject(
          DioError(
            requestOptions: err.requestOptions,
            error: e,
            type: DioErrorType.badResponse,
          ),
        );
      }
    }

    handler.next(err);
  }
}
