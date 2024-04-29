import { BinaryMessenger, Log } from '@ohos/flutter_ohos';
import {
  FlutterAssets,
  FlutterPlugin,
  FlutterPluginBinding
} from '@ohos/flutter_ohos/src/main/ets/embedding/engine/plugins/FlutterPlugin';
import MyCookieManager from './MyCookieManager';
import PrintJobManager from './print_job/PrintJobManager';
import FlutterWebViewFactory from './webview/FlutterWebViewFactory';

const TAG = "InAppWebViewFlutterPlugin";

export default class InAppWebViewFlutterPlugin implements FlutterPlugin {
  public flutterAssets: FlutterAssets | null = null;
  public flutterWebViewFactory: FlutterWebViewFactory | null = null
  public messenger: BinaryMessenger | null = null
  public printJobManager: PrintJobManager | null = null;
  public myCookieManager: MyCookieManager | null = null;

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

    this.myCookieManager = new MyCookieManager(this);
    this.printJobManager = new PrintJobManager(this);
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.printJobManager != null) {
      this.printJobManager.dispose();
      this.printJobManager = null;
    }
    if (this.myCookieManager != null) {
      this.myCookieManager.dispose();
      this.myCookieManager = null;
    }
  }
}