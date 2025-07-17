import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:fz_google_oauth2/network/interceptor.dart';

class FzGoogleOauth2Services {
  static Future<Map<String, dynamic>> login({
    ///azure variables
    ///tenantId,
    ///clientId,
    ///clientSecret,
    ///scope
    /// from google account
    /// scope contains----------> openid profile email offline_access + Your custom scope
    required String tenantId,
    required String clientId,
    required String clientSecret,
    required String scope,
    required String email,
    required String password,
  }) async {
    final dio = Dio();

    // ✅ استخدم endpoint الصحيح
    final url = 'https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token';

    final data = {
      'grant_type': 'password',
      'client_id': clientId,
      'username': email,
      'password': password,
      'scope': 'openid profile email offline_access $scope',
      'client_secret': clientSecret,
    };

    try {
      final response = await dio.post(
        url,
        data: FormData.fromMap(data),
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      debugPrint('Response: ${response.data}');

      return response.data;
    } catch (e) {
      debugPrint('Error: $e');
    }

    return {};
  }
  /// Generate Refresh token when expired token
  /// By custom indicator
  /// If you want to generate refresh token when expired token
  /// in your app, you can use this method
  /// using Dio interceptors

  static InterceptorsWrapper getCustomInterceptorsForRefreshToken({
    required String tenantId,
    required String clientId,
    required String clientSecret,
    required String scope,
    required String email,
    required String password,
    required Future<String?> Function() getToken,
    required Future<void> Function(String token) saveToken,
  }) {
    return CustomInterceptors(
      getToken: () async => await getToken() ?? '', // ✅ حل المشكلة
      saveToken: saveToken,
      refreshToken: () async {
        final response = await login(
          tenantId: tenantId,
          clientId: clientId,
          clientSecret: clientSecret,
          scope: scope,
          email: email,
          password: password,
        );

        final token = response['access_token'] ?? '';
        if (token.isEmpty) {
          throw Exception("Failed to refresh token");
        }

        await saveToken(token);

        return {'access_token': token};
      },
    );
  }
}
