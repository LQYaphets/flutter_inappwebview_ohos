import InAppWebViewFlutterPlugin from '../InAppWebViewFlutterPlugin';
import ChannelDelegateImpl from '../types/ChannelDelegateImpl';
import { util } from '@kit.ArkTS';
import { MethodCall, MethodChannel } from '@ohos/flutter_ohos';
import { MethodResult } from '@ohos/flutter_ohos/src/main/ets/plugin/common/MethodChannel';

const LOG_TAG = "InAppBrowserManager"
const METHOD_CHANNEL_NAME = "com.pichillilorenzo/flutter_inappbrowser"

export default class InAppBrowserManager extends ChannelDelegateImpl {

  public plugin: InAppWebViewFlutterPlugin | null
  public id: string

  public shared: Map<string, InAppBrowserManager> = new Map<string, InAppBrowserManager>()

  constructor(plugin:InAppWebViewFlutterPlugin) {
    super(new MethodChannel(plugin.messenger!, METHOD_CHANNEL_NAME));
    this.id = util.generateRandomUUID(true)
    this.plugin = plugin
    this.shared.set(this.id, this)
  }

  public onMethodCall(call: MethodCall, result: MethodResult): void {
    switch (call.method) {
      case "open":
        // if (this.plugin != null && this.plugin.activity != null) {
        //   open(this.plugin.activity, call.arguments() as Map<string, Any>);
        //   result.success(true);
        // } else {
        //   result.success(false);
        // }
        break;
      case "openWithSystemBrowser":
        // if (this.plugin != null && this.plugin.activity != null) {
        //   let url: string = call.argument("url") as string;
        //   openWithSystemBrowser(this.plugin.activity, url, result);
        // } else {
        //   result.success(false);
        // }
        break;
      default:
        result.notImplemented();
    }
  }

  public static getMimeType(url: string): string {
    let type: string | null = null;
    // let extension: string =  MimeTypeMap.getFileExtensionFromUrl(url)
    // if (extension != null) {
    //   type = MimeTypeMap.getSingleton().getMimeTypeFromExtension(extension);
    // }
    return type??''
  }

  // public openWithSystemBrowser(activity: Activity, url: string, result: Result): void {
  //   try {
  //     let intent: Intent;
  //     intent = new Intent(Intent.ACTION_VIEW);
  //     let uri: uri = Uri.parse(url);
  //     if ("file".equals(uri.getScheme())) {
  //       intent.setDataAndType(uri, getMimeType(url));
  //     } else {
  //       intent.setData(uri);
  //     }
  //     intent.putExtra(Browser.EXTRA_APPLICATION_ID, activity.getPackageName());
  //     this.openExternalExcludeCurrentApp(activity, intent);
  //     result.success(true);
  //   } catch (java.lang.RuntimeException e) {
  //     Log.d(LOG_TAG, url + " cannot be opened: " + e.toString());
  //     result.error(LOG_TAG, url + " cannot be opened!", null);
  //   }
  // }

  public dispose(): void {
    super.dispose();
    // this.shared.remove(this.id);
    this.plugin = null;
  }
}