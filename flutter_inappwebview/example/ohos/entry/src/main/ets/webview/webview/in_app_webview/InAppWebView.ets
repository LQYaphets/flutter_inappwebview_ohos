import web_webview from '@ohos.web.webview'
import { DVModel } from '@ohos/flutter_ohos/src/main/ets/view/DynamicView/dynamicView';
import { createDVModelFromJson } from '@ohos/flutter_ohos/src/main/ets/view/DynamicView/dynamicViewJson';
import URLRequest from '../../types/URLRequest';
import InAppWebViewFlutterPlugin from '../../InAppWebViewFlutterPlugin';
import InAppWebViewInterface from '../InAppWebViewInterface';
import { DVModelJson } from './DynamicUtils';
import InAppWebViewSettings from './InAppWebViewSettings';
import { buildOhosWebView } from './OhosWebView';
import { Log, MethodChannel } from '@ohos/flutter_ohos';
import UserScript from '../../types/UserScript';
import JavaScriptBridgeInterface from '../JavaScriptBridgeInterface';
import JavaScriptBridgeJS from '../../plugin_scripts_js/JavaScriptBridgeJS';
import WebViewChannelDelegate from '../WebViewChannelDelegate';
import ContentWorld from '../../types/ContentWorld';
import { ValueCallback } from '../../types/ValueCallback';
import { WebMessageChannel } from '../web_message/WebMessageChannel';
import InAppWebViewChromeClient from './InAppWebViewChromeClient';
import UserContentController from '../../types/UserContentController';
import PromisePolyfillJS from '../../plugin_scripts_js/PromisePolyfillJS';
import ConsoleLogJS from '../../plugin_scripts_js/ConsoleLogJS';
import PrintJS from '../../plugin_scripts_js/PrintJS';
import OnWindowBlurEventJS from '../../plugin_scripts_js/OnWindowBlurEventJS';
import OnWindowFocusEventJS from '../../plugin_scripts_js/OnWindowFocusEventJS';
import InterceptAjaxRequestJS from '../../plugin_scripts_js/InterceptAjaxRequestJS';
import PluginScript from '../../types/PluginScript';
import InterceptFetchRequestJS from '../../plugin_scripts_js/InterceptFetchRequestJS';
import OnLoadResourceJS from '../../plugin_scripts_js/OnLoadResourceJS';
import PluginScriptsUtil from '../../plugin_scripts_js/PluginScriptsUtil';

const TAG = "InAppWebView"
const METHOD_CHANNEL_NAME_PREFIX = "com.pichillilorenzo/flutter_inappwebview_";

export default class InAppWebView implements InAppWebViewInterface {
  private context: Context;
  private plugin: InAppWebViewFlutterPlugin;
  private id: number;
  private windowId: number | null | undefined;
  public customSettings: InAppWebViewSettings;
  private webCookieManager: web_webview.WebCookieManager = new web_webview.WebCookieManager();
  private controller: web_webview.WebviewController = new web_webview.WebviewController();
  private ohosWebViewModel: DVModel | null = null;
  private controllerAttached: boolean = false;
  private initialUserOnlyScripts: Array<UserScript>;
  private javaScriptBridgeInterface: JavaScriptBridgeInterface | null = null;
  public channelDelegate: WebViewChannelDelegate;
  public webMessageChannels: Map<string, WebMessageChannel> = new Map<string, WebMessageChannel>()
  private inAppWebViewChromeClient: InAppWebViewChromeClient | null = null;
  private userContentController = new UserContentController(this);
  private interceptOnlyAsyncAjaxRequestsPluginScript: PluginScript | null = null;

  constructor(context: Context, plugin: InAppWebViewFlutterPlugin, id: number, windowId: number | null | undefined,
              customSettings: InAppWebViewSettings, userScripts: Array<UserScript>) {
    this.context = context;
    this.plugin = plugin;
    this.id = id;
    let channel = new MethodChannel(plugin.messenger!, METHOD_CHANNEL_NAME_PREFIX + id);
    this.channelDelegate = new WebViewChannelDelegate(this, channel);
    this.windowId = windowId;
    this.customSettings = customSettings;
    this.initialUserOnlyScripts = userScripts;
  }

  dispose() {

  }

