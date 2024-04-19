import { DVModel } from '@ohos/flutter_ohos/src/main/ets/view/DynamicView/dynamicView';
import PlatformWebView from '../PlatformWebView';
import InAppWebViewFlutterPlugin from '../../InAppWebViewFlutterPlugin';
import InAppWebView from './InAppWebView';
import InAppWebViewSettings from './InAppWebViewSettings';
import URLRequest from '../../types/URLRequest';

export class FlutterWebView extends PlatformWebView {
  private webView: InAppWebView | null;

  constructor(plugin: InAppWebViewFlutterPlugin, context: Context, id: number, params: Map<string, ESObject>) {
    super();
    let initialSettings: Map<string, ESObject> = params.get("initialSettings");
    let windowId = params.get("windowId") as number;

    let customSettings = new InAppWebViewSettings();
    customSettings.parse(initialSettings);
    this.webView = new InAppWebView(context, plugin, id, windowId, customSettings)
    // TODO PullToRefreshSettings
  }

  makeInitialLoad(params: Map<string, ESObject>): void {
    if (this.webView == null) {
      return;
    }
    let windowId = params.get("windowId") as number;
    let initialUrlRequest: Map<string, ESObject> = params.get("initialUrlRequest");
    let initialFile = params.get("initialFile") as string;
    let initialData: Map<string, ESObject> = params.get("initialData");
    if (windowId != null && windowId != undefined) {
      // TODO
    } else {
      if (initialFile != null) {
        this.webView!.loadFile(initialFile);
      }
      else if (initialData != null) {
        let data = initialData.get("data") as string;
        let mimeType = initialData.get("mimeType") as string;
        let encoding = initialData.get("encoding") as string;
        let baseUrl = initialData.get("baseUrl") as string;
        let historyUrl = initialData.get("historyUrl") as string;
        this.webView!.loadDataWithBaseURL(baseUrl, data, mimeType, encoding, historyUrl);
      }
      else if (initialUrlRequest != null) {
        let urlRequest = URLRequest.fromMap(initialUrlRequest);
        if (urlRequest != null) {
          this.webView!.loadUrl(urlRequest);
        }
      }
    }
  }

  getView(): DVModel {
    return this.webView!.getView()
  }

  dispose(): void {
    if (this.webView != null) {
      this.webView.dispose();
      this.webView = null;
    }
  }
}