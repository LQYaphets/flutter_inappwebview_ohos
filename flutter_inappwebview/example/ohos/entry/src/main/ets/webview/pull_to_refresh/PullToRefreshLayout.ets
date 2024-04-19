import { MethodChannel } from '@ohos/flutter_ohos';
import InAppWebViewFlutterPlugin from '../InAppWebViewFlutterPlugin';
import { Disposable } from '../types/Disposable';
import { PullToRefreshChannelDelegate } from './PullToRefreshChannelDelegate';
import { PullToRefreshSettings } from './PullToRefreshSettings';
import { Context } from '@kit.AbilityKit';

// export class PullToRefreshLayout extends SwipeRefreshLayout implements Disposable {
export class PullToRefreshLayout implements Disposable {
  static LOG_TAG: string = "PullToRefreshLayout";
  static METHOD_CHANNEL_NAME_PREFIX: string = "com.pichillilorenzo/flutter_inappwebview_pull_to_refresh_";
  channelDelegate: PullToRefreshChannelDelegate | null = null;
  settings: PullToRefreshSettings = new PullToRefreshSettings();

  constructor(context: Context, plugin: InAppWebViewFlutterPlugin | null = null,
                             id: Object | null = null, settings: PullToRefreshSettings | null = null, attrs: object | null = null) {
    if(plugin != null && id != null && settings != null) {
      // super(context);
      this.settings = settings;
      // let channel: MethodChannel = new MethodChannel(plugin.messager, METHOD_CHANNEL_NAME_PREFIX + id);
      // this.channelDelegate = new PullToRefreshChannelDelegate(this, channel);
    } else if (attrs != null){
      // super(context, attrs);
    } else {
      // super(context);
    }

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