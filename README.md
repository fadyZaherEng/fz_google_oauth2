🎬 fz_google_oauth2

A Flutter package for Google OAuth2 authentication to get access to Google APIs , login And.
contain Custom Interceptors For Refresh Token

## 📖 Table of Contents

- [Screenshots](#Screenshots)
- [Features](#Features)
- [Getting Started](#getting-started)
- [Usage](#usage)
    - [fz_google_oauth2](#google_oauth2)
- [Example](#example)
- [Dependencies Used](#dependencies-used)
- [About the Developer](#about-the-developer)
- [License](#license)

 
## Screens

| ![Screen 1](https://raw.githubusercontent.com/fadyZaherEng/fz_google_oauth2/master/assets/1.jpg) | ![Screen 2](https://raw.githubusercontent.com/fadyZaherEng/fz_google_oauth2/master/assets/2.jpg) |  
|:------------------------------------------------------------------------------------------------:|:------------------------------------------------------------------------------------------------:| 

 
--- 

## Features

- 🚀 Login And Get Access To Google APIs
- 🚀 Custom Interceptors For Refresh Token
- 🚀 Complete Google OAuth2 Flow

---

## Getting Started

1. **Add dependency:**
   In your `pubspec.yaml`:

```yaml
dependencies:
  fz_google_oauth2: ^0.0.2
```

2. `Install Package` In your project:

```
flutter pub get
```

3. `Android Configuration:` In your AndroidManifest.xml:

```xml

<uses-permission android:name="android.permission.INTERNET" /> 
```

in /android/app/build.gradle

```
minSdk = 24
// Prefered 
compileSdk = 34
```

4. `iOS Configuration:` No additional configuration is required for iOS.:

## Usage

Here’s a complete example showing how to use
the `fz_google_oauth2` package to get access to Google APIs and login.

## usage google_oauth2

```dart

final result = await
FzGoogleOauth2Services.login
(
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
```

## Custom Interceptors For Refresh Token

```dart
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
```

## Example_Full_Code

[You Can Find The Full Code Here](https://github.com/fadyZaherEng/fz_google_oauth2)

## Dependencies Used

## This package uses (You do not have to import them):

    dio:

```
Before using this example directly in a Flutter app, don't forget to add the fz_google_oauth2 
 to your pubspec.yaml file.
You can try out this example by replacing the entire content of main.dart file of a newly created
Flutter project.
```

## About the Developer

Hello! 👋 I'm Fady Zaher, a Mid Level Flutter Developer with extensive experience in building
high-quality mobile applications.

- 📧 Email: fedo.zaher@gmail.com

---
If you like this package, feel free to ⭐️ the repo and share it!

📝 License
MIT License

Copyright (c) 2025 [Fady Zaher]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

