import { Any, Log } from '@ohos/flutter_ohos';
import JavaScriptBridgeJS from '../plugin_scripts_js/JavaScriptBridgeJS';
import PrintJobSettings from '../print_job/PrintJobSettings';
import InAppWebView from './in_app_webview/InAppWebView';
import { CallJsHandlerCallback, PrintRequestCallback } from './WebViewChannelDelegate';

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
    if (handlerName == "onPrintRequest") {
      let settings = new PrintJobSettings();
      settings.handledByClient = true;
      let printJobId = this.inAppWebView.printCurrentPage(settings);
      if (printJobId != null && this.inAppWebView != null && this.inAppWebView.channelDelegate != null) {
        this.inAppWebView.channelDelegate.onPrintRequest(this.inAppWebView.getUrl(), printJobId, new InnerPrintRequestCallback(this.inAppWebView, printJobId));
      }
      return;
    } else if (handlerName == "callAsyncJavaScript") {
      try {
        let jsonObject: Any = JSON.parse(args)
        let resultUuid: string = jsonObject[0].resultUuid;
        let callAsyncJavaScriptCallback = this.inAppWebView.callAsyncJavaScriptCallbacks.get(resultUuid);
        if (callAsyncJavaScriptCallback != null) {
          callAsyncJavaScriptCallback.onReceiveValue(jsonObject.toString());
          this.inAppWebView.callAsyncJavaScriptCallbacks.delete(resultUuid);
        }
      } catch (e) {
        Log.e(LOG_TAG, "", e);
      }
      return;
    } else if (handlerName == "evaluateJavaScriptWithContentWorld") {
      try {
        let jsonObject: Any = JSON.parse(args)
        let resultUuid: string = jsonObject[0].resultUuid;
        let evaluateJavaScriptCallback = this.inAppWebView.evaluateJavaScriptContentWorldCallbacks.get(resultUuid);
        if (evaluateJavaScriptCallback != null) {
          evaluateJavaScriptCallback.onReceiveValue(jsonObject.has("value") ? jsonObject.get("value")
            .toString() : "null");
          this.inAppWebView.evaluateJavaScriptContentWorldCallbacks.delete(resultUuid);
        }
      } catch (e) {
        Log.e(LOG_TAG, "", e);
      }
      return;
    }
    if (this.inAppWebView.channelDelegate != null) {
      this.inAppWebView.channelDelegate.onCallJsHandler(handlerName, args, new InnerCallJsHandlerCallback(this.inAppWebView, callHandlerID));
    }
  }

  getMethodList(): Array<string> {
    return ["_hideContextMenu", "_callHandler"];
  }

  dispose() {
    this.inAppWebView = null;
  }
}

class InnerPrintRequestCallback extends PrintRequestCallback {
  private inAppWebView: InAppWebView;
  private printJobId: string;

  constructor(inAppWebView: InAppWebView, printJobId: string) {
    super();
    this.inAppWebView = inAppWebView;
    this.printJobId = printJobId;
  }

  nonNullSuccess(handledByClient: boolean): boolean {
    return !handledByClient;
  }

  defaultBehaviour(handledByClient: boolean | null) {
    if (this.inAppWebView != null && this.inAppWebView.plugin != null && this.inAppWebView.plugin.printJobManager != null) {
      let printJobController = this.inAppWebView.plugin.printJobManager.jobs.get(this.printJobId);
      if (printJobController != null) {
        printJobController.disposeNoCancel();
      }
    }
  }

  error(errorCode: string, errorMessage: string, errorDetails: Any) {
    Log.e(LOG_TAG, errorCode + ", " + ((errorMessage != null) ? errorMessage : ""));
    this.defaultBehaviour(null);
  }
}

class InnerCallJsHandlerCallback extends CallJsHandlerCallback {
  private inAppWebView: InAppWebView;
  private _callHandlerID: string;

  constructor(inAppWebView: InAppWebView, _callHandlerID: string) {
    super();
    this.inAppWebView = inAppWebView;
    this._callHandlerID = _callHandlerID;
  }

  defaultBehaviour(json: Any | null) {
    if (this.inAppWebView == null) {
      // The webview has already been disposed, ignore.
      return;
    }
    let sourceCode = "if (window." + JavaScriptBridgeJS.JAVASCRIPT_BRIDGE_NAME + "[" + this._callHandlerID + "] != null) { " +
      "window." + JavaScriptBridgeJS.JAVASCRIPT_BRIDGE_NAME + "[" + this._callHandlerID + "].resolve(" + json + "); " +
      "delete window." + JavaScriptBridgeJS.JAVASCRIPT_BRIDGE_NAME + "[" + this._callHandlerID + "]; " +
      "}";
    this.inAppWebView.controller.runJavaScriptExt(sourceCode);
  }

  error(errorCode: string, errorMessage: string, errorDetails: Any) {
    let message = errorCode + ((errorMessage != null) ? ", " + errorMessage : "");
    Log.e(LOG_TAG, message);

    if (this.inAppWebView == null) {
      // The webview has already been disposed, ignore.
      return;
    }

    let sourceCode = "if (window." + JavaScriptBridgeJS.JAVASCRIPT_BRIDGE_NAME + "[" + this._callHandlerID + "] != null) { " +
      "window." + JavaScriptBridgeJS.JAVASCRIPT_BRIDGE_NAME + "[" + this._callHandlerID + "].reject(new Error(" + JSON.stringify(message) + ")); " +
      "delete window." + JavaScriptBridgeJS.JAVASCRIPT_BRIDGE_NAME + "[" + this._callHandlerID + "]; " +
      "}";
    this.inAppWebView.controller.runJavaScriptExt(sourceCode);
  }
}