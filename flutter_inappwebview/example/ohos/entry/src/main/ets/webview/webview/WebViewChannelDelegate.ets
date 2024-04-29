import { Any, Log, MethodCall, MethodChannel } from '@ohos/flutter_ohos';
import { MethodResult } from '@ohos/flutter_ohos/src/main/ets/plugin/common/MethodChannel';
import InAppBrowserActivity from '../in_app_browser/InAppBrowserActivity';
import ChannelDelegateImpl from '../types/ChannelDelegateImpl';
import ContentWorld from '../types/ContentWorld';
import URLRequest from '../types/URLRequest';
import { WebViewChannelDelegateMethods } from './WebViewChannelDelegateMethods';
import InAppWebView from './in_app_webview/InAppWebView';
import InAppBrowserSettings from '../in_app_browser/InAppBrowserSettings';
import { HashMap, List } from '@kit.ArkTS';
import InAppWebViewSettings from './in_app_webview/InAppWebViewSettings';
import PrintJobSettings from '../print_job/PrintJobSettings';
import HitTestResult from '../types/HitTestResult';
import UserScript from '../types/UserScript';
import WebMessagePortCompatExt from '../types/WebMessagePortCompatExt';
import { WebMessageChannel } from './web_message/WebMessageChannel';
import WebMessageCompatExt from '../types/WebMessageCompatExt';
import WebMessageListener from './web_message/WebMessageListener';
import DownloadStartRequest from '../types/DownloadStartRequest';
import BaseCallbackResultImpl from '../types/BaseCallbackResultImpl';
import JsAlertResponse from '../types/JsAlertResponse';
import JsConfirmResponse from '../types/JsConfirmResponse';
import JsPromptResponse from '../types/JsPromptResponse';
import JsBeforeUnloadResponse from '../types/JsBeforeUnloadResponse';
import CreateWindowAction from '../types/CreateWindowAction';
import GeolocationPermissionShowPromptResponse from '../types/GeolocationPermissionShowPromptResponse';
import PermissionResponse from '../types/PermissionResponse';
import WebResourceRequestExt from '../types/WebResourceRequestExt';
import WebResourceErrorExt from '../types/WebResourceErrorExt';
import WebResourceResponseExt from '../types/WebResourceResponseExt';
import HttpAuthResponse from '../types/HttpAuthResponse';
import HttpAuthenticationChallenge from '../types/HttpAuthenticationChallenge';
import SyncBaseCallbackResultImpl from '../types/SyncBaseCallbackResultImpl';
import CustomSchemeResponse from '../types/CustomSchemeResponse';
import { NavigationActionPolicy } from '../types/NavigationActionPolicy';
import NavigationAction from '../types/NavigationAction';
import SslCertificateExt from '../types/SslCertificateExt';

const LOG_TAG = "WebViewChannelDelegate";

export default class WebViewChannelDelegate extends ChannelDelegateImpl {
  private webView: InAppWebView;

  constructor(webView: InAppWebView, channel: MethodChannel) {
    super(channel);
    this.webView = webView;
  }

