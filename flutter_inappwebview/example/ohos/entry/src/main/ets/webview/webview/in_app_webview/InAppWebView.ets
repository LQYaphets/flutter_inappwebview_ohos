import web_webview from '@ohos.web.webview'
import { DVModel } from '@ohos/flutter_ohos/src/main/ets/view/DynamicView/dynamicView';
import { createDVModelFromJson } from '@ohos/flutter_ohos/src/main/ets/view/DynamicView/dynamicViewJson';
import URLRequest from 'ets/plugins/types/URLRequest';
import InAppWebViewFlutterPlugin from '../../InAppWebViewFlutterPlugin';
import InAppWebViewInterface from '../InAppWebViewInterface';
import { DVModelJson } from './DynamicUtils';
import InAppWebViewSettings from './InAppWebViewSettings';
import { buildOhosWebView } from './OhosWebView';
import { Log } from '@ohos/flutter_ohos';

const TAG = "InAppWebView"

export default class InAppWebView implements InAppWebViewInterface {
  private context: Context;
  private plugin: InAppWebViewFlutterPlugin;
  private id: number;
  private windowId: number | null | undefined;
  private customSettings: InAppWebViewSettings;
  private webCookieManager: web_webview.WebCookieManager = new web_webview.WebCookieManager();
  private controller: web_webview.WebviewController = new web_webview.WebviewController();
  private scrollX: number = 0;
  private scrollY: number = 0;
  private ohosWebViewModel: DVModel | null = null;
  private controllerAttached: boolean = false;

  constructor(context: Context, plugin: InAppWebViewFlutterPlugin, id: number, windowId: number | null | undefined, customSettings: InAppWebViewSettings) {
    this.context = context;
    this.plugin = plugin;
    this.id = id;
    this.windowId = windowId;
    this.customSettings = customSettings;
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

  private onControllerAttached = () => {
    Log.d(TAG, "onControllerAttached");
    this.controllerAttached = true
  }
  private onDownloadStart = (event: ESObject) => {

  }
  private onPageBegin = (event: ESObject) => {

  }
  private onPageEnd = (event: ESObject) => {

  }
  private onErrorReceive = (event: ESObject) => {

  }
  private onLoadIntercept = (event: ESObject) => {
    return false;
  }
  private onRefreshAccessedHistory = (event: ESObject) => {

  }
  private onProgressChange = (event: ESObject) => {

  }
  private onGeolocationShow = (event: ESObject) => {

  }
  private onGeolocationHide = () => {

  }
  private onShowFileSelector = (event: ESObject) => {
    return false;
  }
  private onPermissionRequest = (event: ESObject) => {

  }
  private onConsoleMessage = (event: ESObject) => {
    return false;
  }
  private onWindowNew = (event: ESObject) => {

  }
  private onWindowExit = () => {

  }
  private onScroll = (event: ESObject) => {
    this.scrollX = event.xOffset;
    this.scrollY = event.yOffset;
  }

  getView(): DVModel {
    if (this.ohosWebViewModel == null) {
      this.ohosWebViewModel = createDVModelFromJson(new DVModelJson(
        "other",
        [],
        {
          src: "",
          controller: this.controller,
          onDownloadStart: this.onDownloadStart,
          onPageBegin: this.onPageBegin,
          onPageEnd: this.onPageEnd,
          onErrorReceive: this.onErrorReceive,
          onLoadIntercept: this.onLoadIntercept,
          onRefreshAccessedHistory: this.onRefreshAccessedHistory,
          onProgressChange: this.onProgressChange,
          onGeolocationShow: this.onGeolocationShow,
          onGeolocationHide: this.onGeolocationHide,
          onShowFileSelector: this.onShowFileSelector,
          onPermissionRequest: this.onPermissionRequest,
          onConsoleMessage: this.onConsoleMessage,
          onWindowNew: this.onWindowNew,
          onWindowExit: this.onWindowExit,
          onScroll: this.onScroll,
          onControllerAttached: this.onControllerAttached,
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

  private checkControllerAttached(): Promise<number> {
    return new Promise((resolve, reject) => {
      try {
        let intervalId = setInterval(() => {
          if (this.controllerAttached) {
            clearInterval(intervalId)
            resolve(0)
          }
        }, 20)
      } catch (err) {
        reject()
      }
    })
  }
}