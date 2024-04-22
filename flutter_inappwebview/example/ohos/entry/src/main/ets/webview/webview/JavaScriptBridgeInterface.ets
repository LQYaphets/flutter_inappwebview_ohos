import InAppWebView from './in_app_webview/InAppWebView';

const LOG_TAG = "JSBridgeInterface";

export default class JavaScriptBridgeInterface {
  private inAppWebView: InAppWebView | null;

  constructor(inAppWebView: InAppWebView) {
    this.inAppWebView = inAppWebView;
  }

  _hideContextMenu(): void {
    if (this.inAppWebView == null) {
      return;
    }
    this.inAppWebView.hideContextMenu()
  }

  _callHandler(handlerName: string, callHandlerID: string, args: string): void {
    if (this.inAppWebView == null) {
      return;
    }
    //TODO
  }

  getMethodList(): Array<string> {
    return ["_hideContextMenu", "_callHandler"];
  }

  dispose() {
    this.inAppWebView = null;
  }
}