  public async onMethodCall(call: MethodCall, result: MethodResult): Promise<void> {
    let method: WebViewChannelDelegateMethods;
    try {
      method = WebViewChannelDelegateMethods[call.method];
    } catch (e) {
      result.notImplemented();
      return;
    }
    switch (method) {
      case WebViewChannelDelegateMethods.getUrl:
        result.success((this.webView != null) ? this.webView.getUrl() : null);
        break;
      case WebViewChannelDelegateMethods.getTitle:
        result.success((this.webView != null) ? this.webView.getTitle() : null);
        break;
      case WebViewChannelDelegateMethods.getProgress:
        result.success((this.webView != null) ? this.webView.getProgress() : null);
        break;
      case WebViewChannelDelegateMethods.loadUrl:
        if (this.webView != null) {
          let urlRequest: Map<string, Any> = call.argument("urlRequest") as Map<string, Any>;
          this.webView.loadUrl(URLRequest.fromMap(urlRequest)!);
        }
        result.success(true);
        break;
      case WebViewChannelDelegateMethods.postUrl:
        if (this.webView != null) {
          let url: string = call.argument("url") as string;
          let postData: ArrayBuffer = call.argument("postData") as ArrayBuffer;
          this.webView.postUrl(url, postData);
        }
        result.success(true);
        break;
      case WebViewChannelDelegateMethods.loadData:
        if (this.webView != null) {
          let data: string = call.argument("data") as string;
          let mimeType: string = call.argument("mimeType") as string;
          let encoding: string = call.argument("encoding") as string;
          let baseUrl: string = call.argument("baseUrl") as string;
          let historyUrl: string = call.argument("historyUrl") as string;
          this.webView.loadDataWithBaseURL(baseUrl, data, mimeType, encoding, historyUrl);
        }
        result.success(true);
        break;
      case WebViewChannelDelegateMethods.loadFile:
        if (this.webView != null) {
          let assetFilePath: string = call.argument("assetFilePath");
          try {
            this.webView.loadFile(assetFilePath);
          } catch (e) {
            e.printStackTrace();
            result.error(LOG_TAG, e.getMessage(), null);
            return;
          }
        }
        result.success(true);
        break;
      case WebViewChannelDelegateMethods.evaluateJavascript:
        if (this.webView != null) {
          let source: string = call.argument("source");
          let contentWorldMap: Map<string, Any> = call.argument("contentWorld") as Map<string, Any>;
          let contentWorld: ContentWorld | null = ContentWorld.fromMap(contentWorldMap);
          this.webView.evaluateJavascript(source, contentWorld!, {
            onReceiveValue: (value: string | null): void => {
              result.success(value);
            }
          });
        } else {
          result.success(null);
        }
        break;
      case WebViewChannelDelegateMethods.injectJavascriptFileFromUrl:
        if (this.webView != null) {
          let urlFile: string = call.argument("urlFile");
          let scriptHtmlTagAttributes: Map<string, Any> = call.argument("scriptHtmlTagAttributes") as Map<string, Any>;
          this.webView.injectJavascriptFileFromUrl(urlFile, scriptHtmlTagAttributes);
        }
        result.success(true);
        break;
      case WebViewChannelDelegateMethods.injectCSSCode:
        if (this.webView != null) {
          let source: string = call.argument("source");
          this.webView.injectCSSCode(source);
        }
        result.success(true);
        break;
      case WebViewChannelDelegateMethods.injectCSSFileFromUrl:
        if (this.webView != null) {
          let urlFile: string = call.argument("urlFile");
          let cssLinkHtmlTagAttributes: Map<string, Any> = call.argument("cssLinkHtmlTagAttributes") as Map<string, Any>;
          this.webView.injectCSSFileFromUrl(urlFile, cssLinkHtmlTagAttributes);
        }
        result.success(true);
        break;
      case WebViewChannelDelegateMethods.reload:
        if (this.webView != null)
          this.webView.reload();
        result.success(true);
        break;
      case WebViewChannelDelegateMethods.goBack:
        if (this.webView != null)
          this.webView.goBack();
        result.success(true);
        break;
      case WebViewChannelDelegateMethods.canGoBack:
        result.success((this.webView != null) && this.webView.canGoBack());
        break;
      case WebViewChannelDelegateMethods.goForward:
        if (this.webView != null)
          this.webView.goForward();
        result.success(true);
        break;
      case WebViewChannelDelegateMethods.canGoForward:
        result.success((this.webView != null) && this.webView.canGoForward());
        break;
      case WebViewChannelDelegateMethods.goBackOrForward:
        if (this.webView != null)
          this.webView.goBackOrForward(call.argument("steps") as number);
        result.success(true);
        break;
      case WebViewChannelDelegateMethods.canGoBackOrForward:
        result.success((this.webView != null) && this.webView.canGoBackOrForward(call.argument("steps") as number));
        break;
      case WebViewChannelDelegateMethods.stopLoading:
        if (this.webView != null)
          this.webView.stopLoading();
        result.success(true);
        break;
      case WebViewChannelDelegateMethods.isLoading:
        result.success((this.webView != null) && this.webView.getLoading());
        break;
      case WebViewChannelDelegateMethods.takeScreenshot:
        if (this.webView != null) {
          let screenshotConfiguration: Map<string, Any> = call.argument("screenshotConfiguration") as Map<string, Any>;
          this.webView.takeScreenshot(screenshotConfiguration, result);
        } else
          result.success(null);
        break;
      case WebViewChannelDelegateMethods.setSettings:
        if (this.webView != null && this.webView.getInAppBrowserDelegate() instanceof InAppBrowserActivity) {
          let inAppBrowserActivity: InAppBrowserActivity = this.webView.getInAppBrowserDelegate() as InAppBrowserActivity;
          let inAppBrowserSettings: InAppBrowserSettings = new InAppBrowserSettings();
          let inAppBrowserSettingsMap: Map<string, Any> = call.argument("settings") as Map<string, Any>;
          inAppBrowserSettings.parse(inAppBrowserSettingsMap);
          inAppBrowserActivity.setSettings(inAppBrowserSettings, inAppBrowserSettingsMap);
        } else if (this.webView != null) {
          let inAppWebViewSettings: InAppWebViewSettings = new InAppWebViewSettings();
          let inAppWebViewSettingsMap: Map<string, Any> = call.argument("settings") as Map<string, Any>;
          inAppWebViewSettings.parse(inAppWebViewSettingsMap);
          this.webView.setSettings(inAppWebViewSettings, inAppWebViewSettingsMap);
        }
        result.success(true);
        break;
      case WebViewChannelDelegateMethods.getSettings:
        if (this.webView != null && this.webView.getInAppBrowserDelegate() instanceof InAppBrowserActivity) {
          let inAppBrowserActivity: InAppBrowserActivity = this.webView.getInAppBrowserDelegate() as InAppBrowserActivity;
          result.success(inAppBrowserActivity.getCustomSettings());
        } else {
          result.success((this.webView != null) ? this.webView.getCustomSettings() : null);
        }
        break;
      case WebViewChannelDelegateMethods.close:
        if (this.webView != null && this.webView.getInAppBrowserDelegate() instanceof InAppBrowserActivity) {
          let inAppBrowserActivity: InAppBrowserActivity = this.webView.getInAppBrowserDelegate() as InAppBrowserActivity;
          inAppBrowserActivity.close(result);
        } else {
          result.notImplemented();
        }
        break;
      case WebViewChannelDelegateMethods.show:
        if (this.webView != null && this.webView.getInAppBrowserDelegate() instanceof InAppBrowserActivity) {
          let inAppBrowserActivity: InAppBrowserActivity = this.webView.getInAppBrowserDelegate() as InAppBrowserActivity;
          inAppBrowserActivity.show();
          result.success(true);
        } else {
          result.notImplemented();
        }
        break;
      case WebViewChannelDelegateMethods.hide:
        if (this.webView != null && this.webView.getInAppBrowserDelegate() instanceof InAppBrowserActivity) {
          let inAppBrowserActivity: InAppBrowserActivity = this.webView.getInAppBrowserDelegate() as InAppBrowserActivity;
          inAppBrowserActivity.hide();
          result.success(true);
        } else {
          result.notImplemented();
        }
        break;
      case WebViewChannelDelegateMethods.isHidden:
        if (this.webView != null && this.webView.getInAppBrowserDelegate() instanceof InAppBrowserActivity) {
          let inAppBrowserActivity: InAppBrowserActivity = this.webView.getInAppBrowserDelegate() as InAppBrowserActivity;
          result.success(inAppBrowserActivity.isHidden);
        } else {
          result.notImplemented();
        }
        break;
      case WebViewChannelDelegateMethods.getCopyBackForwardList:
        result.success((this.webView != null) ? this.webView.getCopyBackForwardList() : null);
        break;
      case WebViewChannelDelegateMethods.startSafeBrowsing:
      // if (this.webView != null && WebViewFeature.isFeatureSupported(WebViewFeature.START_SAFE_BROWSING)) {
      //   WebViewCompat.startSafeBrowsing(this.webView.getContext(), new ValueCallback<Boolean>() {
      //     public onReceiveValue(success: boolean): void {
      //       result.success(success);
      //     }
      //   });
      // } else {
      //   result.success(false);
      // }
        break;
      case WebViewChannelDelegateMethods.clearCache:
        if (this.webView != null)
          this.webView.clearAllCache();
        result.success(true);
        break;
      case WebViewChannelDelegateMethods.clearSslPreferences:
        if (this.webView != null)
          this.webView.clearSslPreferences();
        result.success(true);
        break;
      case WebViewChannelDelegateMethods.findAll:
        if (this.webView != null) {
          let find: string = call.argument("find");
          this.webView.findAllAsync(find);
        }
        result.success(true);
        break;
      case WebViewChannelDelegateMethods.findNext:
        if (this.webView != null) {
          let forward: boolean = call.argument("forward") as boolean;
          this.webView.findNext(forward);
        }
        result.success(true);
        break;
      case WebViewChannelDelegateMethods.clearMatches:
        if (this.webView != null) {
          this.webView.clearMatches();
        }
        result.success(true);
        break;
      case WebViewChannelDelegateMethods.scrollTo:
        if (this.webView != null) {
          let x: number = call.argument("x") as number;
          let y: number = call.argument("y") as number;
          let animated: boolean = call.argument("animated") as boolean;
          this.webView.scrollTo(x, y, animated);
        }
        result.success(true);
        break;
      case WebViewChannelDelegateMethods.scrollBy:
        if (this.webView != null) {
          let x: number = call.argument("x") as number;
          let y: number = call.argument("y") as number;
          let animated: boolean = call.argument("animated") as boolean;
          this.webView.scrollBy(x, y, animated);
        }
        result.success(true);
        break;
      case WebViewChannelDelegateMethods.pause:
        if (this.webView != null) {
          this.webView.onPause();
        }
        result.success(true);
        break;
      case WebViewChannelDelegateMethods.resume:
        if (this.webView != null) {
          this.webView.onResume();
        }
        result.success(true);
        break;
      case WebViewChannelDelegateMethods.pauseTimers:
        if (this.webView != null) {
          this.webView.pauseTimers();
        }
        result.success(true);
        break;
      case WebViewChannelDelegateMethods.resumeTimers:
        if (this.webView != null) {
          this.webView.resumeTimers();
        }
        result.success(true);
        break;
      case WebViewChannelDelegateMethods.printCurrentPage:
        if (this.webView != null) {
          let settings: PrintJobSettings = new PrintJobSettings();
          let settingsMap: Map<string, Any> = call.argument("settings") as Map<string, Any>;
          if (settingsMap != null) {
            settings.parse(settingsMap);
          }
          result.success(this.webView.printCurrentPage(settings));
        } else {
          result.success(null);
        }
        break;
      case WebViewChannelDelegateMethods.getContentHeight:
        if (this.webView instanceof InAppWebView) {
          result.success(this.webView.getContentHeight());
        } else {
          result.success(null);
        }
        break;
      case WebViewChannelDelegateMethods.getContentWidth:
      // if (this.webView instanceof InAppWebView) {
      //   this.webView.getContentWidth(new ValueCallback<Integer>() {
      //     public onReceiveValue(contentWidth: number | null): void {
      //       result.success(contentWidth);
      //     }
      //   });
      // } else {
      //   result.success(null);
      // }
        break;
      case WebViewChannelDelegateMethods.zoomBy:
        if (this.webView != null) {
          let zoomFactor: number = call.argument("zoomFactor") as number;
          this.webView.zoomBy(zoomFactor as number);
        }
        result.success(true);
        break;
      case WebViewChannelDelegateMethods.getOriginalUrl:
        result.success((this.webView != null) ? this.webView.getOriginalUrl() : null);
        break;
      case WebViewChannelDelegateMethods.getZoomScale:
        if (this.webView instanceof InAppWebView) {
          result.success(this.webView.getZoomScale());
        } else {
          result.success(null);
        }
        break;
      case WebViewChannelDelegateMethods.getSelectedText:
      // if ((this.webView instanceof InAppWebView)) {
      //   this.webView.getSelectedText(new ValueCallback<String>() {
      //     public onReceiveValue(value: string): void {
      //       result.success(value);
      //     }
      //   });
      // } else {
      //   result.success(null);
      // }
        break;
      case WebViewChannelDelegateMethods.getHitTestResult:
        if (this.webView instanceof InAppWebView) {
          result.success(HitTestResult.fromWebViewHitTestResult(this.webView.getHitTestResult())!.toMap());
        } else {
          result.success(null);
        }
        break;
      case WebViewChannelDelegateMethods.pageDown:
        if (this.webView != null) {
          let bottom: boolean = call.argument("bottom") as boolean;
          result.success(this.webView.pageDown(bottom));
        } else {
          result.success(false);
        }
        break;
      case WebViewChannelDelegateMethods.pageUp:
        if (this.webView != null) {
          let top: boolean = call.argument("top") as boolean;
          result.success(this.webView.pageUp(top));
        } else {
          result.success(false);
        }
        break;
      case WebViewChannelDelegateMethods.saveWebArchive:
        if (this.webView != null) {
          let filePath: string = call.argument("filePath");
          let autoname: boolean = call.argument("autoname") as boolean;
          // this.webView.saveWebArchive(filePath, autoname, new ValueCallback<String>() {
          //   public void onReceiveValue(String value) {
          //     result.success(value);
          //   }
          // });
        } else {
          result.success(null);
        }
        break;
      case WebViewChannelDelegateMethods.zoomIn:
        if (this.webView != null) {
          result.success(this.webView.zoomIn());
        } else {
          result.success(false);
        }
        break;
      case WebViewChannelDelegateMethods.zoomOut:
        if (this.webView != null) {
          result.success(this.webView.zoomOut());
        } else {
          result.success(false);
        }
        break;
      case WebViewChannelDelegateMethods.clearFocus:
        if (this.webView != null) {
          this.webView.clearFocus();
        }
        result.success(true);
        break;
      case WebViewChannelDelegateMethods.setContextMenu:
        if (this.webView != null) {
          let contextMenu: Map<string, Any> = call.argument("contextMenu") as Map<string, Any>;
          this.webView.setContextMenu(contextMenu);
        }
        result.success(true);
        break;
      case WebViewChannelDelegateMethods.requestFocusNodeHref:
        if (this.webView != null) {
          /// 未完善
          result.success(this.webView.requestFocusNodeHref());
        } else {
          result.success(null);
        }
        break;
      case WebViewChannelDelegateMethods.requestImageRef:
        if (this.webView != null) {
          /// 未完善
          result.success(this.webView.requestImageRef());
        } else {
          result.success(null);
        }
        break;
      case WebViewChannelDelegateMethods.getScrollX:
        if (this.webView != null) {
          // result.success(this.webView.getScrollX());
        } else {
          result.success(null);
        }
        break;
      case WebViewChannelDelegateMethods.getScrollY:
        if (this.webView != null) {
          // result.success(this.webView.getScrollY());
        } else {
          result.success(null);
        }
        break;
      case WebViewChannelDelegateMethods.getCertificate:
        if (this.webView != null) {
          result.success(SslCertificateExt.toMap(await this.webView.getCertificate()));
        } else {
          result.success(null);
        }
        break;
      case WebViewChannelDelegateMethods.clearHistory:
        if (this.webView != null) {
          this.webView.clearHistory();
        }
        result.success(true);
        break;
      case WebViewChannelDelegateMethods.addUserScript:
        if (this.webView != null && this.webView.getUserContentController() != null) {
          let userScriptMap: Map<string, Any> = call.argument("userScript") as Map<string, Any>;
          let userScript: UserScript | null = UserScript.fromMap(userScriptMap);
          result.success(this.webView.getUserContentController().addUserOnlyScript(userScript!));
        } else {
          result.success(false);
        }
        break;
      case WebViewChannelDelegateMethods.removeUserScript:
        if (this.webView != null && this.webView.getUserContentController() != null) {
          let index: number = call.argument("index") as number;
          let userScriptMap: Map<string, Any> = call.argument("userScript") as Map<string, Any>;
          let userScript: UserScript | null = UserScript.fromMap(userScriptMap);
          result.success(this.webView.getUserContentController()
            .removeUserOnlyScriptAt(index, userScript!.getInjectionTime()));
        } else {
          result.success(false);
        }
        break;
      case WebViewChannelDelegateMethods.removeUserScriptsByGroupName:
        if (this.webView != null && this.webView.getUserContentController() != null) {
          let groupName: string = call.argument("groupName");
          this.webView.getUserContentController().removeUserOnlyScriptsByGroupName(groupName);
        }
        result.success(true);
        break;
      case WebViewChannelDelegateMethods.removeAllUserScripts:
        if (this.webView != null && this.webView.getUserContentController() != null) {
          this.webView.getUserContentController().removeAllUserOnlyScripts();
        }
        result.success(true);
        break;
      case WebViewChannelDelegateMethods.callAsyncJavaScript:
        if (this.webView != null) {
          let functionBody: string = call.argument("functionBody");
          let functionArguments: Map<string, Any> = call.argument("arguments") as Map<string, Any>;
          let contentWorldMap: Map<string, Any> = call.argument("contentWorld") as Map<string, Any>;
          let contentWorld: ContentWorld | null = ContentWorld.fromMap(contentWorldMap);
          this.webView.callAsyncJavaScript(functionBody, functionArguments, contentWorld, {
            onReceiveValue: (value: string | null): void => {
              result.success(value);
            }
          });
        } else {
          result.success(null);
        }
        break;
      case WebViewChannelDelegateMethods.isSecureContext:
      // if (this.webView != null) {
      //   this.webView.isSecureContext(new ValueCallback<Boolean>() {
      //     public onReceiveValue(value: boolean): void {
      //       result.success(value);
      //     }
      //   });
      // } else {
      //   result.success(false);
      // }
        break;
      case WebViewChannelDelegateMethods.createWebMessageChannel:
        if (this.webView != null) {
          // if (this.webView instanceof InAppWebView && WebViewFeature.isFeatureSupported(WebViewFeature.CREATE_WEB_MESSAGE_CHANNEL)) {
          //   result.success(this.webView.createCompatWebMessageChannel().toMap());
          // } else {
          //   result.success(null);
          // }
        } else {
          result.success(null);
        }
        break;
      case WebViewChannelDelegateMethods.postWebMessage:
      // if (this.webView != null && WebViewFeature.isFeatureSupported(WebViewFeature.POST_WEB_MESSAGE)) {
      //   let message: WebMessageCompatExt | null = WebMessageCompatExt.fromMap(call.argument("message") as Map<string, Any>);
      //   let targetOrigin: string = call.argument("targetOrigin");
      //   let compatPorts: List<WebMessagePortCompat> = new List<WebMessagePortCompat>();
      //   let portsExt: List<WebMessagePortCompatExt> = message.getPorts();
      //   if (portsExt != null) {
      //     for (let portExt of portsExt) {
      //       let webMessageChannel: WebMessageChannel | undefined = this.webView.getWebMessageChannels().get(portExt.getWebMessageChannelId());
      //       if (webMessageChannel != null) {
      //         if (this.webView instanceof InAppWebView) {
      //           // compatPorts.add(webMessageChannel.compatPorts.get(portExt.getIndex()));
      //         }
      //       }
      //     }
      //   }
      //   let data: Any = message.getData();
      //   if (webView instanceof InAppWebView) {
      //     try {
      //       if (WebViewFeature.isFeatureSupported(WebViewFeature.WEB_MESSAGE_ARRAY_BUFFER) && data != null &&
      //               message.getType() == WebMessageCompat.TYPE_ARRAY_BUFFER) {
      //         WebViewCompat.postWebMessage((WebView) webView,
      //                 new WebMessageCompat((byte[]) data, compatPorts.toArray(new WebMessagePortCompat[0])),
      //                 Uri.parse(targetOrigin));
      //       } else {
      //         WebViewCompat.postWebMessage((WebView) webView,
      //                 new WebMessageCompat(data != null ? data.toString() : null, compatPorts.toArray(new WebMessagePortCompat[0])),
      //                 Uri.parse(targetOrigin));
      //       }
      //       result.success(true);
      //     } catch (Exception e) {
      //       result.error(LOG_TAG, e.getMessage(), null);
      //     }
      //   }
      // } else {
      //   result.success(true);
      // }
        break;
      case WebViewChannelDelegateMethods.addWebMessageListener:
        if (this.webView != null) {
          let webMessageListenerMap: Map<string, Any> = call.argument("webMessageListener") as Map<string, Any>;
          let webMessageListener: WebMessageListener | null = WebMessageListener.fromMap(this.webView, this.webView.getPlugin()
            .messenger, webMessageListenerMap);
          // if (this.webView instanceof InAppWebView && WebViewFeature.isFeatureSupported(WebViewFeature.WEB_MESSAGE_LISTENER)) {
          //   try {
          //     this.webView.addWebMessageListener(webMessageListener!);
          //     result.success(true);
          //   } catch (e) {
          //     result.error(LOG_TAG, e.getMessage(), null);
          //   }
          // } else {
          //   result.success(true);
          // }
        } else {
          result.success(true);
        }
        break;
      case WebViewChannelDelegateMethods.canScrollVertically:
        if (this.webView != null) {
          result.success(this.webView.canScrollVertically());
        } else {
          result.success(false);
        }
        break;
      case WebViewChannelDelegateMethods.canScrollHorizontally:
        if (this.webView != null) {
          result.success(this.webView.canScrollHorizontally());
        } else {
          result.success(false);
        }
        break;
      case WebViewChannelDelegateMethods.isInFullscreen:
        if (this.webView != null) {
          result.success(this.webView.isInFullscreen());
        } else {
          result.success(false);
        }
        break;
      case WebViewChannelDelegateMethods.clearFormData:
        if (this.webView != null) {
          // this.webView.clearFormData();
        }
        result.success(true);
        break;
    }
  }

