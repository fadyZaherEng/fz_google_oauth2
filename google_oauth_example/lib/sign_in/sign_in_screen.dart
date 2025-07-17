import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fz_google_oauth2/fz_google_oauth2.dart';
import 'package:google_oauth_example/sign_in/widgets/custom_text_field_widget.dart';
import 'package:google_oauth_example/sign_in/widgets/password_text_field_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _emailErrorMessage;
  String? _passwordErrorMessage;

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    _scrollToBottomScreenWhenKeyboardOpen();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      CustomTextFieldWidget(
                        textInputType: TextInputType.emailAddress,
                        errorMessage: _emailErrorMessage,
                        controller: _emailController,
                        labelTitle: "email address",
                        onChange: (value) => _validateEmailEvent(value),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9@._-]'),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      PasswordTextFieldWidget(
                        errorMessage: _passwordErrorMessage,
                        controller: _passwordController,
                        labelTitle: "password",
                        onChange: _validatePasswordEvent,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: Colors.black,
                        ),
                        onPressed: _signInEvent,
                        child: Text(
                          "SIGN IN",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _scrollToBottomScreenWhenKeyboardOpen() {
    final isKeyboardOpen =
        WidgetsBinding.instance.window.viewInsets.bottom != 0.0;
    if (isKeyboardOpen) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(
          milliseconds: 300,
        ),
        curve: Curves.easeInOut,
      );
    }
  }

  void _validatePasswordEvent(String value) {}

  void _validateEmailEvent(String email) {}

  void _signInEvent() async {
    final result = await FzGoogleOauth2Services.login(
      tenantId: "YOUR_TENANT_ID",
      clientId: "YOUR_CLIENT_ID",
      clientSecret: "YOUR_CLIENT_SECRET",
      scope: "YOUR_SCOPE",
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (result != null) {
      debugPrint("result: $result");
      SnackBar snackBar =
          SnackBar(content: Text("Your Token is ${result['access_token']}"));
      // SnackBar(content: Text("Your Token is ${result['refresh_token']}"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
  }

  /// Generate Refresh token when expired token
  /// By custom indicator
  /// If you want to generate refresh token when expired token
  /// in your app, you can use this method
  /// using Dio interceptors
  void generateCustomTokenWhenExpiredTokenByCustomIndicator() async {
    InterceptorsWrapper customInterceptors =
        FzGoogleOauth2Services.getCustomInterceptorsForRefreshToken(
      tenantId: "YOUR_TENANT_ID",
      clientId: "YOUR_CLIENT_ID",
      clientSecret: "YOUR_CLIENT_SECRET",
      scope: "YOUR_SCOPE",
      email: _emailController.text,
      password: _passwordController.text,
      getToken: () async {},
      saveToken: (String token) async {},
    );
    //then you can use your custom interceptors in your dio
    Dio dio = Dio();
    dio.interceptors.add(customInterceptors);
    //then you can use your custom interceptors in your dio
  }
}
