import ChannelDelegateImpl  from '../types/ChannelDelegateImpl';
import { PrintJobController } from './PrintJobController';
import { MethodCall, MethodChannel } from '@ohos/flutter_ohos';
import { MethodResult } from '@ohos/flutter_ohos/src/main/ets/plugin/common/MethodChannel';
import { PrintJobInfoExt } from '../types/PrintJobInfoExt';

export default class PrintJobChannelDelegate extends ChannelDelegateImpl {
  private printJobController: PrintJobController | null = null

  constructor(printJobController: PrintJobController, channel: MethodChannel) {
    super(channel);
    this.printJobController = printJobController;
  }

  public onMethodCall(call: MethodCall, result: MethodResult) {
    switch (call.method) {
      case "cancel":
        if (this.printJobController != null) {
          this.printJobController.cancel();
          result.success(true);
        } else {
          result.success(false);
        }
        break;
      case "restart":
        if (this.printJobController != null) {
          this.printJobController.restart();
          result.success(true);
        } else {
          result.success(false);
        }
        break;
      case "getInfo":
        if (this.printJobController != null) {
          let info: PrintJobInfoExt | null = this.printJobController.getInfo();
          result.success(info != null ? info.toMap() : null);
        } else {
          result.success(null);
        }
        break;
      case "dispose":
        if (this.printJobController != null) {
          this.printJobController.dispose();
          result.success(true);
        } else {
          result.success(false);
        }
        break;
      default:
        result.notImplemented();
    }
  }

  public dispose(): void {
    super.dispose();
    this.printJobController = null;
  }
}