  public onFindResultReceived(activeMatchOrdinal: number, numberOfMatches: number, isDoneCounting: boolean): void {
    let channel: MethodChannel = this.getChannel()
    if (channel == null) return
    let obj: Map<string, Any> = new Map<string, Any>()
    obj.set("activeMatchOrdinal", activeMatchOrdinal);
    obj.set("numberOfMatches", numberOfMatches);
    obj.set("isDoneCounting", isDoneCounting);
    channel.invokeMethod("onFindResultReceived", obj);
  }

  public onLongPressHitTestResult(hitTestResult: HitTestResult): void {
    let channel: MethodChannel = this.getChannel()
    if (channel == null) return
    channel.invokeMethod("onLongPressHitTestResult", hitTestResult.toMap())
  }

  public onScrollChanged(x: number, y: number): void {
    let channel: MethodChannel = this.getChannel()
    if (channel == null) return;
    let obj: Map<string, Any> = new Map<string, Any>();
    obj.set("x", x);
    obj.set("y", y);
    channel.invokeMethod("onScrollChanged", obj);
  }

  public onDownloadStartRequest(downloadStartRequest: DownloadStartRequest) {
    let channel: MethodChannel = this.getChannel()
    if (channel == null) return
    channel.invokeMethod("onDownloadStartRequest", downloadStartRequest.toMap())
  }

