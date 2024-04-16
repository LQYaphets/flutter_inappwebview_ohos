import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview_platform_interface/flutter_inappwebview_platform_interface.dart';

/// Object specifying creation parameters for creating a [OhosProcessGlobalConfig].
///
/// When adding additional fields make sure they can be null or have a default
/// value to avoid breaking changes. See [PlatformProcessGlobalConfigCreationParams] for
/// more information.
@immutable
class OhosProcessGlobalConfigCreationParams
    extends PlatformProcessGlobalConfigCreationParams {
  /// Creates a new [OhosProcessGlobalConfigCreationParams] instance.
  const OhosProcessGlobalConfigCreationParams(
    // This parameter prevents breaking changes later.
    // ignore: avoid_unused_constructor_parameters
    PlatformProcessGlobalConfigCreationParams params,
  ) : super();

  /// Creates a [OhosProcessGlobalConfigCreationParams] instance based on [PlatformProcessGlobalConfigCreationParams].
  factory OhosProcessGlobalConfigCreationParams.fromPlatformProcessGlobalConfigCreationParams(
      PlatformProcessGlobalConfigCreationParams params) {
    return OhosProcessGlobalConfigCreationParams(params);
  }
}

///{@macro flutter_inappwebview_platform_interface.PlatformProcessGlobalConfig}
class OhosProcessGlobalConfig extends PlatformProcessGlobalConfig
    with ChannelController {
  /// Creates a new [OhosProcessGlobalConfig].
  OhosProcessGlobalConfig(PlatformProcessGlobalConfigCreationParams params)
      : super.implementation(
          params is OhosProcessGlobalConfigCreationParams
              ? params
              : OhosProcessGlobalConfigCreationParams
                  .fromPlatformProcessGlobalConfigCreationParams(params),
        ) {
    channel = const MethodChannel(
        'com.pichillilorenzo/flutter_inappwebview_processglobalconfig');
    handler = handleMethod;
    initMethodCallHandler();
  }

  static OhosProcessGlobalConfig? _instance;

  ///Gets the [OhosProcessGlobalConfig] shared instance.
  static OhosProcessGlobalConfig instance() {
    return (_instance != null) ? _instance! : _init();
  }

  static OhosProcessGlobalConfig _init() {
    _instance = OhosProcessGlobalConfig(
        OhosProcessGlobalConfigCreationParams(
            const PlatformProcessGlobalConfigCreationParams()));
    return _instance!;
  }

  Future<dynamic> _handleMethod(MethodCall call) async {}

  @override
  Future<void> apply({required ProcessGlobalConfigSettings settings}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent("settings", () => settings.toMap());
    await channel?.invokeMethod('apply', args);
  }

  @override
  void dispose() {
    // empty
  }
}

extension InternalProcessGlobalConfig on OhosProcessGlobalConfig {
  get handleMethod => _handleMethod;
}