  async loadUrl(urlRequest: URLRequest) {
    await this.waitControllerAttached();
    let url = urlRequest.getUrl();
    let method = urlRequest.getMethod();
    if (method != null && method == "POST") {
      this.postUrl(url, urlRequest.getBody());
      return;
    }
    let realUrl = url.startsWith("resources/rawfile/") ? $rawfile(url.replace("resources/rawfile/", "")) : url;
    let headers = urlRequest.getHeaders();
    if (headers != null) {
      this.controller.loadUrl(realUrl, this.toWebHeaders(headers));
      return;
    }
    this.controller.loadUrl(realUrl);
  }

  async postUrl(url: string, postData: ArrayBuffer) {
    await this.waitControllerAttached();
    this.controller.postUrl(url, postData);
  }

  async loadDataWithBaseURL(baseUrl: string, data: string, mimeType: string, encoding: string, historyUrl: string) {
    await this.waitControllerAttached();
    this.controller.loadData(data, mimeType, encoding, baseUrl, historyUrl)
  }

  async loadFile(assetFilePath: string) {
    await this.waitControllerAttached();
    this.controller.loadUrl(assetFilePath)
  }

  getController(): web_webview.WebviewController {
    return this.controller;
  }

  public evaluateJavascript(source: string, contentWorld: ContentWorld, resultCallback: ValueCallback<string>): void {
    // this.injectDeferredObject(source, contentWorld, null, resultCallback);
  }

  public getPlugin(): InAppWebViewFlutterPlugin {
    return this.plugin;
  }

  public getWebMessageChannels(): Map<string, WebMessageChannel> {
    return this.webMessageChannels;
  }

  private onControllerAttached = () => {
    Log.d(TAG, "onControllerAttached");
    this.controllerAttached = true
  }

  private toWebHeaders(headers: Map<string, string>): Array<web_webview.WebHeader> {
    let result: Array<web_webview.WebHeader> = new Array;
    if (headers == null || headers.size == 0) {
      return result;
    }
    for (let arr of headers) {
      let key = arr[0];
      let value = arr[1];
      let header: web_webview.WebHeader = {
        headerKey: key, headerValue: value
      };
      result.push(header);
    }
    return result;
  }

  private async waitControllerAttached() {
    if (!this.controllerAttached) {
      await this.checkControllerAttached()
    }
  }

  private checkControllerAttached(): Promise<void> {
    return new Promise((resolve, reject) => {
      try {
        let intervalId = setInterval(() => {
          if (this.controllerAttached) {
            clearInterval(intervalId)
            resolve()
          }
        }, 20)
      } catch (err) {
        reject()
      }
    })
  }

  async prepare() {
    // TODO 1 init webViewAssetLoaderExt 暂时没有做这里面缺少安卓那种WebViewAssetLoader
    this.javaScriptBridgeInterface = new JavaScriptBridgeInterface(this);

    this.inAppWebViewChromeClient = new InAppWebViewChromeClient(this.plugin, this);

    if (this.windowId == null || this.windowId == undefined) {
      this.prepareAndAddUserScripts();
    }

    await this.waitControllerAttached()
    this.controller.registerJavaScriptProxy(this.javaScriptBridgeInterface, JavaScriptBridgeJS.JAVASCRIPT_BRIDGE_NAME, this.javaScriptBridgeInterface.getMethodList());
  }