  public onCreateContextMenu(hitTestResult: HitTestResult) {
    let channel: MethodChannel = this.getChannel()
    if (channel == null) return
    channel.invokeMethod("onCreateContextMenu", hitTestResult.toMap())
  }

  public onOverScrolled(scrollX: number, scrollY: number, clampedX: boolean, clampedY: boolean): void {
    let channel: MethodChannel = this.getChannel()
    if (channel == null) return;
    let obj: Map<string, Any> = new Map<string, Any>();
    obj.set("x", scrollX);
    obj.set("y", scrollY);
    obj.set("clampedX", clampedX);
    obj.set("clampedY", clampedY);
    channel.invokeMethod("onOverScrolled", obj);
  }

  public onContextMenuActionItemClicked(itemId: number, itemTitle: string): void {
    let channel: MethodChannel = this.getChannel()
    if (channel == null) return;
    let obj: Map<string, Any> = new Map<string, Any>();
    obj.set("id", itemId);
    obj.set("androidId", itemId);
    obj.set("iosId", null);
    obj.set("title", itemTitle);
    channel.invokeMethod("onContextMenuActionItemClicked", obj);
  }

  public onHideContextMenu(): void {
    let channel: MethodChannel = this.getChannel()
    if (channel == null) return
    let obj: Map<string, Any> = new Map<string, Any>()
    channel.invokeMethod("onHideContextMenu", obj)
  }

