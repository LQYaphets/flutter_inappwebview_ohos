import web_webview from '@ohos.web.webview';
import { MethodResult } from '@ohos/flutter_ohos/src/main/ets/plugin/common/MethodChannel';
import InAppWebViewFlutterPlugin from '../InAppWebViewFlutterPlugin';
import { InAppBrowserDelegate } from '../in_app_browser/InAppBrowserDelegate';
import ContentWorld from '../types/ContentWorld';
import URLRequest from '../types/URLRequest';
import UserContentController from '../types/UserContentController';
import { ValueCallback } from '../types/ValueCallback';
import { WebMessageChannel } from './web_message/WebMessageChannel';
import { HashMap } from '@kit.ArkTS';
import PrintJobSettings from '../print_job/PrintJobSettings';
import WebMessageListener from './web_message/WebMessageListener';

export default interface InAppWebViewInterface {
  loadUrl(urlRequest: URLRequest): void;

  postUrl(url: string, postData: ArrayBuffer): void;

  loadDataWithBaseURL(baseUrl: string, data: string, mimeType: string, encoding: string, historyUrl: string): void;

  loadFile(assetFilePath: string): void;

  getController(): web_webview.WebviewController

  getPlugin(): InAppWebViewFlutterPlugin;

  getWebMessageChannels(): Map<string, WebMessageChannel>;

  getUserContentController(): UserContentController

  evaluateJavascript(source: string, contentWorld: ContentWorld | null, resultCallback: ValueCallback<string> | null): void;

  injectJavascriptFileFromUrl(urlFile: string, scriptHtmlTagAttributes: Map<string, ESObject>): void;

  injectCSSCode(source: string): void

  injectCSSFileFromUrl(urlFile: string, cssLinkHtmlTagAttributes: Map<string, ESObject>): void

  takeScreenshot(screenshotConfiguration: Map<string, ESObject> | null, result: MethodResult): void

  getInAppBrowserDelegate(): InAppBrowserDelegate | null

  getCustomSettings(): Map<string, ESObject> | null

  getCopyBackForwardList(): HashMap<string, ESObject>

  clearAllCache(): void

  scrollTo(x: number, y: number, animated: boolean): void

  scrollBy(x: number, y: number, animated: boolean): void

  printCurrentPage(settings: PrintJobSettings): string | null

  setContextMenu(contextMenu: Map<string, ESObject>): void

  requestFocusNodeHref(): Map<string, ESObject>

  requestImageRef(): Map<string, ESObject>

  createCompatWebMessageChannel(): WebMessageChannel

  addWebMessageListener(webMessageListener: WebMessageListener): void

  canScrollVertically(): boolean

  canScrollHorizontally(): boolean
}