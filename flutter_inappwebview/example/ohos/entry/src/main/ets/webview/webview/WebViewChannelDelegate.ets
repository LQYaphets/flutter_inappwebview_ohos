import { MethodCall, MethodChannel } from '@ohos/flutter_ohos';
import { MethodResult } from '@ohos/flutter_ohos/src/main/ets/plugin/common/MethodChannel';
import ChannelDelegateImpl from '../types/ChannelDelegateImpl';
import ContentWorld from '../types/ContentWorld';
import URLRequest from '../types/URLRequest';
import { WebViewChannelDelegateMethods } from '../WebViewChannelDelegateMethods';
import InAppWebView from './in_app_webview/InAppWebView';

const LOG_TAG = "WebViewChannelDelegate";

export default class WebViewChannelDelegate extends ChannelDelegateImpl{
  private webView: InAppWebView;

  constructor(webView: InAppWebView, channel: MethodChannel) {
    super(channel);
    this.webView = webView;
  }

  public onMethodCall(call: MethodCall, result: MethodResult): void {
    let method: WebViewChannelDelegateMethods;
    try {
      method = WebViewChannelDelegateMethods[call.method];
    } catch (e) {
      result.notImplemented();
      return;
    }
    switch (method) {
      case WebViewChannelDelegateMethods.getUrl:
        // result.success((this.webView != null) ? this.webView.getUrl() : null);
        break;
      case WebViewChannelDelegateMethods.getTitle:
        // result.success((this.webView != null) ? this.webView.getTitle() : null);
        break;
      case WebViewChannelDelegateMethods.getProgress:
        // result.success((this.webView != null) ? this.webView.getProgress() : null);
        break;
      case WebViewChannelDelegateMethods.loadUrl:
        if (this.webView != null) {
          let urlRequest: Map<string, ESObject> = call.argument("urlRequest") as Map<string, ESObject>;
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
          let contentWorldMap: Map<string, ESObject> = call.argument("contentWorld") as Map<string, ESObject>;
          let contentWorld: ContentWorld | null = ContentWorld.fromMap(contentWorldMap);
          this.webView.evaluateJavascript(source, contentWorld!, null
           // new ValueCallback<String>() {
           //    public onReceiveValue(value: string): void {
           //      result.success(value);
           //    }
           //  }
          );
        } else {
          result.success(null);
        }
        break;
      case WebViewChannelDelegateMethods.injectJavascriptFileFromUrl:
        if (this.webView != null) {
          let urlFile: string = call.argument("urlFile");
          let scriptHtmlTagAttributes: Map<string, ESObject> = call.argument("scriptHtmlTagAttributes") as Map<string, ESObject>;
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
          let cssLinkHtmlTagAttributes: Map<string, ESObject> = call.argument("cssLinkHtmlTagAttributes") as Map<string, ESObject>;
          this.webView.injectCSSFileFromUrl(urlFile, cssLinkHtmlTagAttributes);
        }
        result.success(true);
        break;
      case WebViewChannelDelegateMethods.reload:
        if (this.webView != null)
          // this.webView.reload();
        result.success(true);
        break;
      case WebViewChannelDelegateMethods.goBack:
        if (this.webView != null)
          // webView.goBack();
        result.success(true);
        break;
      case WebViewChannelDelegateMethods.canGoBack:
        // result.success((this.webView != null) && this.webView.canGoBack());
        break;
      case WebViewChannelDelegateMethods.goForward:
        if (this.webView != null)
          // this.webView.goForward();
        result.success(true);
        break;
      case WebViewChannelDelegateMethods.canGoForward:
        // result.success((this.webView != null) && this.webView.canGoForward());
        break;
      case WebViewChannelDelegateMethods.goBackOrForward:
        if (this.webView != null)
          // this.webView.goBackOrForward(call.argument("steps") as number);
        result.success(true);
        break;
      case WebViewChannelDelegateMethods.canGoBackOrForward:
        // result.success((this.webView != null) && this.webView.canGoBackOrForward(call.argument("steps")) as number);
        break;
      case WebViewChannelDelegateMethods.stopLoading:
        if (this.webView != null)
          // this.webView.stopLoading();
        result.success(true);
        break;
      case WebViewChannelDelegateMethods.isLoading:
        // result.success((this.webView != null) && this.webView.isLoading());
        break;
      case WebViewChannelDelegateMethods.takeScreenshot:
        if (this.webView != null) {
          let screenshotConfiguration: Map<string, ESObject> = call.argument("screenshotConfiguration") as Map<string, ESObject>;
          this.webView.takeScreenshot(screenshotConfiguration, result);
        } else
          result.success(null);
        break;
      case WebViewChannelDelegateMethods.setSettings:
        // if (this.webView != null && this.webView.getInAppBrowserDelegate() instanceof InAppBrowserActivity) {
        //   InAppBrowserActivity inAppBrowserActivity = (InAppBrowserActivity) webView.getInAppBrowserDelegate();
        //   InAppBrowserSettings inAppBrowserSettings = new InAppBrowserSettings();
        //   HashMap<String, Object> inAppBrowserSettingsMap = (HashMap<String, Object>) call.argument("settings");
        //   inAppBrowserSettings.parse(inAppBrowserSettingsMap);
        //   inAppBrowserActivity.setSettings(inAppBrowserSettings, inAppBrowserSettingsMap);
        // } else if (this.webView != null) {
        //   InAppWebViewSettings inAppWebViewSettings = new InAppWebViewSettings();
        //   HashMap<String, Object> inAppWebViewSettingsMap = (HashMap<String, Object>) call.argument("settings");
        //   inAppWebViewSettings.parse(inAppWebViewSettingsMap);
        //   webView.setSettings(inAppWebViewSettings, inAppWebViewSettingsMap);
        // }
        result.success(true);
        break;
      // case getSettings:
      //   if (webView != null && webView.getInAppBrowserDelegate() instanceof InAppBrowserActivity) {
      //     InAppBrowserActivity inAppBrowserActivity = (InAppBrowserActivity) webView.getInAppBrowserDelegate();
      //     result.success(inAppBrowserActivity.getCustomSettings());
      //   } else {
      //     result.success((webView != null) ? webView.getCustomSettings() : null);
      //   }
      //   break;
      // case close:
      //   if (webView != null && webView.getInAppBrowserDelegate() instanceof InAppBrowserActivity) {
      //     InAppBrowserActivity inAppBrowserActivity = (InAppBrowserActivity) webView.getInAppBrowserDelegate();
      //     inAppBrowserActivity.close(result);
      //   } else {
      //     result.notImplemented();
      //   }
      //   break;
      // case show:
      //   if (webView != null && webView.getInAppBrowserDelegate() instanceof InAppBrowserActivity) {
      //     InAppBrowserActivity inAppBrowserActivity = (InAppBrowserActivity) webView.getInAppBrowserDelegate();
      //     inAppBrowserActivity.show();
      //     result.success(true);
      //   } else {
      //     result.notImplemented();
      //   }
      //   break;
      // case hide:
      //   if (webView != null && webView.getInAppBrowserDelegate() instanceof InAppBrowserActivity) {
      //     InAppBrowserActivity inAppBrowserActivity = (InAppBrowserActivity) webView.getInAppBrowserDelegate();
      //     inAppBrowserActivity.hide();
      //     result.success(true);
      //   } else {
      //     result.notImplemented();
      //   }
      //   break;
      // case isHidden:
      //   if (webView != null && webView.getInAppBrowserDelegate() instanceof InAppBrowserActivity) {
      //     InAppBrowserActivity inAppBrowserActivity = (InAppBrowserActivity) webView.getInAppBrowserDelegate();
      //     result.success(inAppBrowserActivity.isHidden);
      //   } else {
      //     result.notImplemented();
      //   }
      //   break;
      // case getCopyBackForwardList:
      //   result.success((webView != null) ? webView.getCopyBackForwardList() : null);
      //   break;
      // case startSafeBrowsing:
      //   if (webView != null && WebViewFeature.isFeatureSupported(WebViewFeature.START_SAFE_BROWSING)) {
      //     WebViewCompat.startSafeBrowsing(webView.getContext(), new ValueCallback<Boolean>() {
      //       @Override
      //       public void onReceiveValue(Boolean success) {
      //         result.success(success);
      //       }
      //     });
      //   } else {
      //     result.success(false);
      //   }
      //   break;
      // case clearCache:
      //   if (webView != null)
      //     webView.clearAllCache();
      //   result.success(true);
      //   break;
      // case clearSslPreferences:
      //   if (webView != null)
      //     webView.clearSslPreferences();
      //   result.success(true);
      //   break;
      // case findAll:
      //   if (webView != null) {
      //     String find = call.argument("find");
      //     webView.findAllAsync(find);
      //   }
      //   result.success(true);
      //   break;
      // case findNext:
      //   if (webView != null) {
      //     Boolean forward = (Boolean) call.argument("forward");
      //     webView.findNext(forward);
      //   }
      //   result.success(true);
      //   break;
      // case clearMatches:
      //   if (webView != null) {
      //     webView.clearMatches();
      //   }
      //   result.success(true);
      //   break;
      // case scrollTo:
      //   if (webView != null) {
      //     Integer x = (Integer) call.argument("x");
      //     Integer y = (Integer) call.argument("y");
      //     Boolean animated = (Boolean) call.argument("animated");
      //     webView.scrollTo(x, y, animated);
      //   }
      //   result.success(true);
      //   break;
      // case scrollBy:
      //   if (webView != null) {
      //     Integer x = (Integer) call.argument("x");
      //     Integer y = (Integer) call.argument("y");
      //     Boolean animated = (Boolean) call.argument("animated");
      //     webView.scrollBy(x, y, animated);
      //   }
      //   result.success(true);
      //   break;
      // case pause:
      //   if (webView != null) {
      //     webView.onPause();
      //   }
      //   result.success(true);
      //   break;
      // case resume:
      //   if (webView != null) {
      //     webView.onResume();
      //   }
      //   result.success(true);
      //   break;
      // case pauseTimers:
      //   if (webView != null) {
      //     webView.pauseTimers();
      //   }
      //   result.success(true);
      //   break;
      // case resumeTimers:
      //   if (webView != null) {
      //     webView.resumeTimers();
      //   }
      //   result.success(true);
      //   break;
      // case printCurrentPage:
      //   if (webView != null && Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
      //     PrintJobSettings settings = new PrintJobSettings();
      //     Map<String, Object> settingsMap = (Map<String, Object>) call.argument("settings");
      //     if (settingsMap != null) {
      //       settings.parse(settingsMap);
      //     }
      //     result.success(webView.printCurrentPage(settings));
      //   } else {
      //     result.success(null);
      //   }
      //   break;
      // case getContentHeight:
      //   if (webView instanceof InAppWebView) {
      //     result.success(webView.getContentHeight());
      //   } else {
      //     result.success(null);
      //   }
      //   break;
      // case getContentWidth:
      //   if (webView instanceof InAppWebView) {
      //     webView.getContentWidth(new ValueCallback<Integer>() {
      //       @Override
      //       public void onReceiveValue(@Nullable Integer contentWidth) {
      //         result.success(contentWidth);
      //       }
      //     });
      //   } else {
      //     result.success(null);
      //   }
      //   break;
      // case zoomBy:
      //   if (webView != null && Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
      //     double zoomFactor = (double) call.argument("zoomFactor");
      //     webView.zoomBy((float) zoomFactor);
      //   }
      //   result.success(true);
      //   break;
      // case getOriginalUrl:
      //   result.success((webView != null) ? webView.getOriginalUrl() : null);
      //   break;
      // case getZoomScale:
      //   if (webView instanceof InAppWebView) {
      //     result.success(webView.getZoomScale());
      //   } else {
      //     result.success(null);
      //   }
      //   break;
      // case getSelectedText:
      //   if ((webView instanceof InAppWebView && Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT)) {
      //     webView.getSelectedText(new ValueCallback<String>() {
      //       @Override
      //       public void onReceiveValue(String value) {
      //         result.success(value);
      //       }
      //     });
      //   } else {
      //     result.success(null);
      //   }
      //   break;
      // case getHitTestResult:
      //   if (webView instanceof InAppWebView) {
      //     result.success(HitTestResult.fromWebViewHitTestResult(webView.getHitTestResult()).toMap());
      //   } else {
      //     result.success(null);
      //   }
      //   break;
      // case pageDown:
      //   if (webView != null) {
      //     boolean bottom = (boolean) call.argument("bottom");
      //     result.success(webView.pageDown(bottom));
      //   } else {
      //     result.success(false);
      //   }
      //   break;
      // case pageUp:
      //   if (webView != null) {
      //     boolean top = (boolean) call.argument("top");
      //     result.success(webView.pageUp(top));
      //   } else {
      //     result.success(false);
      //   }
      //   break;
      // case saveWebArchive:
      //   if (webView != null) {
      //     String filePath = call.argument("filePath");
      //     boolean autoname = (boolean) call.argument("autoname");
      //     webView.saveWebArchive(filePath, autoname, new ValueCallback<String>() {
      //       @Override
      //       public void onReceiveValue(String value) {
      //         result.success(value);
      //       }
      //     });
      //   } else {
      //     result.success(null);
      //   }
      //   break;
      // case zoomIn:
      //   if (webView != null) {
      //     result.success(webView.zoomIn());
      //   } else {
      //     result.success(false);
      //   }
      //   break;
      // case zoomOut:
      //   if (webView != null) {
      //     result.success(webView.zoomOut());
      //   } else {
      //     result.success(false);
      //   }
      //   break;
      // case clearFocus:
      //   if (webView != null) {
      //     webView.clearFocus();
      //   }
      //   result.success(true);
      //   break;
      // case setContextMenu:
      //   if (webView != null) {
      //     Map<String, Object> contextMenu = (Map<String, Object>) call.argument("contextMenu");
      //     webView.setContextMenu(contextMenu);
      //   }
      //   result.success(true);
      //   break;
      // case requestFocusNodeHref:
      //   if (webView != null) {
      //     result.success(webView.requestFocusNodeHref());
      //   } else {
      //     result.success(null);
      //   }
      //   break;
      // case requestImageRef:
      //   if (webView != null) {
      //     result.success(webView.requestImageRef());
      //   } else {
      //     result.success(null);
      //   }
      //   break;
      // case getScrollX:
      //   if (webView != null) {
      //     result.success(webView.getScrollX());
      //   } else {
      //     result.success(null);
      //   }
      //   break;
      // case getScrollY:
      //   if (webView != null) {
      //     result.success(webView.getScrollY());
      //   } else {
      //     result.success(null);
      //   }
      //   break;
      // case getCertificate:
      //   if (webView != null) {
      //     result.success(SslCertificateExt.toMap(webView.getCertificate()));
      //   } else {
      //     result.success(null);
      //   }
      //   break;
      // case clearHistory:
      //   if (webView != null) {
      //     webView.clearHistory();
      //   }
      //   result.success(true);
      //   break;
      // case addUserScript:
      //   if (webView != null && webView.getUserContentController() != null) {
      //     Map<String, Object> userScriptMap = (Map<String, Object>) call.argument("userScript");
      //     UserScript userScript = UserScript.fromMap(userScriptMap);
      //     result.success(webView.getUserContentController().addUserOnlyScript(userScript));
      //   } else {
      //     result.success(false);
      //   }
      //   break;
      // case removeUserScript:
      //   if (webView != null && webView.getUserContentController() != null) {
      //     Integer index = (Integer) call.argument("index");
      //     Map<String, Object> userScriptMap = (Map<String, Object>) call.argument("userScript");
      //     UserScript userScript = UserScript.fromMap(userScriptMap);
      //     result.success(webView.getUserContentController().removeUserOnlyScriptAt(index, userScript.getInjectionTime()));
      //   } else {
      //     result.success(false);
      //   }
      //   break;
      // case removeUserScriptsByGroupName:
      //   if (webView != null && webView.getUserContentController() != null) {
      //     String groupName = call.argument("groupName");
      //     webView.getUserContentController().removeUserOnlyScriptsByGroupName(groupName);
      //   }
      //   result.success(true);
      //   break;
      // case removeAllUserScripts:
      //   if (webView != null && webView.getUserContentController() != null) {
      //     webView.getUserContentController().removeAllUserOnlyScripts();
      //   }
      //   result.success(true);
      //   break;
      // case callAsyncJavaScript:
      //   if (webView != null && Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
      //     String functionBody = call.argument("functionBody");
      //     Map<String, Object> functionArguments = (Map<String, Object>) call.argument("arguments");
      //     Map<String, Object> contentWorldMap = (Map<String, Object>) call.argument("contentWorld");
      //     ContentWorld contentWorld = ContentWorld.fromMap(contentWorldMap);
      //     webView.callAsyncJavaScript(functionBody, functionArguments, contentWorld, new ValueCallback<String>() {
      //       @Override
      //       public void onReceiveValue(String value) {
      //         result.success(value);
      //       }
      //     });
      //   } else {
      //     result.success(null);
      //   }
      //   break;
      // case isSecureContext:
      //   if (webView != null && Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
      //     webView.isSecureContext(new ValueCallback<Boolean>() {
      //       @Override
      //       public void onReceiveValue(Boolean value) {
      //         result.success(value);
      //       }
      //     });
      //   } else {
      //     result.success(false);
      //   }
      //   break;
      // case createWebMessageChannel:
      //   if (webView != null) {
      //     if (webView instanceof InAppWebView && WebViewFeature.isFeatureSupported(WebViewFeature.CREATE_WEB_MESSAGE_CHANNEL)) {
      //       result.success(webView.createCompatWebMessageChannel().toMap());
      //     } else {
      //       result.success(null);
      //     }
      //   } else {
      //     result.success(null);
      //   }
      //   break;
      // case postWebMessage:
      //   if (webView != null && WebViewFeature.isFeatureSupported(WebViewFeature.POST_WEB_MESSAGE)) {
      //     WebMessageCompatExt message = WebMessageCompatExt.fromMap((Map<String, Object>) call.argument("message"));
      //     String targetOrigin = call.argument("targetOrigin");
      //     List<WebMessagePortCompat> compatPorts = new ArrayList<>();
      //     List<WebMessagePortCompatExt> portsExt = message.getPorts();
      //     if (portsExt != null) {
      //       for (WebMessagePortCompatExt portExt : portsExt) {
      //         WebMessageChannel webMessageChannel = webView.getWebMessageChannels().get(portExt.getWebMessageChannelId());
      //         if (webMessageChannel != null) {
      //           if (webView instanceof InAppWebView) {
      //             compatPorts.add(webMessageChannel.compatPorts.get(portExt.getIndex()));
      //           }
      //         }
      //       }
      //     }
      //     Object data = message.getData();
      //     if (webView instanceof InAppWebView) {
      //       try {
      //         if (WebViewFeature.isFeatureSupported(WebViewFeature.WEB_MESSAGE_ARRAY_BUFFER) && data != null &&
      //                 message.getType() == WebMessageCompat.TYPE_ARRAY_BUFFER) {
      //           WebViewCompat.postWebMessage((WebView) webView,
      //                   new WebMessageCompat((byte[]) data, compatPorts.toArray(new WebMessagePortCompat[0])),
      //                   Uri.parse(targetOrigin));
      //         } else {
      //           WebViewCompat.postWebMessage((WebView) webView,
      //                   new WebMessageCompat(data != null ? data.toString() : null, compatPorts.toArray(new WebMessagePortCompat[0])),
      //                   Uri.parse(targetOrigin));
      //         }
      //         result.success(true);
      //       } catch (Exception e) {
      //         result.error(LOG_TAG, e.getMessage(), null);
      //       }
      //     }
      //   } else {
      //     result.success(true);
      //   }
      //   break;
      // case addWebMessageListener:
      //   if (webView != null) {
      //     Map<String, Object> webMessageListenerMap = (Map<String, Object>) call.argument("webMessageListener");
      //     WebMessageListener webMessageListener = WebMessageListener.fromMap(webView, webView.getPlugin().messenger, webMessageListenerMap);
      //     if (webView instanceof InAppWebView && WebViewFeature.isFeatureSupported(WebViewFeature.WEB_MESSAGE_LISTENER)) {
      //       try {
      //         webView.addWebMessageListener(webMessageListener);
      //         result.success(true);
      //       } catch (Exception e) {
      //         result.error(LOG_TAG, e.getMessage(), null);
      //       }
      //     } else {
      //       result.success(true);
      //     }
      //   } else {
      //     result.success(true);
      //   }
      //   break;
      // case canScrollVertically:
      //   if (webView != null) {
      //     result.success(webView.canScrollVertically());
      //   } else {
      //     result.success(false);
      //   }
      //   break;
      // case canScrollHorizontally:
      //   if (webView != null) {
      //     result.success(webView.canScrollHorizontally());
      //   } else {
      //     result.success(false);
      //   }
      //   break;
      // case isInFullscreen:
      //   if (webView != null) {
      //     result.success(webView.isInFullscreen());
      //   } else {
      //     result.success(false);
      //   }
      //   break;
      // case clearFormData:
      //   if (webView != null) {
      //     webView.clearFormData();
      //   }
      //   result.success(true);
    }
  }
}