  public onEnterFullscreen(): void {
    let channel: MethodChannel = this.getChannel()
    if (channel == null) return
    let obj: Map<string, Any> = new Map<string, Any>()
    channel.invokeMethod("onEnterFullscreen", obj);
  }

  public onExitFullscreen(): void {
    let channel: MethodChannel = this.getChannel()
    if (channel == null) return
    let obj: Map<string, Any> = new Map<string, Any>()
    channel.invokeMethod("onExitFullscreen", obj);
  }

  public onJsAlert(url: string, message: string, isMainFrame: boolean | null, callback: JsAlertCallback): void {
    let channel: MethodChannel = this.getChannel()
    if (channel == null) {
      callback.defaultBehaviour(null);
      return;
    }
    let obj: Map<string, Any> = new Map<string, Any>();
    obj.set("url", url);
    obj.set("message", message);
    obj.set("isMainFrame", isMainFrame);
    channel.invokeMethod("onJsAlert", obj, callback);
  }

  public onJsConfirm(url: string, message: string, isMainFrame: boolean | null, callback: JsConfirmCallback): void {
    let channel: MethodChannel = this.getChannel()
    if (channel == null) {
      callback.defaultBehaviour(null);
      return;
    }
    let obj: Map<string, Any> = new Map<string, Any>();
    obj.set("url", url);
    obj.set("message", message);
    obj.set("isMainFrame", isMainFrame);
    channel.invokeMethod("onJsConfirm", obj, callback);
  }

