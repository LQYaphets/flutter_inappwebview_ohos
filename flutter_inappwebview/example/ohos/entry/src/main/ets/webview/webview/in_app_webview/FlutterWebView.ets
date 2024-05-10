import { DVModel } from '@ohos/flutter_ohos/src/main/ets/view/DynamicView/dynamicView';
import PlatformWebView from '../PlatformWebView';
import InAppWebViewFlutterPlugin from '../../InAppWebViewFlutterPlugin';
import InAppWebView from './InAppWebView';
import InAppWebViewSettings from './InAppWebViewSettings';
import URLRequest from '../../types/URLRequest';
import UserScript from '../../types/UserScript';
import { Any, Log } from '@ohos/flutter_ohos';
import PullToRefreshLayout from '../../pull_to_refresh/PullToRefreshLayout';
import { DisplayListenerProxy } from './DisplayListenerProxy';
import PullToRefreshSettings from '../../pull_to_refresh/PullToRefreshSettings';
import { FindInteractionController } from '../../find_interaction/FindInteractionController';

const LOG_TAG: string = "IAWFlutterWebView";

export class FlutterWebView extends PlatformWebView {
  private webView: InAppWebView | null;
  public pullToRefreshLayout: PullToRefreshLayout | null = null;
  public keepAliveId: string | null = null

  constructor(plugin: InAppWebViewFlutterPlugin, context: Context, id: number, params: Map<string, Any>) {
    super();
    let displayListenerProxy: DisplayListenerProxy = new DisplayListenerProxy();
    //TODO
    // let displayManager: DisplayManager = (DisplayManager) context.getSystemService(Context.DISPLAY_SERVICE);
    // displayListenerProxy.onPreWebViewInitialization(displayManager);

    this.keepAliveId = params.get("keepAliveId") as string

    let initialSettings: Map<string, Any> = params.get("initialSettings");
    let contextMenu: Map<string, Any> = params.get("contextMenu");
    let windowId = params.get("windowId") as number;
    let initialUserScripts: Array<Map<string, Any>> = params.get("initialUserScripts");
    let pullToRefreshInitialSettings: Map<string, Any> = params.get("pullToRefreshSettings");

    let customSettings: InAppWebViewSettings = new InAppWebViewSettings();
    customSettings.parse(initialSettings);

    let userScripts: Array<UserScript> = new Array<UserScript>();
    if (initialUserScripts != null) {
      initialUserScripts.forEach((item: Map<string, Any>) => {
        let script = UserScript.fromMap(item);
        if (script != null)
          userScripts.push(script);
      })
    }

    this.webView = new InAppWebView(context, plugin, id, windowId, customSettings, userScripts)
    displayListenerProxy.onPostWebViewInitialization(); //displayListenerProxy.onPostWebViewInitialization(displayManager);

    // set MATCH_PARENT layout params to the WebView, otherwise it won't take all the available space!
    //TODO
    // this.webView.setLayoutParams(new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
    // let pullToRefreshSettings: PullToRefreshSettings = new PullToRefreshSettings();
    // pullToRefreshSettings.parse(pullToRefreshInitialSettings);
    // this.pullToRefreshLayout = new PullToRefreshLayout(context, plugin, id, pullToRefreshSettings);
    // this.pullToRefreshLayout.addView(this.webView);
    // this.pullToRefreshLayout.prepare();

    let findInteractionController: FindInteractionController = new FindInteractionController(this.webView, plugin, id, null);
    this.webView.findInteractionController = findInteractionController;
    findInteractionController.prepare();

    this.webView.prepare()
  }

  getView(): DVModel {
    // return this.pullToRefreshLayout != null ? this.pullToRefreshLayout : this.webView;
    return this.webView!.getView()
  }

  makeInitialLoad(params: Map<string, Any>): void {
    if (this.webView == null) {
      return;
    }
    let windowId = params.get("windowId") as number;
    let initialUrlRequest: Map<string, Any> = params.get("initialUrlRequest");
    let initialFile = params.get("initialFile") as string;
    let initialData: Map<string, Any> = params.get("initialData");
    if (windowId != null && windowId != undefined) {
      if (this.webView.plugin != null && this.webView.plugin.inAppWebViewManager != null) {
        //TODO
        // let resultMsg: Message = this.webView.plugin.inAppWebViewManager.windowWebViewMessages.get(windowId);
        // if (resultMsg != null) {
        //   ((WebView.WebViewTransport) resultMsg.obj).setWebView(webView);
        //   resultMsg.sendToTarget();
        //
        //   if (WebViewFeature.isFeatureSupported(WebViewFeature.DOCUMENT_START_SCRIPT)) {
        //     webView.post(new Runnable() {
        //       @Override
        //       public void run() {
        //         if (webView != null) {
        //           webView.prepareAndAddUserScripts();
        //         }
        //     }
        //     });
        //   }
        // }
      }
    } else {
      if (initialFile != null) {
        try {
          this.webView!.loadFile(initialFile);
        } catch (e) {
          Log.d(LOG_TAG, "");
        }
      }
      else if (initialData != null) {
        let data = initialData.get("data") as string;
        let mimeType = initialData.get("mimeType") as string;
        let encoding = initialData.get("encoding") as string;
        let baseUrl = initialData.get("baseUrl") as string;
        let historyUrl = initialData.get("historyUrl") as string;
        this.webView!.loadDataWithBaseURL(baseUrl, data, mimeType, encoding, historyUrl);
      }
      else if (initialUrlRequest != null) {
        let urlRequest = URLRequest.fromMap(initialUrlRequest);
        if (urlRequest != null) {
          this.webView!.loadUrl(urlRequest);
        }
      }
    }
  }

  dispose(): void {
    if (this.keepAliveId != null && this.webView != null) {
      this.webView.dispose();
      this.webView = null;

      if (this.pullToRefreshLayout != null) {
        this.pullToRefreshLayout.dispose();
        this.pullToRefreshLayout = null;
      }
    }
  }

  public onInputConnectionLocked(): void {
    if (this.webView != null && this.webView.inAppBrowserDelegate == null && !this.webView.customSettings.useHybridComposition) {
      //TODO
      // this.webView.lockInputConnection();
    }
  }

  public onInputConnectionUnlocked(): void {
    if (this.webView != null && this.webView.inAppBrowserDelegate == null && !this.webView.customSettings.useHybridComposition) {
      //TODO
      // this.webView.unlockInputConnection();
    }
  }

  public onFlutterViewAttached(flutterView: DVModel): void {
    if (this.webView != null && !this.webView.customSettings.useHybridComposition) {
      //TODO
      // this.webView.setContainerView(flutterView);
    }
  }

  public onFlutterViewDetached(): void {
    if (this.webView != null && !this.webView.customSettings.useHybridComposition) {
      //TODO
      // this.webView.setContainerView(null);
    }
  }
}