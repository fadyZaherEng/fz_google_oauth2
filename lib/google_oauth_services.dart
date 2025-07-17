import 'package:dio/dio.dart';
import 'package:fz_google_oauth2/fz_google_oauth2.dart';

///Google oauth2 services
class GoogleOauth2Services {
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
    return await FzGoogleOauth2Services.login(
      tenantId: tenantId,
      clientId: clientId,
      clientSecret: clientSecret,
      scope: scope,
      email: email,
      password: password,
    );
  }
  /// Generate Refresh token when expired token
  /// By custom indicator
  /// If you want to generate refresh token when expired token
  /// in your app, you can use this method
  /// using Dio interceptors

  //calling interceptor
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
    return FzGoogleOauth2Services.getCustomInterceptorsForRefreshToken(
      tenantId: tenantId,
      clientId: clientId,
      clientSecret: clientSecret,
      scope: scope,
      email: email,
      password: password,
      getToken: getToken,
      saveToken: saveToken,
    );
  }
}
