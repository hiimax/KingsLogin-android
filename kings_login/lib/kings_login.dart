import 'kings_login_platform_interface.dart';

class KingsLogin {
  static Future<String?> getPlatformVersion() {
    return KingsLoginPlatform.instance.getPlatformVersion();
  }

  /// Initiates the login flow.
  ///
  /// Returns a [KingsLoginResult] indicating the outcome.
  static Future<KingsLoginResult> login() async {
    try {
      final data = await KingsLoginPlatform.instance.login();
      if (data != null) {
        // Check if data contains error indicators or is just the user attributes
        // Native implementations should ideally separate known errors from success
        // But here we rely on the platform channel throwing errors for exceptions
        // and returning data for success.
        return KingsLoginResult(
          status: KingsLoginStatus.success,
          data: KingsLoginData.fromMap(data),
        );
      } else {
        // If null is returned and no error was thrown, we can assume cancellation or explicit null
        // dependent on how the native side was implemented. I implemented cancellation as error in Kotlin,
        // but sometimes null is used.
        return KingsLoginResult(status: KingsLoginStatus.canceled);
      }
    } catch (e) {
      if (e.toString().contains("CANCELLED")) {
        return KingsLoginResult(status: KingsLoginStatus.canceled);
      }
      return KingsLoginResult(
        status: KingsLoginStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}

enum KingsLoginStatus { success, canceled, error }

class KingsLoginResult {
  final KingsLoginStatus status;
  final KingsLoginData? data;
  final String? errorMessage;

  KingsLoginResult({required this.status, this.data, this.errorMessage});
}

class KingsLoginData {
  final String code;
  final String acceptedScopes;
  final String rejectedScopes;

  KingsLoginData({
    required this.code,
    required this.acceptedScopes,
    required this.rejectedScopes,
  });

  factory KingsLoginData.fromMap(Map<Object?, Object?> map) {
    return KingsLoginData(
      code: map['code']?.toString() ?? '',
      acceptedScopes: map['accepted_scopes']?.toString() ?? '[]',
      rejectedScopes: map['rejected_scopes']?.toString() ?? '[]',
    );
  }

  @override
  String toString() =>
      'KingsLoginData(code: $code, acceptedScopes: $acceptedScopes, rejectedScopes: $rejectedScopes)';
}