  private prepareAndAddUserScripts(): void {
    this.userContentController.addPluginScript(PromisePolyfillJS.PROMISE_POLYFILL_JS_PLUGIN_SCRIPT);
    this.userContentController.addPluginScript(JavaScriptBridgeJS.JAVASCRIPT_BRIDGE_JS_PLUGIN_SCRIPT);
    this.userContentController.addPluginScript(ConsoleLogJS.CONSOLE_LOG_JS_PLUGIN_SCRIPT);
    this.userContentController.addPluginScript(PrintJS.PRINT_JS_PLUGIN_SCRIPT);
    this.userContentController.addPluginScript(OnWindowBlurEventJS.ON_WINDOW_BLUR_EVENT_JS_PLUGIN_SCRIPT);
    this.userContentController.addPluginScript(OnWindowFocusEventJS.ON_WINDOW_FOCUS_EVENT_JS_PLUGIN_SCRIPT);
    this.interceptOnlyAsyncAjaxRequestsPluginScript = InterceptAjaxRequestJS.createInterceptOnlyAsyncAjaxRequestsPluginScript(
      this.customSettings.interceptOnlyAsyncAjaxRequests);
    if (this.customSettings.useShouldInterceptAjaxRequest) {
      this.userContentController.addPluginScript(this.interceptOnlyAsyncAjaxRequestsPluginScript);
      this.userContentController.addPluginScript(InterceptAjaxRequestJS.INTERCEPT_AJAX_REQUEST_JS_PLUGIN_SCRIPT);
    }
    if (this.customSettings.useShouldInterceptFetchRequest) {
      this.userContentController.addPluginScript(InterceptFetchRequestJS.INTERCEPT_FETCH_REQUEST_JS_PLUGIN_SCRIPT);
    }
    if (this.customSettings.useOnLoadResource) {
      this.userContentController.addPluginScript(OnLoadResourceJS.ON_LOAD_RESOURCE_JS_PLUGIN_SCRIPT);
    }
    if (!this.customSettings.useHybridComposition) {
      this.userContentController.addPluginScript(PluginScriptsUtil.CHECK_GLOBAL_KEY_DOWN_EVENT_TO_HIDE_CONTEXT_MENU_JS_PLUGIN_SCRIPT);
    }
    this.userContentController.addUserOnlyScripts(this.initialUserOnlyScripts);
  }

  hideContextMenu() {
    // TODO
  }

