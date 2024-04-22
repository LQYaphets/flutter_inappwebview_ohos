import InAppWebViewFlutterPlugin from '@ohos/flutter_inappwebview_ohos';
import InAppWebView from './InAppWebView';

export default class InAppWebViewChromeClient {
  private plugin: InAppWebViewFlutterPlugin;
  private inAppWebView: InAppWebView;

  constructor(plugin: InAppWebViewFlutterPlugin, inAppWebView: InAppWebView) {
    this.plugin = plugin;
    this.inAppWebView = inAppWebView;
  }
}