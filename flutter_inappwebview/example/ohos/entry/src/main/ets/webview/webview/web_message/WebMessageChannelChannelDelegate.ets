import { Any, MethodCall, MethodChannel } from '@ohos/flutter_ohos'
import { MethodResult } from '@ohos/flutter_ohos/src/main/ets/plugin/common/MethodChannel'
import ChannelDelegateImpl from '../../types/ChannelDelegateImpl'
import WebMessageCompatExt from '../../types/WebMessageCompatExt'
import InAppWebView from '../in_app_webview/InAppWebView'
import { WebMessageChannel } from './WebMessageChannel'

export class WebMessageChannelChannelDelegate extends ChannelDelegateImpl {
  private webMessageChannel: WebMessageChannel | null = null

  constructor(webMessageChannel: WebMessageChannel, channel: MethodChannel) {
    super(channel)
    this.webMessageChannel = webMessageChannel
  }

  public onMethodCall(call: MethodCall, result: MethodResult): void {
    switch (call.method) {
      case "setWebMessageCallback":
        if (this.webMessageChannel != null && this.webMessageChannel.webView instanceof InAppWebView) {
          let index: number = call.argument("index") as number;
          this.webMessageChannel.setWebMessageCallbackForInAppWebView(index, result);
        } else {
          result.success(false);
        }
        break;
      case "postMessage":
        if (this.webMessageChannel != null && this.webMessageChannel.webView instanceof InAppWebView) {
          let index: number = call.argument("index") as number;
          let message: WebMessageCompatExt | null = WebMessageCompatExt.fromMap(call.argument("message") as Map<string, Any>);
          this.webMessageChannel.postMessageForInAppWebView(index, message!, result);
        } else {
          result.success(false);
        }
        break;
      case "close":
        if (this.webMessageChannel != null && this.webMessageChannel.webView instanceof InAppWebView) {
          let index: number = call.argument("index") as number;
          this.webMessageChannel.closeForInAppWebView(index, result);
        } else {
          result.success(false);
        }
        break;
      default:
        result.notImplemented();
    }
  }

  public onMessage(index: number, message: WebMessageCompatExt | null): void {
    let channel: MethodChannel = this.getChannel();
    if (channel == null) return;
    let obj: Map<string, Any> = new Map<string, Any>();
    obj.set("index", index);
    obj.set("message", message != null ? message.toMap() : null);
    channel.invokeMethod("onMessage", obj);
  }

  public dispose(): void {
    super.dispose();
    this.webMessageChannel = null;
  }
}