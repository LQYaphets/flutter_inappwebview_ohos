import { MethodChannel } from '@ohos/flutter_ohos';
import InAppWebViewFlutterPlugin from '../InAppWebViewFlutterPlugin';
import { Disposable } from '../types/Disposable';
import PullToRefreshChannelDelegate from './PullToRefreshChannelDelegate';
import PullToRefreshSettings from './PullToRefreshSettings';
import { Context } from '@kit.AbilityKit';

const LOG_TAG = "PullToRefreshLayout";
const METHOD_CHANNEL_NAME_PREFIX = "com.pichillilorenzo/flutter_inappwebview_pull_to_refresh_";

// export class PullToRefreshLayout extends SwipeRefreshLayout implements Disposable {
export default class PullToRefreshLayout implements Disposable {
  channelDelegate: PullToRefreshChannelDelegate | null;
  settings: PullToRefreshSettings = new PullToRefreshSettings();

  /// attrs应为android.util.AttributeSet类型
  constructor(context: Context, plugin: InAppWebViewFlutterPlugin | null,
              id: Object | null = null, settings: PullToRefreshSettings, attrs: ESObject | null) {
    // super(context, attrs);
    this.settings = settings;
    let channel: MethodChannel = new MethodChannel(plugin!.messenger!, METHOD_CHANNEL_NAME_PREFIX + id);
    this.channelDelegate = new PullToRefreshChannelDelegate(this, channel);
  }

  // public PullToRefreshLayout(context: Context) { super(context); }
  //
  // public PullToRefreshLayout(context: Context, attrs: AttributeSet) {
  //   super(context, attrs);
  // }

  dispose(): void {
    if (this.channelDelegate != null) {
      this.channelDelegate.dispose();
      this.channelDelegate = null;
    }
    // removeAllViews();
  }
}