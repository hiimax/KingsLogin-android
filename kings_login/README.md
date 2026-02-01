# KingsLogin Flutter SDK

A Flutter plugin for integrating KingsChat Login into your Android and iOS applications.

## Installation

Add `kings_login` as a dependency in your `pubspec.yaml` file.

```yaml
dependencies:
  kings_login:
    path: ./kings_login # If local, or use git/hosted url
```

## Configuration

### Android Setup

1.  **Add Application ID Metadata**:
    Open your `android/app/src/main/AndroidManifest.xml` (or `strings.xml`) and add your KingsChat Client ID as metadata, as required by the native SDK.

    ```xml
    <meta-data
        android:name="com.kingschat.sdk.ApplicationId"
        android:value="@string/app_meta_data_id" />
    ```

2.  **Ensure INTERNET Permission**:
    ```xml
    <uses-permission android:name="android.permission.INTERNET"/>
    ```

### iOS Setup

1.  **Configure Info.plist**:
    Add the necessary URL schemes for KingsChat login refirection in your `ios/Runner/Info.plist`.

    ```xml
    <key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleURLSchemes</key>
            <array>
                <string>kc[YOUR_CLIENT_ID]</string>
            </array>
        </dict>
    </array>
    ```

2.  **Add LSApplicationQueriesSchemes**:
    Allow your app to query KingsChat.
    ```xml
    <key>LSApplicationQueriesSchemes</key>
    <array>
        <string>kingschat</string>
    </array>
    ```

## Usage

Import the package:

```dart
import 'package:kings_login/kings_login.dart';
```

### Trigger Login

```dart
void initiateLogin() async {
  // Start the login flow
  final result = await KingsLogin.login();

  switch (result.status) {
    case KingsLoginStatus.success:
      final data = result.data!;
      print('Login Successful');
      print('Auth Code: ${data.code}');
      print('Accepted Scopes: ${data.acceptedScopes}');
      break;

    case KingsLoginStatus.canceled:
      print('Login canceled by user');
      break;

    case KingsLoginStatus.error:
      print('Login failed: ${result.errorMessage}');
      break;
  }
}
```
