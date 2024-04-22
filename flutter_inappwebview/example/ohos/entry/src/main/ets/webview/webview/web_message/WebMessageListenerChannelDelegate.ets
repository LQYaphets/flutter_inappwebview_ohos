import { MethodCall, MethodChannel } from '@ohos/flutter_ohos';
import { MethodResult } from '@ohos/flutter_ohos/src/main/ets/plugin/common/MethodChannel';
import ChannelDelegateImpl from '../../types/ChannelDelegateImpl';
import WebMessageCompatExt from '../../types/WebMessageCompatExt';
import InAppWebView from '../in_app_webview/InAppWebView';
import WebMessageListener from './WebMessageListener';

export default class WebMessageListenerChannelDelegate extends ChannelDelegateImpl {
  private webMessageListener: WebMessageListener | null

  constructor(webMessageListener: WebMessageListener, channel: MethodChannel) {
    super(channel);
    this.webMessageListener = webMessageListener;
  }

  public onMethodCall(call: MethodCall, result: MethodResult) {
    switch (call.method) {
      case "postMessage":
        if (this.webMessageListener != null && this.webMessageListener.webView instanceof InAppWebView) {
          let message: WebMessageCompatExt | null = WebMessageCompatExt.fromMap(call.argument("message") as Map<string, ESObject>);
          this.webMessageListener.postMessageForInAppWebView(message, result);
        } else {
          result.success(false);
        }
        break;
      default:
        result.notImplemented();
    }
  }

  public onPostMessage(message: WebMessageCompatExt, sourceOrigin: string, isMainFrame: boolean): void {
    let channel: MethodChannel = this.getChannel();
    if (channel == null) return;
    let obj: Map<string, ESObject> = new Map<string, ESObject>();
    obj.set("message", message != null ? message.toMap() : null);
    obj.set("sourceOrigin", sourceOrigin);
    obj.set("isMainFrame", isMainFrame);
    channel.invokeMethod("onPostMessage", obj);
  }

  public dispose(): void {
    super.dispose();
    this.webMessageListener = null;
  }
}