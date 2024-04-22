import { MethodCall, MethodChannel } from '@ohos/flutter_ohos';
import { MethodResult } from '@ohos/flutter_ohos/src/main/ets/plugin/common/MethodChannel';
import { DVModel, DVModelParameters } from '@ohos/flutter_ohos/src/main/ets/view/DynamicView/dynamicView';
import InAppWebViewFlutterPlugin from '../InAppWebViewFlutterPlugin';
import ChannelDelegateImpl from '../types/ChannelDelegateImpl';
import { FlutterWebView } from './in_app_webview/FlutterWebView';
import { Context } from '@kit.AbilityKit';

const LOG_TAG = "InAppWebViewManager"
const METHOD_CHANNEL_NAME = "com.pichillilorenzo/flutter_inappwebview_manager"

export class InAppWebviewManager extends ChannelDelegateImpl {

  private plugin: InAppWebViewFlutterPlugin | null = null

  public keepAliveWebViews: Map<string, FlutterWebView | undefined> = new Map<string, FlutterWebView | undefined>()

  /// 机制不同，缺少类似于android.os.message方法
  // public windowWebViewMessages: Map<number, Message> = new Map<number, Message>()

  public windowAutoincrementId: number = 0

  constructor(plugin: InAppWebViewFlutterPlugin) {
    super(new MethodChannel(plugin.messenger!, METHOD_CHANNEL_NAME));
    this.plugin = plugin
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    switch (call.method) {
      case "getDefaultUserAgent":
        if (this.plugin != null) {
          // result.success(WebSettings.getDefaultUserAgent(plugin.applicationContext));
        } else {
          result.success(null);
        }
        break;
      case "clearClientCertPreferences":
        // if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
        //   WebView.clearClientCertPreferences(new Runnable() {
        //     @Override
        //     public void run() {
        //       result.success(true);
        //     }
        //   });
        // } else {
        //   result.success(false);
        // }
        break;
      case "getSafeBrowsingPrivacyPolicyUrl":
        // if (WebViewFeature.isFeatureSupported(WebViewFeature.SAFE_BROWSING_PRIVACY_POLICY_URL)) {
        //   result.success(WebViewCompat.getSafeBrowsingPrivacyPolicyUrl().toString());
        // } else
        //   result.success(null);
        break;
      case "setSafeBrowsingAllowlist":
        // if (WebViewFeature.isFeatureSupported(WebViewFeature.SAFE_BROWSING_ALLOWLIST)) {
        //   Set<String> hosts = new HashSet<>((List<String>) call.argument("hosts"));
        //   WebViewCompat.setSafeBrowsingAllowlist(hosts, new ValueCallback<Boolean>() {
        //     @Override
        //     public void onReceiveValue(Boolean value) {
        //       result.success(value);
        //     }
        //   });
        // }
        // else if (WebViewFeature.isFeatureSupported(WebViewFeature.SAFE_BROWSING_WHITELIST)) {
        //   List<String> hosts = (List<String>) call.argument("hosts");
        //   WebViewCompat.setSafeBrowsingWhitelist(hosts, new ValueCallback<Boolean>() {
        //     @Override
        //     public void onReceiveValue(Boolean value) {
        //       result.success(value);
        //     }
        //   });
        // } else
        //   result.success(false);
        break;
      case "getCurrentWebViewPackage":
        // {
        //   Context context = null;
        //   if (plugin != null) {
        //     context = plugin.activity;
        //     if (context == null) {
        //       context = plugin.applicationContext;
        //     }
        //   }
        //   PackageInfo packageInfo = context != null ? WebViewCompat.getCurrentWebViewPackage(context) : null;
        //   result.success(packageInfo != null ? convertWebViewPackageToMap(packageInfo) : null);
        // }
        break;
      case "setWebContentsDebuggingEnabled":
        // {
        //   boolean debuggingEnabled = (boolean) call.argument("debuggingEnabled");
        //   if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
        //     WebView.setWebContentsDebuggingEnabled(debuggingEnabled);
        //   }
        // }
        result.success(true);
        break;
      case "getVariationsHeader":
        // if (WebViewFeature.isFeatureSupported(WebViewFeature.GET_VARIATIONS_HEADER)) {
        //   result.success(WebViewCompat.getVariationsHeader());
        // }
        // else {
        //   result.success(null);
        // }
        break;
      case "isMultiProcessEnabled":
        // if (WebViewFeature.isFeatureSupported(WebViewFeature.MULTI_PROCESS)) {
        //   result.success(WebViewCompat.isMultiProcessEnabled());
        // }
        // else {
        //   result.success(false);
        // }
        break;
      case "disableWebView":
        // if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
        //   WebView.disableWebView();
        // }
        result.success(true);
        break;
      case "disposeKeepAlive":
        // final String keepAliveId = (String) call.argument("keepAliveId");
        // if (keepAliveId != null) {
        //   disposeKeepAlive(keepAliveId);
        // }
        result.success(true);
        break;
      case "clearAllCache":
        // {
        //   Context context = null;
        //   if (plugin != null) {
        //     context = plugin.activity;
        //     if (context == null) {
        //       context = plugin.applicationContext;
        //     }
        //     if (context != null) {
        //       boolean includeDiskFiles = (boolean) call.argument("includeDiskFiles");
        //       clearAllCache(context, includeDiskFiles);
        //     }
        //   }
        // }
        result.success(true);
        break;
      default:
        result.notImplemented();
    }
  }

  // public convertWebViewPackageToMap(webViewPackageInfo: PackageInfo): Map<string, ESObject> {
  //   let webViewPackageInfoMap: Map<string, ESObject> = new Map<string, ESObject>()
  //
  //   webViewPackageInfoMap.set("versionName", webViewPackageInfo.versionName);
  //   webViewPackageInfoMap.set("packageName", webViewPackageInfo.packageName);
  //
  //   return webViewPackageInfoMap;
  // }

  public disposeKeepAlive(keepAliveId: string): void {
    let flutterWebView: FlutterWebView | undefined = this.keepAliveWebViews.get(keepAliveId)
    if (flutterWebView != null) {
      flutterWebView.keepAliveId = null;
      // be sure to remove the view from the previous parent.
      let view: DVModel = flutterWebView.getView();
      if (view != null) {
        // let parent: ViewGroup = view.getParent();
        // if (parent != null) {
        //   parent.removeView(view);
        // }
      }
      flutterWebView.dispose();
    }
    let containsKey: boolean = true
    for(let key of this.keepAliveWebViews.keys()) {
      if(key == keepAliveId) {
        containsKey = false
      }
    }
    if (containsKey) {
      this.keepAliveWebViews.set(keepAliveId, undefined);
    }
  }

  public clearAllCache(context: Context, includeDiskFiles: boolean): void {
    // let tempWebView: WebView = new WebView(context)
    // tempWebView.clearCache(includeDiskFiles);
    // tempWebView.destroy();
  }

  public dispose(): void {
    super.dispose();
    // let flutterWebViews: Collection<FlutterWebView> = this.keepAliveWebViews.values()
    // for (let flutterWebView: FlutterWebView of flutterWebViews) {
    //   let keepAliveId: string = flutterWebView.keepAliveId;
    //   if (keepAliveId != null) {
    //     this.disposeKeepAlive(flutterWebView.keepAliveId);
    //   }
    // }
    this.keepAliveWebViews.clear();
    // this.windowWebViewMessages.clear();
    this.plugin = null;
  }
}