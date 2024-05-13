import InAppWebViewFlutterPlugin from '../InAppWebViewFlutterPlugin';
import { Disposable } from '../types/Disposable';
import PrintJobController from './PrintJobController';

const LOG_TAG = "PrintJobManager";

export default class PrintJobManager implements Disposable {
  public plugin: InAppWebViewFlutterPlugin | null;
  public jobs = new Map<string, PrintJobController>();

  constructor(plugin: InAppWebViewFlutterPlugin) {
    this.plugin = plugin;
  }

  dispose(): void {
    let printJobControllers = this.jobs.values();
    for (let job of printJobControllers) {
      if (job != null) {
        job.dispose();
      }
    }
    this.jobs.clear();
    this.plugin = null;
  }
}