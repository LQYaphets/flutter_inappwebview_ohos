import { MethodChannel } from '@ohos/flutter_ohos';
import ChannelDelegateImpl from '../types/ChannelDelegateImpl';
import InAppWebView from './in_app_webview/InAppWebView';

const LOG_TAG = "WebViewChannelDelegate";

export default class WebViewChannelDelegate extends ChannelDelegateImpl{
  private webView: InAppWebView;

  constructor(webView: InAppWebView, channel: MethodChannel) {
    super(channel);
    this.webView = webView;
  }
}