import { Any, MethodChannel } from '@ohos/flutter_ohos';
import { Disposable } from '../../types/Disposable';
import WebMessagePort from '../../types/WebMessagePort';
import InAppWebViewInterface from '../InAppWebViewInterface';
import InAppWebView from '../in_app_webview/InAppWebView';
import { WebMessageChannelChannelDelegate } from './WebMessageChannelChannelDelegate';
import { ArrayList, List } from '@kit.ArkTS';
import { ValueCallback } from '../../types/ValueCallback';
import JavaScriptBridgeJS from '../../plugin_scripts_js/JavaScriptBridgeJS';
import { MethodResult } from '@ohos/flutter_ohos/src/main/ets/plugin/common/MethodChannel';
import WebMessageCompatExt from '../../types/WebMessageCompatExt';
import web_webview from '@ohos.web.webview';

const LOG_TAG = "WebMessageChannel"
const METHOD_CHANNEL_NAME_PREFIX = "com.pichillilorenzo/flutter_inappwebview_web_message_channel_"

export class WebMessageChannel implements Disposable {
  public id: string

  public channelDelegate: WebMessageChannelChannelDelegate | null

  public compatPorts: web_webview.WebMessagePort[]

  public ports: List<WebMessagePort>

  public webView: InAppWebViewInterface | null

  constructor(id: string, webView: InAppWebViewInterface) {
    this.id = id;
    let channel: MethodChannel = new MethodChannel(webView.getPlugin().messenger!, METHOD_CHANNEL_NAME_PREFIX + id)
    this.channelDelegate = new WebMessageChannelChannelDelegate(this, channel)
    if(webView instanceof InAppWebView) {
      this.compatPorts = webView.controller.createWebMessagePorts();
      this.ports = new List<WebMessagePort>()
    } else {
      this.ports = new List<WebMessagePort>()
      this.ports.set(0, new WebMessagePort("port1", this))
      this.ports.set(1, new WebMessagePort("port2", this))
      this.compatPorts = webView.getController().createWebMessagePorts()
    }
    this.webView = webView
  }

  public initJsInstance(webView: InAppWebViewInterface, callback: ValueCallback<WebMessageChannel>) {
    if (webView != null) {
      let webMessageChannel: WebMessageChannel = this;
      webView.evaluateJavascript("(function() {" +
              JavaScriptBridgeJS.WEB_MESSAGE_CHANNELS_VARIABLE_NAME + "['" + webMessageChannel.id + "'] = new MessageChannel();" +
              "})();", null, {
          onReceiveValue(value: string | null): void {
            callback.onReceiveValue(webMessageChannel);
          }
        }
      );
    } else {
      callback.onReceiveValue(this);
    }
  }

  public setWebMessageCallbackForInAppWebView(index: number, message: WebMessageCompatExt | null, result: MethodResult): void {
    if (this.webView != null && this.compatPorts.length > 0) {
      let webMessagePort: web_webview.WebMessagePort = this.compatPorts[index];
      let webMessageChannel: WebMessageChannel = this;
      let webMessage: web_webview.WebMessage = message!.getData() as ArrayBuffer
      try {
        webMessagePort.postMessageEvent(webMessage)
        // webMessagePort.setWebMessageCallback(new WebMessagePortCompat.WebMessageCallbackCompat() {
        //   public onMessage(port: WebMessagePortCompat, message: WebMessageCompat): void {
        //     super.onMessage(port, message);
        //     webMessageChannel.onMessage(index, message != null ? WebMessageCompatExt.fromMapWebMessageCompat(message) : null);
        //   }
        // });
        result.success(true);
      } catch (e) {
        result.error(LOG_TAG, e.getMessage(), null);
      }
    } else {
      result.success(true);
    }
  }

  //// 未完善，缺少compatPorts，缺少androidx.webkit.WebViewFeature和androidx.webkit.WebMessageCompat对应类型和方法
  public postMessageForInAppWebView(index: number, message: WebMessageCompatExt, result: MethodResult): void {
    // if (this.webView != null && compatPorts.size() > 0 &&
    //         WebViewFeature.isFeatureSupported(WebViewFeature.WEB_MESSAGE_PORT_POST_MESSAGE)) {
    //   let port: WebMessagePortCompat = compatPorts.get(index);
    //   let webMessagePorts: List<WebMessagePortCompat> = new List<WebMessagePortCompat>();
    //   let portsExt: List<WebMessagePortCompatExt> = message.getPorts();
    //   if (portsExt != null) {
    //     for (let portExt of portsExt) {
    //       let webMessageChannel: WebMessageChannel | undefined = this.webView.getWebMessageChannels().get(portExt.getWebMessageChannelId());
    //       if (webMessageChannel != null) {
    //         webMessagePorts.add(webMessageChannel.compatPorts.get(portExt.getIndex()));
    //       }
    //     }
    //   }
    //   let data: Any = message.getData();
    //   try {
    //     if (WebViewFeature.isFeatureSupported(WebViewFeature.WEB_MESSAGE_ARRAY_BUFFER) && data != null &&
    //             message.getType() == WebMessageCompat.TYPE_ARRAY_BUFFER) {
    //       port.postMessage(new WebMessageCompat((byte[]) data, webMessagePorts.toArray(new WebMessagePortCompat[0])));
    //     } else {
    //       port.postMessage(new WebMessageCompat(data != null ? data.toString() : null, webMessagePorts.toArray(new WebMessagePortCompat[0])));
    //     }
    //     result.success(true);
    //   } catch (e) {
    //     result.error(LOG_TAG, e.getMessage(), null);
    //   }
    // } else {
    //   result.success(true);
    // }
  }

  public closeForInAppWebView(index: number, result: MethodResult): void {
    if (this.webView != null && this.compatPorts.length > 0 ) {
      let port: web_webview.WebMessagePort = this.compatPorts[index];
      try {
        port.close();
        result.success(true);
      } catch (e) {
        result.error(LOG_TAG, e.getMessage(), null);
      }
    } else {
      result.success(true);
    }
  }

  public onMessage(index: number, message: WebMessageCompatExt | null): void {
    if (this.channelDelegate != null) {
      this.channelDelegate.onMessage(index, message);
    }
  }

  public toMap(): Map<string, Any> {
    let webMessageChannelMap: Map<string, Any> = new Map<string, Any>()
    webMessageChannelMap.set("id", this.id);
    return webMessageChannelMap;
  }

  public dispose(): void {
    for (let i = 0;  i < this.compatPorts.length; i++) {
      this.compatPorts.pop();
    }
    if (this.channelDelegate != null) {
      this.channelDelegate.dispose();
      this.channelDelegate = null;
    }
    // this.compatPorts.pop();
    this.webView = null;
  }
}