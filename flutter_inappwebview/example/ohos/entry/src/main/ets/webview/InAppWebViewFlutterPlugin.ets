import { BinaryMessenger, Log } from '@ohos/flutter_ohos';
import {
  FlutterAssets,
  FlutterPlugin,
  FlutterPluginBinding
} from '@ohos/flutter_ohos/src/main/ets/embedding/engine/plugins/FlutterPlugin';
import FlutterWebViewFactory from './webview/FlutterWebViewFactory';

const TAG = "InAppWebViewFlutterPlugin";

export default class InAppWebViewFlutterPlugin implements FlutterPlugin {
  public flutterAssets: FlutterAssets | null = null;
  public flutterWebViewFactory: FlutterWebViewFactory | null = null
  public messenger: BinaryMessenger | null = null

  constructor() {
  }

  getUniqueClassName(): string {
    return "InAppWebViewFlutterPlugin"
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    Log.d(TAG, "onAttachedToEngine")
    this.flutterAssets = binding.getFlutterAssets();
    this.flutterWebViewFactory = new FlutterWebViewFactory(this);
    this.messenger = binding.getBinaryMessenger();
    binding.getPlatformViewRegistry().registerViewFactory(FlutterWebViewFactory.VIEW_TYPE_ID, this.flutterWebViewFactory);
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {

  }
}