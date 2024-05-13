import { MethodChannel } from '@ohos/flutter_ohos';
import { MethodCallHandler } from '@ohos/flutter_ohos/src/main/ets/plugin/common/MethodChannel';

export interface IChannelDelegate extends MethodCallHandler {
  getChannel(): MethodChannel | null;
}