  getView(): DVModel {
    if (this.ohosWebViewModel == null) {
      this.ohosWebViewModel = createDVModelFromJson(new DVModelJson(
        "other",
        [],
        {
          src: "",
          controller: this.controller,
          onControllerAttached: this.onControllerAttached,
          onAlert: this.inAppWebViewChromeClient!.onAlert,
          onBeforeUnload: this.inAppWebViewChromeClient!.onBeforeUnload,
          onConfirm: this.inAppWebViewChromeClient!.onConfirm,
          onPrompt: this.inAppWebViewChromeClient!.onPrompt,
          onConsole: this.inAppWebViewChromeClient!.onConsole,
          onDownloadStart: this.inAppWebViewChromeClient!.onDownloadStart,
          onErrorReceive: this.inAppWebViewChromeClient!.onErrorReceive,
          onHttpErrorReceive: this.inAppWebViewChromeClient!.onHttpErrorReceive,
          onPageBegin: this.inAppWebViewChromeClient!.onPageBegin,
          onPageEnd: this.inAppWebViewChromeClient!.onPageEnd,
          onProgressChange: this.inAppWebViewChromeClient!.onProgressChange,
          onTitleReceive: this.inAppWebViewChromeClient!.onTitleReceive,
          onRefreshAccessedHistory: this.inAppWebViewChromeClient!.onRefreshAccessedHistory,
          onRenderExited: this.inAppWebViewChromeClient!.onRenderExited,
          onShowFileSelector: this.inAppWebViewChromeClient!.onShowFileSelector,
          onResourceLoad: this.inAppWebViewChromeClient!.onResourceLoad,
          onScaleChange: this.inAppWebViewChromeClient!.onScaleChange,
          onInterceptRequest: this.inAppWebViewChromeClient!.onInterceptRequest,
          onHttpAuthRequest: this.inAppWebViewChromeClient!.onHttpAuthRequest,
          onSslErrorEventReceive: this.inAppWebViewChromeClient!.onSslErrorEventReceive,
          onClientAuthenticationRequest: this.inAppWebViewChromeClient!.onClientAuthenticationRequest,
          onPermissionRequest: this.inAppWebViewChromeClient!.onPermissionRequest,
          onContextMenuShow: this.inAppWebViewChromeClient!.onContextMenuShow,
          onContextMenuHide: this.inAppWebViewChromeClient!.onContextMenuHide,
          onScroll: this.inAppWebViewChromeClient!.onScroll,
          onGeolocationShow: this.inAppWebViewChromeClient!.onGeolocationShow,
          onGeolocationHide: this.inAppWebViewChromeClient!.onGeolocationHide,
          onFullScreenEnter: this.inAppWebViewChromeClient!.onFullScreenEnter,
          onFullScreenExit: this.inAppWebViewChromeClient!.onFullScreenExit,
          onWindowNew: this.inAppWebViewChromeClient!.onWindowNew,
          onWindowExit: this.inAppWebViewChromeClient!.onWindowExit,
          onSearchResultReceive: this.inAppWebViewChromeClient!.onSearchResultReceive,
          onDataResubmitted: this.inAppWebViewChromeClient!.onDataResubmitted,
          onPageVisible: this.inAppWebViewChromeClient!.onPageVisible,
          onInterceptKeyEvent: this.inAppWebViewChromeClient!.onInterceptKeyEvent,
          onTouchIconUrlReceived: this.inAppWebViewChromeClient!.onTouchIconUrlReceived,
          onFaviconReceived: this.inAppWebViewChromeClient!.onFaviconReceived,
          onAudioStateChanged: this.inAppWebViewChromeClient!.onAudioStateChanged,
          onFirstContentfulPaint: this.inAppWebViewChromeClient!.onFirstContentfulPaint,
          onLoadIntercept: this.inAppWebViewChromeClient!.onLoadIntercept,
          onRequestSelected: this.inAppWebViewChromeClient!.onRequestSelected,
          onScreenCaptureRequest: this.inAppWebViewChromeClient!.onScreenCaptureRequest,
          onOverScroll: this.inAppWebViewChromeClient!.onOverScroll,
          onNavigationEntryCommitted: this.inAppWebViewChromeClient!.onNavigationEntryCommitted,
          onSafeBrowsingCheckResult: this.inAppWebViewChromeClient!.onSafeBrowsingCheckResult,
          onNativeEmbedLifecycleChange: this.inAppWebViewChromeClient!.onNativeEmbedLifecycleChange,
          onNativeEmbedGestureEvent: this.inAppWebViewChromeClient!.onNativeEmbedGestureEvent,
          domStorageAccess: this.customSettings.domStorageAccess,
          fileAccess: this.customSettings.fileAccess,
          imageAccess: this.customSettings.imageAccess,
          javaScriptAccess: this.customSettings.javaScriptAccess,
          overScrollMode: this.customSettings.overScrollMode,
          mixedMode: this.customSettings.mixedMode,
          onlineImageAccess: this.customSettings.onlineImageAccess,
          zoomAccess: this.customSettings.zoomAccess,
          overviewModeAccess: this.customSettings.overviewModeAccess,
          databaseAccess: this.customSettings.databaseAccess,
          geolocationAccess: this.customSettings.geolocationAccess,
          mediaPlayGestureAccess: this.customSettings.mediaPlayGestureAccess,
          multiWindowAccess: this.customSettings.multiWindowAccess,
          horizontalScrollBarAccess: this.customSettings.horizontalScrollBarAccess,
          verticalScrollBarAccess: this.customSettings.verticalScrollBarAccess,
          cacheMode: this.customSettings.cacheMode,
          textZoomRatio: this.customSettings.textZoomRatio,
          initialScale: this.customSettings.initialScale,
          blockNetwork: this.customSettings.blockNetwork,
          defaultFixedFontSize: this.customSettings.defaultFixedFontSize,
          defaultFontSize: this.customSettings.defaultFontSize,
          minFontSize: this.customSettings.minFontSize,
          minLogicalFontSize: this.customSettings.minLogicalFontSize,
          webFixedFont: this.customSettings.webFixedFont,
          webSansSerifFont: this.customSettings.webSansSerifFont,
          webSerifFont: this.customSettings.webSerifFont,
          webStandardFont: this.customSettings.webStandardFont,
          webFantasyFont: this.customSettings.webFantasyFont,
          webCursiveFont: this.customSettings.webCursiveFont,
          darkMode: this.customSettings.darkMode,
          forceDarkAccess: this.customSettings.forceDarkAccess,
          pinchSmooth: this.customSettings.pinchSmooth,
          allowWindowOpenMethod: this.customSettings.allowWindowOpenMethod,
          layoutMode: this.customSettings.layoutMode,
          enableNativeEmbedMode: this.customSettings.enableNativeEmbedMode
        },
        {},
        buildOhosWebView
      ));
    }
    return this.ohosWebViewModel;
  }
}