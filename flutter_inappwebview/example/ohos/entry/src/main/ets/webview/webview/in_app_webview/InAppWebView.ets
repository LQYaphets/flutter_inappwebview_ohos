import web_webview from '@ohos.web.webview'
import { DVModel } from '@ohos/flutter_ohos/src/main/ets/view/DynamicView/dynamicView';
import { createDVModelFromJson } from '@ohos/flutter_ohos/src/main/ets/view/DynamicView/dynamicViewJson';
import URLRequest from '../../types/URLRequest';
import InAppWebViewFlutterPlugin from '../../InAppWebViewFlutterPlugin';
import InAppWebViewInterface from '../InAppWebViewInterface';
import { DVModelJson } from './DynamicUtils';
import InAppWebViewSettings from './InAppWebViewSettings';
import { buildOhosWebView } from './OhosWebView';
import { Any, Log, MethodChannel } from '@ohos/flutter_ohos';
import UserScript from '../../types/UserScript';
import JavaScriptBridgeInterface from '../JavaScriptBridgeInterface';
import JavaScriptBridgeJS from '../../plugin_scripts_js/JavaScriptBridgeJS';
import WebViewChannelDelegate from '../WebViewChannelDelegate';
import ContentWorld from '../../types/ContentWorld';
import { ValueCallback } from '../../types/ValueCallback';
import { WebMessageChannel } from '../web_message/WebMessageChannel';
import UserContentController from '../../types/UserContentController';
import util from '@ohos.util';
import Util from '../../Util';
import PluginScriptsUtil from '../../plugin_scripts_js/PluginScriptsUtil';
import { MethodResult } from '@ohos/flutter_ohos/src/main/ets/plugin/common/MethodChannel';
import InAppWebViewChromeClient from './InAppWebViewChromeClient';
import PluginScript from '../../types/PluginScript';
import PromisePolyfillJS from '../../plugin_scripts_js/PromisePolyfillJS';
import ConsoleLogJS from '../../plugin_scripts_js/ConsoleLogJS';
import PrintJS from '../../plugin_scripts_js/PrintJS';
import OnWindowBlurEventJS from '../../plugin_scripts_js/OnWindowBlurEventJS';
import OnWindowFocusEventJS from '../../plugin_scripts_js/OnWindowFocusEventJS';
import InterceptAjaxRequestJS from '../../plugin_scripts_js/InterceptAjaxRequestJS';
import InterceptFetchRequestJS from '../../plugin_scripts_js/InterceptFetchRequestJS';
import OnLoadResourceJS from '../../plugin_scripts_js/OnLoadResourceJS';
import { InAppBrowserDelegate } from '../../in_app_browser/InAppBrowserDelegate';
import { HashMap, List } from '@kit.ArkTS';
import PrintJobSettings from '../../print_job/PrintJobSettings';
import WebMessageListener from '../web_message/WebMessageListener';
import WebViewAssetLoaderExt from '../../types/WebViewAssetLoaderExt';
import ContentBlockerHandler from '../../content_blocker/ContentBlockerHandler';
import ContentBlockerAction from '../../content_blocker/ContentBlockerAction';
import ContentBlockerTrigger from '../../content_blocker/ContentBlockerTrigger';
import ContentBlocker from '../../content_blocker/ContentBlocker';
import accessibility from '@ohos.accessibility';

const TAG = "InAppWebView"
const METHOD_CHANNEL_NAME_PREFIX = "com.pichillilorenzo/flutter_inappwebview_";

