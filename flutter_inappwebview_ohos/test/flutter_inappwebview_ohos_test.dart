import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_inappwebview_ohos/flutter_inappwebview_ohos.dart';
import 'package:flutter_inappwebview_ohos/flutter_inappwebview_ohos_platform_interface.dart';
import 'package:flutter_inappwebview_ohos/flutter_inappwebview_ohos_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterInappwebviewOhosPlatform
    with MockPlatformInterfaceMixin
    implements FlutterInappwebviewOhosPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterInappwebviewOhosPlatform initialPlatform = FlutterInappwebviewOhosPlatform.instance;

  test('$MethodChannelFlutterInappwebviewOhos is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterInappwebviewOhos>());
  });

  test('getPlatformVersion', () async {
    FlutterInappwebviewOhos flutterInappwebviewOhosPlugin = FlutterInappwebviewOhos();
    MockFlutterInappwebviewOhosPlatform fakePlatform = MockFlutterInappwebviewOhosPlatform();
    FlutterInappwebviewOhosPlatform.instance = fakePlatform;

    expect(await flutterInappwebviewOhosPlugin.getPlatformVersion(), '42');
  });
}
