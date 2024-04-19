import { Log, PlatformView, PlatformViewFactory, StandardMessageCodec } from '@ohos/flutter_ohos';
import InAppWebViewFlutterPlugin from '../InAppWebViewFlutterPlugin';
import { FlutterWebView } from './in_app_webview/FlutterWebView';

const TAG: string = "FlutterWebViewFactory";

export default class FlutterWebViewFactory extends PlatformViewFactory {
  public static VIEW_TYPE_ID = "com.pichillilorenzo/flutter_inappwebview";
  private plugin: InAppWebViewFlutterPlugin;

  constructor(plugin: InAppWebViewFlutterPlugin) {
    super(StandardMessageCodec.INSTANCE);
    this.plugin = plugin;
  }

  public create(context: Context, viewId: number, args: ESObject): PlatformView {
    Log.d(TAG, "create")
    let flutterWebView = new FlutterWebView(this.plugin, context, viewId, args);
    flutterWebView.makeInitialLoad(args);
    return flutterWebView;
  }
}