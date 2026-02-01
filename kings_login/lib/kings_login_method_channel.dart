import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'kings_login_platform_interface.dart';

/// An implementation of [KingsLoginPlatform] that uses method channels.
class MethodChannelKingsLogin extends KingsLoginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('kings_login');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }

  @override
  Future<Map<String, dynamic>?> login() async {
    // Cast the result to Map<dynamic, dynamic> first then convert keys to String if needed
    // but invokeMapMethod handles flexible typing comfortably.
    final result = await methodChannel.invokeMapMethod<String, dynamic>(
      'login',
    );
    return result;
  }
}
