import { Any, MethodChannel } from '@ohos/flutter_ohos';

import InAppWebViewFlutterPlugin from '../InAppWebViewFlutterPlugin';
import { Disposable } from '../types/Disposable';
import InAppWebViewInterface from '../webview/InAppWebViewInterface';
import { FindInteractionChannelDelegate } from './FindInteractionChannelDelegate';
import { FindInteractionSettings } from './FindInteractionSettings';

const LOG_TAG = "FindInteractionController";
const METHOD_CHANNEL_NAME_PREFIX = "com.pichillilorenzo/flutter_inappwebview_find_interaction_";

export class FindInteractionController implements Disposable {
  public webView: InAppWebViewInterface | null = null;
  // public  activeFindSession: FindSession | null = null;

  public channelDelegate: FindInteractionChannelDelegate | null = null;
  public settings: FindInteractionSettings | null = null;
  public searchText: string | null = null;

  constructor(webView: InAppWebViewInterface, plugin: InAppWebViewFlutterPlugin, id: Any, settings: FindInteractionSettings | null) {
    this.webView = webView;
    this.settings = settings;
    let channel: MethodChannel = new MethodChannel(plugin.messenger, METHOD_CHANNEL_NAME_PREFIX + id);
    this.channelDelegate = new FindInteractionChannelDelegate(this, channel);
  }

  public prepare(): void {

  }

  public findAll(find: string | null): void {
    if (find == null) {
      find = this.searchText;
    } else {
      // updated searchText
      this.searchText = find;
    }
    if (this.webView != null && find != null) {
      this.webView.findAllAsync(find);
    }
  }

  public findNext(forward: boolean): void {
    if (this.webView != null) {
      this.webView.findNext(forward);
    }
  }

  public clearMatches(): void {
    if (this.webView != null) {
      this.webView.clearMatches();
    }
  }

  dispose(): void {
    throw new Error('Method not implemented.');
  }
}