import JavaScriptBridgeJS from '../plugin_scripts_js/JavaScriptBridgeJS'
import InAppWebViewInterface from '../webview/InAppWebViewInterface'
import { WebMessageChannel } from '../webview/web_message/WebMessageChannel'
import { ValueCallback } from './ValueCallback'
import WebMessage from './WebMessage'
import { ArrayList, List } from '@kit.ArkTS'
import Util from '../Util'

export default class WebMessagePort {
  public name: string

  public webMessageChannel: WebMessageChannel | null

  public isClosed: boolean = false

  public isTransferred: boolean = false
  
  public isStarted: boolean = false

  constructor(name: string, webMessageChannel: WebMessageChannel | null) {
    this.name = name
    this.webMessageChannel = webMessageChannel
  }

  /// 抛异常，暂未完善
  public setWebMessageCallback(callback: ValueCallback<void>): void{
    if (this.isClosed || this.isTransferred) {
      console.error("Port is already closed or transferred");
      return
      // throw new Exception("Port is already closed or transferred");
    }
    this.isStarted = true;
    let webView: InAppWebViewInterface | null = this.webMessageChannel != null && this.webMessageChannel.webView != null ? this.webMessageChannel.webView : null
    if (webView != null) {
      let index: number = this.name?.includes("port1") ? 0 : 1;
      webView.evaluateJavascript("(function() {" +
              "  var webMessageChannel = " + JavaScriptBridgeJS.WEB_MESSAGE_CHANNELS_VARIABLE_NAME + "['" + this.webMessageChannel?.id + "'];" +
              "  if (webMessageChannel != null) {" +
              "      webMessageChannel." + this.name + ".onmessage = function (event) {" +
              "          window." + JavaScriptBridgeJS.JAVASCRIPT_BRIDGE_NAME + ".callHandler('onWebMessagePortMessageReceived', {" +
              "              'webMessageChannelId': '" + this.webMessageChannel?.id + "'," +
              "              'index': " + index + "," +
              "              'message': event.data" +
              "          });" +
              "      }" +
              "  }" +
              "})();",
        null,
        null
        // new ValueCallback<string>() {
        //   public onReceiveValue(value: string): void {
        //     if (callback != null) {
        //       callback.onReceiveValue(null);
        //     }
        //   }
        // }
      );
    } else {
      if (callback != null) {
        callback.onReceiveValue(null);
      }
    }
  }

  /// 抛异常，暂未完善
  public postMessage(message: WebMessage, callback: ValueCallback<void>): void {
    if (this.isClosed || this.isTransferred) {
      console.error("Port is already closed or transferred");
      return
      // throw new Exception("Port is already closed or transferred");
    }
    let webView: InAppWebViewInterface | null = this.webMessageChannel != null && this.webMessageChannel.webView != null ? this.webMessageChannel.webView : null;
    if (webView != null) {
      let portsString: string = "null";
      let ports: List<WebMessagePort> | null = message.ports;
      if (ports != null) {
        let portArrayString: List<string> = new List<string>();
        for (let port of ports) {
          if (port == this) {
            console.error("Source port cannot be transferred");
            return
            // throw new Exception("Source port cannot be transferred");
          }
          if (port.isStarted) {
            console.error("Port is already started");
            return
            // throw new Exception("Port is already started");
          }
          if (port.isClosed || port.isTransferred) {
            console.error("Port is already closed or transferred");
            return
            // throw new Exception("Port is already closed or transferred");
          }
          port.isTransferred = true;
          portArrayString.add(JavaScriptBridgeJS.WEB_MESSAGE_CHANNELS_VARIABLE_NAME + "['" + this.webMessageChannel?.id + "']." + port.name);
        }
        /// android.text.TextUtils未找对应的，未完善
        // portsString = "[" + TextUtils.join(", ", portArrayString) + "]";
      }
      let data: string = message.data != null ? Util.replaceAll(message.data, "\'", "\\'") : "null";
      let source: string = "(function() {" +
              "  var webMessageChannel = " + JavaScriptBridgeJS.WEB_MESSAGE_CHANNELS_VARIABLE_NAME + "['" + this.webMessageChannel?.id + "'];" +
              "  if (webMessageChannel != null) {" +
              "      webMessageChannel." + this.name + ".postMessage('" + data + "', " + portsString + ");" +
              "  }" +
              "})();";
      webView.evaluateJavascript(source, null, null
        // new ValueCallback<String>() {
        //   public onReceiveValue(String value): void {
        //     callback.onReceiveValue(null);
        //   }
        // }
      );
    } else {
      callback.onReceiveValue(null);
    }
    message.dispose();
  }

  public close(callback: ValueCallback<void>): void{
    if (this.isTransferred) {
      // throw new Exception("Port is already transferred");
      console.error("Port is already transferred");
      return
    }
    this.isClosed = true;
    let webView: InAppWebViewInterface | null = this.webMessageChannel != null && this.webMessageChannel.webView != null ? this.webMessageChannel.webView : null;
    if (webView != null) {
      let source: string = "(function() {" +
        "  var webMessageChannel = " + JavaScriptBridgeJS.WEB_MESSAGE_CHANNELS_VARIABLE_NAME + "['" + this.webMessageChannel?.id + "'];" +
        "  if (webMessageChannel != null) {" +
        "      webMessageChannel." + this.name + ".close();" +
        "  }" +
        "})();";
      webView.evaluateJavascript(source, null, null
        // new ValueCallback<String>() {
        //   public onReceiveValue(value: string): void {
        //    callback.onReceiveValue(null);
        //   }
        // }
      );
    } else {
      callback.onReceiveValue(null);
    }
  }

  public dispose(): void {
    this.isClosed = true;
    this.webMessageChannel = null;
  }
}