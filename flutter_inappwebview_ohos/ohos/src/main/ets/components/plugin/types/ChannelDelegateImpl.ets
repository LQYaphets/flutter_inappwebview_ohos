import { MethodCall, MethodChannel } from '@ohos/flutter_ohos';
import { MethodResult } from '@ohos/flutter_ohos/src/main/ets/plugin/common/MethodChannel';
import { IChannelDelegate } from './IChannelDelegate';

export default class ChannelDelegateImpl implements IChannelDelegate {
  private channel: MethodChannel | null;

  constructor(channel: MethodChannel) {
    this.channel = channel;
    this.channel.setMethodCallHandler(this);
  }

  getChannel(): MethodChannel {
    return this.channel!
  }

  dispose(): void {
    if (this.channel != null) {
      this.channel.setMethodCallHandler(null);
      this.channel = null;
    }
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {

  }
}