  public onJsPrompt(url: string, message: string, defaultValue: string, isMainFrame: boolean | null, callback: JsPromptCallback): void {
    let channel: MethodChannel = this.getChannel()
    if (channel == null) {
      callback.defaultBehaviour(null);
      return;
    }
    let obj: Map<string, Any> = new Map<string, Any>();
    obj.set("url", url);
    obj.set("message", message);
    obj.set("defaultValue", defaultValue);
    obj.set("isMainFrame", isMainFrame);
    channel.invokeMethod("onJsPrompt", obj, callback);
  }

  public onJsBeforeUnload(url: string, message: string, callback: JsBeforeUnloadCallback): void {
    let channel: MethodChannel = this.getChannel()
    if (channel == null) {
      callback.defaultBehaviour(null);
      return;
    }
    let obj: Map<string, Any> = new Map<string, Any>();
    obj.set("url", url);
    obj.set("message", message);
    channel.invokeMethod("onJsBeforeUnload", obj, callback);
  }

  public onCreateWindow(createWindowAction: CreateWindowAction, callback: CreateWindowCallback) {
    let channel: MethodChannel = this.getChannel()
    if (channel == null) {
      callback.defaultBehaviour(null);
      return;
    }
    channel.invokeMethod("onCreateWindow", createWindowAction.toMap(), callback);
  }

  public onCloseWindow(): void {
    let channel: MethodChannel = this.getChannel();
    if (channel == null) return;
    let obj: Map<string, Any> = new Map<string, Any>();
    channel.invokeMethod("onCloseWindow", obj);
  }

  public onGeolocationPermissionsShowPrompt(origin: string, callback: GeolocationPermissionsShowPromptCallback): void {
    let channel: MethodChannel = this.getChannel();
    if (channel == null) {
      callback.defaultBehaviour(null);
      return;
    }
    let obj: Map<string, Any> = new Map<string, Any>();
    obj.set("origin", origin)
    channel.invokeMethod("onCloseWindow", obj);
  }

  public onGeolocationPermissionsHidePrompt(): void {
    let channel: MethodChannel = this.getChannel();
    if (channel == null) return;
    let obj: Map<string, Any> = new Map<string, Any>();
    channel.invokeMethod("onGeolocationPermissionsHidePrompt", obj);
  }

