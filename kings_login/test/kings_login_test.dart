import 'package:flutter_test/flutter_test.dart';
import 'package:kings_login/kings_login.dart';
import 'package:kings_login/kings_login_method_channel.dart';
import 'package:kings_login/kings_login_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockKingsLoginPlatform
    with MockPlatformInterfaceMixin
    implements KingsLoginPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<Map<String, dynamic>?> login() => Future.value({});
}

void main() {
  final KingsLoginPlatform initialPlatform = KingsLoginPlatform.instance;

  test('$MethodChannelKingsLogin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelKingsLogin>());
  });

  test('getPlatformVersion', () async {
    MockKingsLoginPlatform fakePlatform = MockKingsLoginPlatform();
    KingsLoginPlatform.instance = fakePlatform;

    expect(await KingsLogin.getPlatformVersion(), '42');
  });
}
