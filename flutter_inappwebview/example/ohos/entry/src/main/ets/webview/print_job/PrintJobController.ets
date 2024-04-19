import { MethodChannel } from '@ohos/flutter_ohos';
import InAppWebViewFlutterPlugin from '../InAppWebViewFlutterPlugin';
import { Disposable } from '../types/Disposable';
import { PrintJobInfoExt } from '../types/PrintJobInfoExt';
import PrintJobChannelDelegate from './PrintJobChannelDelegate';
import PrintJobSettings from './PrintJobSettings';

export class PrintJobController implements Disposable {
  protected LOG_TAG: string = "PrintJob"
  public METHOD_CHANNEL_NAME_PREFIX: string = "com.pichillilorenzo/flutter_inappwebview_printjobcontroller_"

  public id: string | null = null

  public plugin: InAppWebViewFlutterPlugin | null = null

  public channelDelegate: PrintJobChannelDelegate | null = null

  ///android.print.PrintJob类型，暂未完善
  public job: object | null = null

  public settings: PrintJobSettings | null = null

  constructor(id: string, job: object, settings: PrintJobSettings, plugin: InAppWebViewFlutterPlugin) {
    this.id = id
    this.plugin = plugin
    this.job = job
    this.settings = settings
    // let channel: MethodChannel = new MethodChannel(plugin.messenger, this.METHOD_CHANNEL_NAME_PREFIX + id)
    // this.channelDelegate = new PrintJobChannelDelegate(this, channel);
  }

  public cancel(): void {
    if(this.job != null) {
      // this.job.cancel();
    }
  }

  public restart(): void {
    if(this.job != null) {
      // this.job.restart();
    }
  }

  public getInfo(): PrintJobInfoExt | null {
    if (this.job != null) {
      // return PrintJobInfoExt.fromPrintJobInfo(this.job.getInfo());
    }
    return null;
  }

  public disposeNoCancel(): void {
    if (this.channelDelegate != null) {
      this.channelDelegate.dispose();
      this.channelDelegate  = null;
    }
    if (this.plugin != null) {
      // let printJobManager: PrintJobManager = plugin.printJobManager;
      // if (printJobManager != null && printJobManager.jobs.containsKey(this.id)) {
      //   printJobManager.jobs.put(this.id, null);
      // }
    }
    if (this.job != null) {
      this.job = null;
    }
    this.plugin = null;
  }

  public dispose(): void {
    if (this.channelDelegate != null) {
      this.channelDelegate.dispose();
      this.channelDelegate  = null;
    }
    if (this.plugin != null) {
      // let printJobManager: PrintJobManager = this.plugin.printJobManager;
      // if (printJobManager != null && printJobManager.jobs.containsKey(this.id)) {
      //   printJobManager.jobs.put(this.id, null);
      // }
    }
    if (this.job != null) {
      // this.job.cancel();
      this.job = null;
    }
    this.plugin = null;
  }
}