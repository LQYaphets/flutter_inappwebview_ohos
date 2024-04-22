import web_webview from '@ohos.web.webview';
import InAppWebViewFlutterPlugin from '../InAppWebViewFlutterPlugin';
import ContentWorld from '../types/ContentWorld';
import URLRequest from '../types/URLRequest';
import { ValueCallback } from '../types/ValueCallback';
import { WebMessageChannel } from './web_message/WebMessageChannel';

export default interface InAppWebViewInterface {
  loadUrl(urlRequest: URLRequest): void;

  postUrl(url: string, postData: ArrayBuffer): void;

  loadDataWithBaseURL(baseUrl: string, data: string, mimeType: string, encoding: string, historyUrl: string): void;

  loadFile(assetFilePath: string): void;

  getController(): web_webview.WebviewController

  evaluateJavascript(source: string, contentWorld: ContentWorld | null, resultCallback: ValueCallback<string> | null): void;

  getPlugin(): InAppWebViewFlutterPlugin;

  getWebMessageChannels(): Map<string, WebMessageChannel>;
}