import ChannelDelegateImpl from '../types/ChannelDelegateImpl';
import { HeadlessInAppWebView } from './HeadlessInAppWebView';

export class HeadlessInAppWebViewManager extends ChannelDelegateImpl {
  public webViews: Map<string, HeadlessInAppWebView> = new Map<string, HeadlessInAppWebView>();
}