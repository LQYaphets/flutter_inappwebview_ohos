import web_webview from '@ohos.web.webview';
import { MethodResult } from '@ohos/flutter_ohos/src/main/ets/plugin/common/MethodChannel';
import InAppWebViewFlutterPlugin from '../InAppWebViewFlutterPlugin';
import ContentWorld from '../types/ContentWorld';
import URLRequest from '../types/URLRequest';
import UserContentController from '../types/UserContentController';
import { ValueCallback } from '../types/ValueCallback';
import { WebMessageChannel } from './web_message/WebMessageChannel';

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
}