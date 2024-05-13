import { Any, MethodChannel } from '@ohos/flutter_ohos';
import InAppWebViewFlutterPlugin from '../InAppWebViewFlutterPlugin';
import { Disposable } from '../types/Disposable';
import PullToRefreshChannelDelegate from './PullToRefreshChannelDelegate';
import PullToRefreshSettings from './PullToRefreshSettings';
import InAppWebView from '../webview/in_app_webview/InAppWebView';

const LOG_TAG = "PullToRefreshLayout";
const METHOD_CHANNEL_NAME_PREFIX = "com.pichillilorenzo/flutter_inappwebview_pull_to_refresh_";

export default class PullToRefreshLayout implements Disposable {
  channelDelegate: PullToRefreshChannelDelegate | null;
  settings: PullToRefreshSettings = new PullToRefreshSettings();
  enabled: boolean = false
  public webView: InAppWebView | null = null

  constructor(plugin: InAppWebViewFlutterPlugin | null, id: Object | null = null, settings: PullToRefreshSettings) {
    this.settings = settings;
    let channel: MethodChannel = new MethodChannel(plugin!.messenger!, METHOD_CHANNEL_NAME_PREFIX + id);
    this.channelDelegate = new PullToRefreshChannelDelegate(this, channel);
  }

  addView(webView: InAppWebView | null): void {
    if(webView != null) {
      this.webView = webView
    }
  }

  public prepare(): void {
    if(this.webView != null) {
      this.webView.refresh()
      this.webView.scrollToTop()
    }
  }

  dispose(): void {
    if (this.channelDelegate != null) {
      this.channelDelegate.dispose();
      this.channelDelegate = null;
    }
    // removeAllViews();
  }
}