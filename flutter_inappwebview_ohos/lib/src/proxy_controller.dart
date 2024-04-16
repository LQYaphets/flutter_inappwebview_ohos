import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview_platform_interface/flutter_inappwebview_platform_interface.dart';

/// Object specifying creation parameters for creating a [OhosProxyController].
///
/// When adding additional fields make sure they can be null or have a default
/// value to avoid breaking changes. See [PlatformProxyControllerCreationParams] for
/// more information.
@immutable
class OhosProxyControllerCreationParams
    extends PlatformProxyControllerCreationParams {
  /// Creates a new [OhosProxyControllerCreationParams] instance.
  const OhosProxyControllerCreationParams(
    // This parameter prevents breaking changes later.
    // ignore: avoid_unused_constructor_parameters
    PlatformProxyControllerCreationParams params,
  ) : super();

  /// Creates a [OhosProxyControllerCreationParams] instance based on [PlatformProxyControllerCreationParams].
  factory OhosProxyControllerCreationParams.fromPlatformProxyControllerCreationParams(
      PlatformProxyControllerCreationParams params) {
    return OhosProxyControllerCreationParams(params);
  }
}

///{@macro flutter_inappwebview_platform_interface.PlatformProxyController}
class OhosProxyController extends PlatformProxyController
    with ChannelController {
  /// Creates a new [OhosProxyController].
  OhosProxyController(PlatformProxyControllerCreationParams params)
      : super.implementation(
          params is OhosProxyControllerCreationParams
              ? params
              : OhosProxyControllerCreationParams
                  .fromPlatformProxyControllerCreationParams(params),
        ) {
    channel = const MethodChannel(
        'com.pichillilorenzo/flutter_inappwebview_proxycontroller');
    handler = handleMethod;
    initMethodCallHandler();
  }

  static OhosProxyController? _instance;

  ///Gets the [OhosProxyController] shared instance.
  static OhosProxyController instance() {
    return (_instance != null) ? _instance! : _init();
  }

  static OhosProxyController _init() {
    _instance = OhosProxyController(OhosProxyControllerCreationParams(
        const PlatformProxyControllerCreationParams()));
    return _instance!;
  }

  Future<dynamic> _handleMethod(MethodCall call) async {}

  @override
  Future<void> setProxyOverride({required ProxySettings settings}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent("settings", () => settings.toMap());
    await channel?.invokeMethod('setProxyOverride', args);
  }

  @override
  Future<void> clearProxyOverride() async {
    Map<String, dynamic> args = <String, dynamic>{};
    await channel?.invokeMethod('clearProxyOverride', args);
  }

  @override
  void dispose() {
    // empty
  }
}

extension InternalProxyController on OhosProxyController {
  get handleMethod => _handleMethod;
}
