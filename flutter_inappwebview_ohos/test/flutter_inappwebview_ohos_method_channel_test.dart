import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_inappwebview_ohos/flutter_inappwebview_ohos_method_channel.dart';

void main() {
  MethodChannelFlutterInappwebviewOhos platform = MethodChannelFlutterInappwebviewOhos();
  const MethodChannel channel = MethodChannel('flutter_inappwebview_ohos');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
