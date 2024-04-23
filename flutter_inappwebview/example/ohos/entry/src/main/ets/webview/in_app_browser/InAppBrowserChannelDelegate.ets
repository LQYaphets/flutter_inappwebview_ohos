import { MethodChannel } from '@ohos/flutter_ohos';
import ChannelDelegateImpl from '../types/ChannelDelegateImpl';
import InAppBrowserMenuItem from '../types/InAppBrowserMenuItem';

export default class InAppBrowserChannelDelegate extends ChannelDelegateImpl {

  constructor(channel: MethodChannel) {
    super(channel)
  }

  public onBrowserCreated(): void {
    let channel: MethodChannel = this.getChannel()
    if(channel == null) return
    let obj: Map<string, ESObject> = new Map<string, ESObject>()
    channel.invokeMethod("onBrowserCreated", obj)
  }

  public onMenuItemClicked(menuItem: InAppBrowserMenuItem): void {
    let channel: MethodChannel = this.getChannel()
    if (channel == null) return;
    let obj: Map<string ,ESObject> = new Map<string ,ESObject>();
    obj.set("id", menuItem.getId());
    channel.invokeMethod("onMenuItemClicked", obj);
  }

  public onExit(): void {
    let channel: MethodChannel = this.getChannel();
    if (channel == null) return;
    let obj: Map<string ,ESObject> = new Map<string ,ESObject>();
    channel.invokeMethod("onExit", obj);
  }
}