  public onConsoleMessage(message: string, messageLevel: number): void {
    let channel: MethodChannel = this.getChannel();
    if (channel == null) return;
    let obj: Map<string, Any> = new Map<string, Any>();
    obj.set("message", message);
    obj.set("messageLevel", messageLevel);
    channel.invokeMethod("onConsoleMessage", obj);
  }

  public onProgressChanged(progress: number): void {
    let channel: MethodChannel = this.getChannel();
    if (channel == null) return;
    let obj: Map<string, Any> = new Map<string, Any>();
    obj.set("progress", progress);
    channel.invokeMethod("onProgressChanged", obj);
  }

  public onTitleChanged(title: string): void {
    let channel: MethodChannel = this.getChannel();
    if (channel == null) return;
    let obj: Map<string, Any> = new Map<string, Any>();
    obj.set("title", title);
    channel.invokeMethod("onTitleChanged", obj);
  }

  public onReceivedIcon(icon: ArrayBuffer): void {
    let channel: MethodChannel = this.getChannel();
    if (channel == null) return;
    let obj: Map<string, Any> = new Map<string, Any>();
    obj.set("icon", icon);
    channel.invokeMethod("onReceivedIcon", obj);
  }

  public onReceivedTouchIconUrl(url: string, precomposed: boolean): void {
    let channel: MethodChannel = this.getChannel();
    if (channel == null) return;
    let obj: Map<string, Any> = new Map<string, Any>();
    obj.set("url", url);
    obj.set("precomposed", precomposed);
    channel.invokeMethod("onReceivedTouchIconUrl", obj);
  }

  public onPermissionRequest(origin: string, resources: List<string>, frame: Any, callback: PermissionRequestCallback) {
    let channel: MethodChannel = this.getChannel();
    if (channel == null) {
      callback.defaultBehaviour(null);
      return;
    }
    let obj: Map<string, Any> = new Map<string, Any>();
    obj.set("origin", origin);
    obj.set("resources", resources);
    obj.set("frame", frame);
    channel.invokeMethod("onPermissionRequest", obj, callback);
  }

  public onPermissionRequestCanceled(origin: string, resources: List<string>): void {
    let channel: MethodChannel = this.getChannel();
    if (channel == null) return;
    let obj: Map<string, Any> = new Map<string, Any>();
    obj.set("origin", origin);
    obj.set("resources", resources);
    channel.invokeMethod("onPermissionRequestCanceled", obj);
  }

  public onLoadStart(url: string) {
    let channel: MethodChannel = this.getChannel();
    if (channel == null) return;
    let obj: Map<string, Any> = new Map<string, Any>();
    obj.set("url", url);
    channel.invokeMethod("onLoadStart", obj);
  }

  public onLoadStop(url: string) {
    let channel: MethodChannel = this.getChannel();
    if (channel == null) return;
    let obj: Map<string, Any> = new Map<string, Any>();
    obj.set("url", url);
    channel.invokeMethod("onLoadStop", obj);
  }

  public onUpdateVisitedHistory(url: string, isReload: boolean) {
    let channel: MethodChannel = this.getChannel();
    if (channel == null) return;
    let obj: Map<string, Any> = new Map<string, Any>();
    obj.set("url", url);
    obj.set("isReload", isReload);
    channel.invokeMethod("onUpdateVisitedHistory", obj);
  }

  public onReceivedError(request: WebResourceRequestExt, error: WebResourceErrorExt): void {
    let channel: MethodChannel = this.getChannel();
    if (channel == null) return;
    let obj: Map<string, Any> = new Map<string, Any>();
    obj.set("request", request.toMap());
    obj.set("error", error.toMap());
    channel.invokeMethod("onReceivedError", obj);
  }

  public onReceivedHttpError(request: WebResourceRequestExt, errorResponse: WebResourceResponseExt): void {
    let channel: MethodChannel = this.getChannel();
    if (channel == null) return;
    let obj: Map<string, Any> = new Map<string, Any>();
    obj.set("request", request.toMap());
    obj.set("errorResponse", errorResponse.toMap());
    channel.invokeMethod("onReceivedHttpError", obj);
  }

  public onReceivedHttpAuthRequest(challenge: HttpAuthenticationChallenge, callback: ReceivedHttpAuthRequestCallback) {
    let channel: MethodChannel = this.getChannel();
    if (channel == null) {
      callback.defaultBehaviour(null);
      return;
    }
    channel.invokeMethod("onReceivedHttpAuthRequest", challenge.toMap(), callback);
  }

  async shouldInterceptRequest(request: WebResourceRequestExt) {
    let channel = this.getChannel();
    if (channel == null) return null;
    let callback = new SyncShouldInterceptRequestCallback();
    channel.invokeMethod("shouldInterceptRequest", request.toMap(), callback);
    await callback.waitResponse()
    return callback.result;
  }

  async onLoadResourceWithCustomScheme(request: WebResourceRequestExt) {
    let channel = this.getChannel();
    if (channel == null) return null;
    let obj: Map<string, Any> = new Map<string, Any>();
    obj.set("request", request.toMap());
    let callback = new SyncLoadResourceWithCustomSchemeCallback();
    channel.invokeMethod("onLoadResourceWithCustomScheme", obj, callback);
    await callback.waitResponse()
    return callback.result;
  }

  async shouldOverrideUrlLoading(navigationAction: NavigationAction) {
    let channel = this.getChannel();
    if (channel == null) {
      return NavigationActionPolicy.ALLOW;
    }
    let callback = new SyncShouldOverrideUrlLoadingCallback();
    channel.invokeMethod("shouldOverrideUrlLoading", navigationAction.toMap(), callback);
    await callback.waitResponse()
    return callback.result;
  }