export default class InAppWebView implements InAppWebViewInterface {
  private context: Context;
  private plugin: InAppWebViewFlutterPlugin;
  private id: number;
  private windowId: number | null | undefined;
  public customSettings: InAppWebViewSettings;
  private controller: web_webview.WebviewController = new web_webview.WebviewController();
  private ohosWebViewModel: DVModel | null = null;
  private controllerAttached: boolean = false;
  private initialUserOnlyScripts: Array<UserScript>;
  private javaScriptBridgeInterface: JavaScriptBridgeInterface | null = null;
  public channelDelegate: WebViewChannelDelegate;
  public webMessageChannels: Map<string, WebMessageChannel> = new Map<string, WebMessageChannel>()
  private inAppWebViewChromeClient: InAppWebViewChromeClient | null = null;
  public userContentController: UserContentController = new UserContentController(this);
  private interceptOnlyAsyncAjaxRequestsPluginScript: PluginScript | null = null;
  public callAsyncJavaScriptCallbacks: Map<string, ValueCallback<string>> = new Map<string, ValueCallback<string>>()
  public evaluateJavaScriptContentWorldCallbacks: Map<string, ValueCallback<string>> = new Map<string, ValueCallback<string>>()
  public inAppBrowserDelegate: InAppBrowserDelegate | null = null
  private inFullscreen: boolean = false;
  public webViewAssetLoaderExt: WebViewAssetLoaderExt | null = null;
  public contentBlockerHandler = new ContentBlockerHandler();
  public isLoading: boolean = false
  public zoomScale: number = 1.0
  public contextMenu: Map<string, Any> | null = null

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
    if (this.webViewAssetLoaderExt != null) {
      this.webViewAssetLoaderExt.dispose();
      this.webViewAssetLoaderExt = null;
    }
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

  getUrl(): string {
    return this.controller.getUrl()
  }

  getTitle(): string {
    return this.controller.getTitle()
  }

  getProgress(): number {
    throw Error("Ohos currently does not support this feature")
  }

  reload(): void {
    this.controller.refresh();
  }

  canGoBack(): boolean {
    return this.controller.accessBackward()
  }

  goBack(): void {
    this.controller.backward()
  }

  canGoForward(): boolean {
    return this.controller.accessForward()
  }

  goForward(): void {
    this.controller.forward()
  }

  canGoBackOrForward(steps: number): boolean {
    return this.controller.accessStep(steps)
  }

  goBackOrForward(steps: number): void {
    this.controller.backOrForward(steps)
  }

  stopLoading(): void {
    this.controller.stop()
  }

  getLoading(): boolean {
    return this.isLoading
  }

  clearSslPreferences(): void {
    this.controller.clearSslCache()
  }

  findAllAsync(find: string): void {
    this.controller.searchAllAsync(find)
  }

  findNext(forward: boolean): void {
    this.controller.searchNext(forward)
  }

  clearMatches(): void {
    this.controller.clearMatches()
  }

  onPause(): void {
    throw Error("Ohos currently does not support this feature")
  }

  onResume(): void {
    throw Error("Ohos currently does not support this feature")
  }

  pauseTimers(): void {
    throw Error("Ohos currently does not support this feature")
  }

  resumeTimers(): void {
    throw Error("Ohos currently does not support this feature")
  }

  getContentHeight(): number {
    return this.controller.getPageHeight()
  }

  public getContentWidth(callback: ValueCallback<number>): void {
    // this.evaluateJavascript("document.documentElement.scrollWidth;", new ValueCallback<string>() {
    //     public onReceiveValue(value: string | null): void {
    //       let contentWidth: number = null;
    //       if (value != null && !value.equalsIgnoreCase("null")) {
    //         contentWidth = Integer.parseInt(value);
    //       }
    //     callback.onReceiveValue(contentWidth);
    //   }
    // });
  }

  zoomBy(zoomFactor: number): void {
    if (zoomFactor < 0.01)
      throw new Error("zoomFactor must be greater than 0.01.");
    if (zoomFactor > 100.0)
      throw new Error("zoomFactor must be less than 100.");

    this.controller.zoom(zoomFactor)
  }

  getOriginalUrl(): string {
    return this.controller.getOriginalUrl()
  }

  getZoomScale(): number {
    return this.zoomScale
  }

  getHitTestResult(): web_webview.HitTestValue {
    return this.controller.getHitTestValue()
  }

  pageDown(bottom: boolean): boolean {
    try {
      this.controller.pageDown(bottom)
      return true
    } catch (e) {
      throw Error("Jumping to the bottom of the page failed")
    }
  }

  pageUp(top: boolean): boolean {
    try {
      this.controller.pageUp(top)
      return true
    } catch (e) {
      throw Error("Jumping to the top of the page failed")
    }
  }

