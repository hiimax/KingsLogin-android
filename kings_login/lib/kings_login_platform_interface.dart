import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'kings_login_method_channel.dart';

abstract class KingsLoginPlatform extends PlatformInterface {
  /// Constructs a KingsLoginPlatform.
  KingsLoginPlatform() : super(token: _token);

  static final Object _token = Object();

  static KingsLoginPlatform _instance = MethodChannelKingsLogin();

  /// The default instance of [KingsLoginPlatform] to use.
  ///
  /// Defaults to [MethodChannelKingsLogin].
  static KingsLoginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [KingsLoginPlatform] when
  /// they register themselves.
  static set instance(KingsLoginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<Map<String, dynamic>?> login() {
    throw UnimplementedError('login() has not been implemented.');
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