  onCallJsHandler(handlerName: string, args: string, callback: CallJsHandlerCallback) {
    let channel = this.getChannel();
    if (channel == null) {
      callback.defaultBehaviour(null);
      return;
    }
    let obj: Map<string, Any> = new Map<string, Any>();
    obj.set("handlerName", handlerName);
    obj.set("args", args);
    channel.invokeMethod("onCallJsHandler", obj, callback);
  }

  onPrintRequest(url: string, printJobId: string, callback: PrintRequestCallback) {
    let channel = this.getChannel();
    if (channel == null) {
      callback.defaultBehaviour(null);
      return;
    }
    let obj: Map<string, Any> = new Map<string, Any>();
    obj.set("url", url);
    obj.set("printJobId", printJobId);
    channel.invokeMethod("onPrintRequest", obj, callback);
  }

  onZoomScaleChanged(oldScale: number, newScale: number) {
    let channel = this.getChannel();
    if (channel == null) return;
    let obj: Map<string, Any> = new Map<string, Any>();
    obj.set("oldScale", oldScale);
    obj.set("newScale", newScale);
    channel.invokeMethod("onZoomScaleChanged", obj);
  }

  onRenderProcessGone(didCrash: boolean, rendererPriorityAtExit: number) {
    let channel = this.getChannel();
    if (channel == null) return;
    let obj: Map<string, Any> = new Map<string, Any>();
    obj.set("didCrash", didCrash);
    obj.set("rendererPriorityAtExit", rendererPriorityAtExit);
    channel.invokeMethod("onRenderProcessGone", obj);
  }
}

export class JsAlertCallback extends BaseCallbackResultImpl<JsAlertResponse> {
  public decodeResult(obj: Any): JsAlertResponse | null {
    return JsAlertResponse.fromMap(obj as Map<string, Any>);
  }
}

export class JsConfirmCallback extends BaseCallbackResultImpl<JsConfirmResponse> {
  public decodeResult(obj: Any): JsConfirmResponse | null {
    return JsConfirmResponse.fromMap(obj as Map<string, Any>);
  }
}

export class JsPromptCallback extends BaseCallbackResultImpl<JsPromptResponse> {
  public decodeResult(obj: Any): JsPromptResponse | null {
    return JsPromptResponse.fromMap(obj as Map<string, Any>);
  }
}

export class JsBeforeUnloadCallback extends BaseCallbackResultImpl<JsBeforeUnloadResponse> {
  public decodeResult(obj: Any): JsBeforeUnloadResponse | null {
    return JsBeforeUnloadResponse.fromMap(obj as Map<string, Any>);
  }
}

export class CreateWindowCallback extends BaseCallbackResultImpl<Boolean> {
  public decodeResult(obj: Any): Boolean | null {
    return (obj instanceof Boolean) && obj as boolean;
  }
}

export class GeolocationPermissionsShowPromptCallback extends BaseCallbackResultImpl<GeolocationPermissionShowPromptResponse> {
  public decodeResult(obj: Any): GeolocationPermissionShowPromptResponse | null {
    return GeolocationPermissionShowPromptResponse.fromMap(obj as Map<string, Any>);
  }
}

export class PermissionRequestCallback extends BaseCallbackResultImpl<PermissionResponse> {
  public decodeResult(obj: Any): PermissionResponse | null {
    return PermissionResponse.fromMap(obj as Map<string, Any>);
  }
}

export class ReceivedHttpAuthRequestCallback extends BaseCallbackResultImpl<HttpAuthResponse> {
  public decodeResult(obj: Any): HttpAuthResponse | null {
    return HttpAuthResponse.fromMap(obj as Map<string, Any>);
  }
}

class ShouldInterceptRequestCallback extends BaseCallbackResultImpl<WebResourceResponseExt> {
  public decodeResult(obj: Any): WebResourceResponseExt | null {
    return WebResourceResponseExt.fromMap(obj);
  }
}

class SyncShouldInterceptRequestCallback extends SyncBaseCallbackResultImpl<WebResourceResponseExt> {
  public decodeResult(obj: Any): WebResourceResponseExt | null {
    return (new ShouldInterceptRequestCallback()).decodeResult(obj);
  }
}

class LoadResourceWithCustomSchemeCallback extends BaseCallbackResultImpl<CustomSchemeResponse> {
  public decodeResult(obj: Any): CustomSchemeResponse | null {
    return CustomSchemeResponse.fromMap(obj);
  }
}

class SyncLoadResourceWithCustomSchemeCallback extends SyncBaseCallbackResultImpl<CustomSchemeResponse> {
  public decodeResult(obj: Any): CustomSchemeResponse | null {
    return (new LoadResourceWithCustomSchemeCallback()).decodeResult(obj);
  }
}

export class SyncShouldOverrideUrlLoadingCallback extends SyncBaseCallbackResultImpl<NavigationActionPolicy> {
  public decodeResult(obj: Any): NavigationActionPolicy {
    if (!(typeof obj == 'number')) {
      return NavigationActionPolicy.CANCEL;
    }
    return obj;
  }
}

export class CallJsHandlerCallback extends BaseCallbackResultImpl<Any> {
  public decodeResult(obj: Any): Any {
    return obj;
  }
}

export class PrintRequestCallback extends BaseCallbackResultImpl<boolean> {
  public decodeResult(obj: Any): boolean {
    return obj;
  }
}