  zoomIn(): boolean {
    try {
      this.controller.zoomIn()
      return true
    } catch (e) {
      throw Error("Failed to perform amplification operation")
    }
  }

  zoomOut(): boolean {
    try {
      this.controller.zoomOut()
      return true
    } catch (e) {
      throw Error("Failed to perform shrink operation")
    }
  }

  clearFocus(): void {
    this.controller.onInactive
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

  public takeScreenshot(screenshotConfiguration: Map<string, Any> | null, result: MethodResult): void {

  }

  public evaluateJavascript(source: string, contentWorld: ContentWorld, resultCallback: ValueCallback<string> | null): void {
    // this.injectDeferredObject(source, contentWorld, null, resultCallback);
  }

  public injectCSSCode(source: string): void {
    let jsWrapper: string = "(function(d) { var style = d.createElement('style'); style.innerHTML = %s;" +
      " if (d.head != null) { d.head.appendChild(style); } })(document);";
    this.injectDeferredObject(source, null, jsWrapper, null);
  }

  public injectCSSFileFromUrl(urlFile: string, cssLinkHtmlTagAttributes: Map<string, Any> | null): void {
    let cssLinkAttributes: string = "";
    let alternateStylesheet: string = "";
    if (cssLinkHtmlTagAttributes != null) {
      let idAttr: string = cssLinkHtmlTagAttributes.get("id") as string;
      if (idAttr != null) {
        // cssLinkAttributes += " link.id = '" + idAttr.replaceAll("'", "\\\\'") + "'; ";
        cssLinkAttributes += " link.id = '" + idAttr.replace(/'/g, "\\\\'") + "'; ";
      }
      let mediaAttr: string = cssLinkHtmlTagAttributes.get("media") as string;
      if (mediaAttr != null) {
        // cssLinkAttributes += " link.media = '" + mediaAttr.replaceAll("'", "\\\\'") + "'; ";
        cssLinkAttributes += " link.media = '" + mediaAttr.replace(/'/g, "\\\\'") + "'; ";
      }
      let crossOriginAttr: string = cssLinkHtmlTagAttributes.get("crossOrigin") as string;
      if (crossOriginAttr != null) {
        // cssLinkAttributes += " link.crossOrigin = '" + crossOriginAttr.replaceAll("'", "\\\\'") + "'; ";
        cssLinkAttributes += " link.crossOrigin = '" + crossOriginAttr.replace(/'/g, "\\\\'") + "'; ";
      }
      let integrityAttr: string = cssLinkHtmlTagAttributes.get("integrity") as string;
      if (integrityAttr != null) {
        // cssLinkAttributes += " link.integrity = '" + integrityAttr.replaceAll("'", "\\\\'") + "'; ";
        cssLinkAttributes += " link.integrity = '" + integrityAttr.replace(/'/g, "\\\\'") + "'; ";
      }
      let referrerPolicyAttr: string = cssLinkHtmlTagAttributes.get("referrerPolicy") as string;
      if (referrerPolicyAttr != null) {
        // cssLinkAttributes += " link.referrerPolicy = '" + referrerPolicyAttr.replaceAll("'", "\\\\'") + "'; ";
        cssLinkAttributes += " link.referrerPolicy = '" + referrerPolicyAttr.replace(/'/g, "\\\\'") + "'; ";
      }
      let disabledAttr: boolean = cssLinkHtmlTagAttributes.get("disabled") as boolean;
      if (disabledAttr != null && disabledAttr) {
        cssLinkAttributes += " link.disabled = true; ";
      }
      let alternateAttr: boolean = cssLinkHtmlTagAttributes.get("alternate") as boolean;
      if (alternateAttr != null && alternateAttr) {
        alternateStylesheet = "alternate ";
      }
      let titleAttr: string = cssLinkHtmlTagAttributes.get("title") as string;
      if (titleAttr != null) {
        // cssLinkAttributes += " link.title = '" + titleAttr.replaceAll("'", "\\\\'") + "'; ";
        cssLinkAttributes += " link.title = '" + titleAttr.replace(/'/g, "\\\\'") + "'; ";
      }
    }
    let jsWrapper: string = "(function(d) { var link = d.createElement('link'); link.rel='" + alternateStylesheet + "stylesheet'; link.type='text/css'; " +
            cssLinkAttributes + " link.href = %s; if (d.head != null) { d.head.appendChild(link); } })(document);";
    this.injectDeferredObject(urlFile, null, jsWrapper, null);
  }

  public injectJavascriptFileFromUrl(urlFile: string, scriptHtmlTagAttributes: Map<string, Any> | null): void {
    let scriptAttributes: string = "";
    if (scriptHtmlTagAttributes != null) {
      let typeAttr: string = scriptHtmlTagAttributes.get("type") as string;
      if (typeAttr != null) {
        // scriptAttributes += " script.type = '" + typeAttr.replaceAll("'", "\\\\'") + "'; ";
        scriptAttributes += " script.type = '" + typeAttr.replace(/'/g, "\\\\'") + "'; ";
      }
      let idAttr: string = scriptHtmlTagAttributes.get("id") as string;
      if (idAttr != null) {
        // let scriptIdEscaped: string = idAttr.replaceAll("'", "\\\\'");
        let scriptIdEscaped: string = idAttr.replace(/'/g, "\\\\'");
        scriptAttributes += " script.id = '" + scriptIdEscaped + "'; ";
        scriptAttributes += " script.onload = function() {" +
        "  if (window." + JavaScriptBridgeJS.JAVASCRIPT_BRIDGE_NAME + " != null) {" +
        "    window." + JavaScriptBridgeJS.JAVASCRIPT_BRIDGE_NAME + ".callHandler('onInjectedScriptLoaded', '" + scriptIdEscaped + "');" +
        "  }" +
        "};";
        scriptAttributes += " script.onerror = function() {" +
        "  if (window." + JavaScriptBridgeJS.JAVASCRIPT_BRIDGE_NAME + " != null) {" +
        "    window." + JavaScriptBridgeJS.JAVASCRIPT_BRIDGE_NAME + ".callHandler('onInjectedScriptError', '" + scriptIdEscaped + "');" +
        "  }" +
        "};";
      }
      let asyncAttr: boolean = scriptHtmlTagAttributes.get("async") as boolean;
      if (asyncAttr != null && asyncAttr) {
        scriptAttributes += " script.async = true; ";
      }
      let deferAttr: boolean = scriptHtmlTagAttributes.get("defer") as boolean;
      if (deferAttr != null && deferAttr) {
        scriptAttributes += " script.defer = true; ";
      }
      let crossOriginAttr: string = scriptHtmlTagAttributes.get("crossOrigin") as string;
      if (crossOriginAttr != null) {
        // scriptAttributes += " script.crossOrigin = '" + crossOriginAttr.replaceAll("'", "\\\\'") + "'; ";
        scriptAttributes += " script.crossOrigin = '" + crossOriginAttr.replace(/'/g, "\\\\'") + "'; ";
      }
      let integrityAttr: string = scriptHtmlTagAttributes.get("integrity") as string;
      if (integrityAttr != null) {
        // scriptAttributes += " script.integrity = '" + integrityAttr.replaceAll("'", "\\\\'") + "'; ";
        scriptAttributes += " script.integrity = '" + integrityAttr.replace(/'/g, "\\\\'") + "'; ";
      }
      let noModuleAttr: boolean = scriptHtmlTagAttributes.get("noModule") as boolean;
      if (noModuleAttr != null && noModuleAttr) {
        scriptAttributes += " script.noModule = true; ";
      }
      let nonceAttr: string = scriptHtmlTagAttributes.get("nonce") as string;
      if (nonceAttr != null) {
        // scriptAttributes += " script.nonce = '" + nonceAttr.replaceAll("'", "\\\\'") + "'; ";
        scriptAttributes += " script.nonce = '" + nonceAttr.replace(/'/g, "\\\\'") + "'; ";
      }
      let referrerPolicyAttr: string = scriptHtmlTagAttributes.get("referrerPolicy") as string;
      if (referrerPolicyAttr != null) {
        // scriptAttributes += " script.referrerPolicy = '" + referrerPolicyAttr.replaceAll("'", "\\\\'") + "'; ";
        scriptAttributes += " script.referrerPolicy = '" + referrerPolicyAttr.replace(/'/g, "\\\\'") + "'; ";
      }
    }
    let jsWrapper: string = "(function(d) { var script = d.createElement('script'); " + scriptAttributes +
            " script.src = %s; if (d.body != null) { d.body.appendChild(script); } })(document);";
    this.injectDeferredObject(urlFile, null, jsWrapper, null);
  }

  public injectDeferredObject(source: string, contentWorld: ContentWorld | null, jsWrapper: string, resultCallback: ValueCallback<string> | null): void {
    let resultUuid: string | null = contentWorld != null && !contentWorld.equals(ContentWorld.PAGE) ? util.generateRandomUUID(true).toString() : null
    let scriptToInject: string = source
    if (jsWrapper != null) {
      // org.json.JSONArray jsonEsc = new org.json.JSONArray();
      // jsonEsc.put(source);
      // let jsonRepr: string = jsonEsc.toString();
      // let jsonSourceString: string = jsonRepr.substring(1, jsonRepr.length() - 1);
      // scriptToInject = String.format(jsWrapper, jsonSourceString);
    }
    if (resultUuid != null && resultCallback != null) {
      this.evaluateJavaScriptContentWorldCallbacks.set(resultUuid, resultCallback);
      scriptToInject = Util.replaceAll(PluginScriptsUtil.EVALUATE_JAVASCRIPT_WITH_CONTENT_WORLD_WRAPPER_JS_SOURCE,
        PluginScriptsUtil.VAR_RANDOM_NAME, "_" + JavaScriptBridgeJS.JAVASCRIPT_BRIDGE_NAME + "_" + Math.round(Math.random() * 1000000))
        .replace(PluginScriptsUtil.VAR_PLACEHOLDER_VALUE, UserContentController.escapeCode(source))
        .replace(PluginScriptsUtil.VAR_RESULT_UUID, resultUuid);
    }
  }

  public getInAppBrowserDelegate(): InAppBrowserDelegate | null {
    return this.inAppBrowserDelegate;
  }

  public getCopyBackForwardList(): HashMap<string, Any> {
    // let currentList: WebBackForwardList = copyBackForwardList();
    // let currentSize: number = currentList.getSize();
    // let currentIndex: number = currentList.getCurrentIndex();
    //
    // let history: List<HashMap<String, String>> = new List<HashMap<String, String>>();
    //
    // for (let i: number = 0; i < currentSize; i++) {
    //   let historyItem: WebHistoryItem = currentList.getItemAtIndex(i);
    //   let historyItemMap: HashMap<string, string> = new HashMap<string, string>();
    //
    //   historyItemMap.set("originalUrl", historyItem.getOriginalUrl());
    //   historyItemMap.set("title", historyItem.getTitle());
    //   historyItemMap.set("url", historyItem.getUrl());
    //
    //   history.add(historyItemMap);
    // }
    //
    // let result: HashMap<string, Any> = new HashMap<string, Any>();
    //
    // result.set("list", history);
    // result.set("currentIndex", currentIndex);
    //
    // return result;
    return new HashMap<string, Any>()
  }

  public clearAllCache(): void {
    this.controller.removeCache(true);
    this.clearCookies();
  }

  public scrollTo(x: number, y: number, animated: boolean): void {
    if (animated) {
      // let pvhX: PropertyValuesHolder = PropertyValuesHolder.ofInt("scrollX", x);
      // let pvhY: PropertyValuesHolder = PropertyValuesHolder.ofInt("scrollY", y);
      // let anim: ObjectAnimator = ObjectAnimator.ofPropertyValuesHolder(this, pvhX, pvhY);
      // anim.setDuration(300).start();
    } else {
      this.controller.scrollTo(x, y);
    }
  }

  public scrollBy(x: number, y: number, animated: boolean): void {
    if (animated) {
      // let pvhX: PropertyValuesHolder = PropertyValuesHolder.ofInt("scrollX", getScrollX() + x);
      // let pvhY: PropertyValuesHolder = PropertyValuesHolder.ofInt("scrollY", getScrollY() + y);
      // let anim: PropertyValuesHolder = ObjectAnimator.ofPropertyValuesHolder(this, pvhX, pvhY);
      // anim.setDuration(300).start();
    } else {
      this.controller.scrollBy(x, y);
    }
  }

  clearCookies(): void {
    web_webview.WebCookieManager.clearAllCookiesSync()
  }

  public printCurrentPage(settings: PrintJobSettings): string | null {
    return null;
  }

  public setSettings(newCustomSettings: InAppWebViewSettings, newSettingsMap: Map<string, Any>): void {
    throw new Error('Method not implemented.')
  }

  public getCustomSettings(): Map<string, Any> | null {
    return this.customSettings != null ? this.customSettings.getRealSettings(this) : null
  }

  public setContextMenu(contextMenu: Map<string, Any>): void {
    this.contextMenu = contextMenu;
  }

  public requestFocusNodeHref(): Map<string, Any> {
    // let msg: Message = InAppWebView.mHandler.obtainMessage();
    // this.requestFocusNodeHref(msg);
    // Bundle bundle = msg.peekData();

    // let obj: Map<string, Any> = new Map<string, Any>();
    // obj.set("src", bundle.getString("src"));
    // obj.set("url", bundle.getString("url"));
    // obj.set("title", bundle.getString("title"));
    //
    // return obj;
    return new Map<string, Any>()
  }

  public requestImageRef(): Map<string, Any> {
    // let msg: Message = InAppWebView.mHandler.obtainMessage();
    // this.requestImageRef(msg);
    // Bundle bundle = msg.peekData();
    //
    // let obj: Map<string, Any> = new Map<string, Any>();
    // obj.set("url", bundle.getString("url"));
    //
    // return obj;
    return new Map<string, Any>()
  }

  public createCompatWebMessageChannel(): WebMessageChannel {
    let id: string = util.generateRandomUUID(true).toString();
    let webMessageChannel: WebMessageChannel = new WebMessageChannel(id, this);
    this.webMessageChannels.set(id, webMessageChannel);
    return webMessageChannel;
  }

  public addWebMessageListener(webMessageListener: WebMessageListener): void {
    // if (WebViewFeature.isFeatureSupported(WebViewFeature.WEB_MESSAGE_LISTENER)) {
    //   WebViewCompat.addWebMessageListener(this, webMessageListener.jsObjectName, webMessageListener.allowedOriginRules, webMessageListener.listener);
    //   webMessageListeners.add(webMessageListener);
    // }
  }

  public canScrollVertically(): boolean {
    // return computeVerticalScrollRange() > computeVerticalScrollExtent();
    return false;
  }

  public canScrollHorizontally(): boolean {
    // return computeHorizontalScrollRange() > computeHorizontalScrollExtent();
    return false;
  }

  public isInFullscreen(): boolean {
    return this.inFullscreen;
  }

  public getPlugin(): InAppWebViewFlutterPlugin {
    return this.plugin;
  }

  public getWebMessageChannels(): Map<string, WebMessageChannel> {
    return this.webMessageChannels;
  }

  public getUserContentController(): UserContentController {
    return this.userContentController;
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
    if (this.plugin != null) {
      this.webViewAssetLoaderExt = WebViewAssetLoaderExt.fromMap(this.customSettings.webViewAssetLoader, this.plugin, getContext());
    }

    this.javaScriptBridgeInterface = new JavaScriptBridgeInterface(this);

    this.inAppWebViewChromeClient = new InAppWebViewChromeClient(this.plugin, this);

    if (this.windowId == null || this.windowId == undefined) {
      this.prepareAndAddUserScripts();
    }

    this.contentBlockerHandler.getRuleList().clear();
    this.customSettings.contentBlockers.forEach((contentBlocker : Any) => {
      let trigger = ContentBlockerTrigger.fromMap(contentBlocker.get("trigger"));
      let action = ContentBlockerAction.fromMap(contentBlocker.get("action"));
      this.contentBlockerHandler.getRuleList().add(new ContentBlocker(trigger, action));
    })

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