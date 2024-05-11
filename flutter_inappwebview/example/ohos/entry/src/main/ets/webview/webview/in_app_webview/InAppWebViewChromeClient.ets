import { Any, Log } from '@ohos/flutter_ohos';
import web_webview from '@ohos.web.webview';
import cameraPicker from '@ohos.multimedia.cameraPicker';
import picker from '@ohos.file.picker';
import uri from '@ohos.uri'
import InAppWebViewFlutterPlugin from '../../InAppWebViewFlutterPlugin';
import DownloadStartRequest from '../../types/DownloadStartRequest';
import URLUtil from '../../types/URLUtil';
import InAppWebView from './InAppWebView';
import WebResourceResponseExt from '../../types/WebResourceResponseExt';
import CustomSchemeResponse from '../../types/CustomSchemeResponse';
import WebResourceRequestExt from '../../types/WebResourceRequestExt';
import URLRequest from '../../types/URLRequest';
import NavigationAction from '../../types/NavigationAction';
import { NavigationActionPolicy } from '../../types/NavigationActionPolicy';
import URLCredential from '../../types/URLCredential';
import JavaScriptBridgeJS from '../../plugin_scripts_js/JavaScriptBridgeJS';
import { image } from '@kit.ImageKit';
import { InAppBrowserDelegate } from '../../in_app_browser/InAppBrowserDelegate';
import WebResourceErrorExt from '../../types/WebResourceErrorExt';
import Util from '../../Util';
import {
  GeolocationPermissionsShowPromptCallback,
  JsAlertCallback,
  JsBeforeUnloadCallback,
  JsConfirmCallback,
  JsPromptCallback,
  PermissionRequestCallback
} from '../WebViewChannelDelegate';
import JsAlertResponse from '../../types/JsAlertResponse';
import JsConfirmResponse from '../../types/JsConfirmResponse';
import JsPromptResponse from '../../types/JsPromptResponse';
import { ohosPromptDialogBuilder } from './OhosPromptDialog';
import { promptAction } from '@kit.ArkUI';
import JsBeforeUnloadResponse from '../../types/JsBeforeUnloadResponse';
import { camera } from '@kit.CameraKit';
import { BusinessError } from '@kit.BasicServicesKit';
import MimeTypes from '../../MimeTypes';
import PermissionResponse from '../../types/PermissionResponse';
import GeolocationPermissionShowPromptResponse from '../../types/GeolocationPermissionShowPromptResponse';

const TAG = "InAppWebViewChromeClient";

// 参考文档 所有事件 https://docs.openharmony.cn/pages/v4.1/zh-cn/application-dev/reference/apis-arkweb/ts-basic-components-web.md#onalert
export default class InAppWebViewChromeClient {
  private static previousAuthRequestFailureCount = 0;
  private static credentialsProposed: Array<URLCredential> | null = null;
  private plugin: InAppWebViewFlutterPlugin;
  private inAppWebView: InAppWebView;
  private inAppBrowserDelegate: InAppBrowserDelegate | null = null;

  constructor(plugin: InAppWebViewFlutterPlugin, inAppWebView: InAppWebView) {
    this.plugin = plugin;
    this.inAppWebView = inAppWebView;
  }

  onAlert = (event: Any) => {
    Log.d(TAG, "onAlert=" + JSON.stringify(event))
    if (this.inAppWebView != null && this.inAppWebView.channelDelegate != null) {
      this.inAppWebView.channelDelegate.onJsAlert(event.url, event.message, null, new InnerJsAlertCallback(event.result, event.message));
      return true;
    }
    return false;
  }
  onBeforeUnload = (event: Any) => {
    Log.d(TAG, "onBeforeUnload=" + JSON.stringify(event))
    if (this.inAppWebView != null && this.inAppWebView.channelDelegate != null) {
      this.inAppWebView.channelDelegate.onJsBeforeUnload(event.url, event.message, new InnerJsBeforeUnloadCallback(event.result, event.message));
      return true;
    }
    return false;
  }
  onConfirm = (event: Any) => {
    Log.d(TAG, "onConfirm=" + JSON.stringify(event))
    if (this.inAppWebView != null && this.inAppWebView.channelDelegate != null) {
      this.inAppWebView.channelDelegate.onJsConfirm(event.url, event.message, null, new InnerJsConfirmCallback(event.result, event.message));
      return true;
    }
    return false;
  }
  onPrompt = (event: Any, uiObject: Any) => {
    Log.d(TAG, "onPrompt=" + JSON.stringify(event))
    // TODO
    // 等API12适配的时候放开
    // if (this.inAppWebView != null && this.inAppWebView.channelDelegate != null) {
    //   this.inAppWebView.channelDelegate.onJsPrompt(event.url, event.message, event.value, null, new InnerJsPromptCallback(event.result, event.message, event.value, uiObject));
    //   return true;
    // }
    return false;
  }
  onConsole = (event: Any) => {
    Log.d(TAG, "onConsole=" + JSON.stringify(event))
    if (this.inAppWebView != null && this.inAppWebView.channelDelegate != null) {
      this.inAppWebView.channelDelegate.onConsoleMessage(event.message.getMessage(), event.message.getMessageLevel());
      return true;
    }
    return false;
  }
  onDownloadStart = (event: Any) => { //对应安卓setDownloadListener
    Log.d(TAG, "onDownloadStart=" + JSON.stringify(event))
    if (this.inAppWebView.customSettings.useOnDownloadStart) {
      let downloadStartRequest = new DownloadStartRequest(
        event.url,
        event.userAgent,
        event.contentDisposition,
        event.mimetype,
        event.contentLength,
        URLUtil.guessFileName(event.url, event.contentDisposition, event.mimetype),
        null
      );
      this.inAppWebView.channelDelegate.onDownloadStartRequest(downloadStartRequest)
    }
  }
  onErrorReceive = (event: Any) => {
    Log.d(TAG, "onErrorReceive=" + JSON.stringify(event))
    let request: WebResourceRequest = event.request;
    let error: WebResourceError = event.error;
    if (request.isMainFrame()) {
      if (this.inAppWebView.customSettings.disableDefaultErrorPage) {
        this.inAppWebView.stopLoading();
        this.inAppWebView.controller.loadUrl("about:blank");
      }

      this.inAppWebView.isLoading = false;
      InAppWebViewChromeClient.previousAuthRequestFailureCount = 0;
      InAppWebViewChromeClient.credentialsProposed = null;

      if (this.inAppBrowserDelegate != null) {
        let type = error.getErrorCode();
        let description = error.getErrorInfo();
        this.inAppBrowserDelegate.didFailNavigation(request.getRequestUrl(), type, description);
      }
    }
    if (this.inAppWebView.channelDelegate != null) {
      this.inAppWebView.channelDelegate.onReceivedError(
        WebResourceRequestExt.fromWebResourceRequest(request),
        WebResourceErrorExt.fromWebResourceError(error));
    }
  }
  onHttpErrorReceive = (event: Any) => {
    Log.d(TAG, "onHttpErrorReceive=" + JSON.stringify(event))
    if (this.inAppWebView.channelDelegate != null) {
      this.inAppWebView.channelDelegate.onReceivedHttpError(
        WebResourceRequestExt.fromWebResourceRequest(event.request),
        WebResourceResponseExt.fromWebResourceResponse(event.response));
    }
  }
  onPageBegin = (event: Any) => {
    Log.d(TAG, "onPageBegin=" + JSON.stringify(event))
    this.inAppWebView.isLoading = true;
    this.inAppWebView.disposeWebMessageChannels();
    this.inAppWebView.userContentController.resetContentWorlds();
    this.loadCustomJavaScriptOnPageStarted(this.inAppWebView);

    if (this.inAppBrowserDelegate != null) {
      this.inAppBrowserDelegate.didStartNavigation(event.url);
    }

    if (this.inAppWebView.channelDelegate != null) {
      this.inAppWebView.channelDelegate.onLoadStart(event.url);
    }
  }
  onPageEnd = (event: Any) => {
    Log.d(TAG, "onPageBegin=" + JSON.stringify(event))
    this.inAppWebView.isLoading = false;
    this.loadCustomJavaScriptOnPageFinished(this.inAppWebView);
    InAppWebViewChromeClient.previousAuthRequestFailureCount = 0;
    InAppWebViewChromeClient.credentialsProposed = null;

    if (this.inAppBrowserDelegate != null) {
      this.inAppBrowserDelegate.didFinishNavigation(event.url);
    }

    web_webview.WebCookieManager.saveCookieAsync()

    let js = JavaScriptBridgeJS.PLATFORM_READY_JS_SOURCE;
    this.inAppWebView.controller.runJavaScriptExt(js)

    if (this.inAppWebView.channelDelegate != null) {
      this.inAppWebView.channelDelegate.onLoadStop(event.url);
    }
  }
  onProgressChange = (event: Any) => {
    Log.d(TAG, "onProgressChange=" + JSON.stringify(event))
    if (this.inAppBrowserDelegate != null) {
      this.inAppBrowserDelegate.didChangeProgress(event.newProgress);
    }

    this.loadCustomJavaScriptOnPageStarted(this.inAppWebView);

    if (this.inAppWebView.channelDelegate != null) {
      this.inAppWebView.channelDelegate.onProgressChanged(event.newProgress);
    }
  }
  onTitleReceive = (event: Any) => {
    Log.d(TAG, "onTitleReceive=" + JSON.stringify(event))
    if (this.inAppBrowserDelegate != null) {
      this.inAppBrowserDelegate.didChangeTitle(event.title);
    }
    if (this.inAppWebView.channelDelegate != null) {
      this.inAppWebView.channelDelegate.onTitleChanged(event.title);
    }
  }
  onRefreshAccessedHistory = (event: Any) => {
    Log.d(TAG, "onRefreshAccessedHistory=" + JSON.stringify(event))
    if (this.inAppBrowserDelegate != null) {
      this.inAppBrowserDelegate.didUpdateVisitedHistory(event.url);
    }
    if (this.inAppWebView.channelDelegate != null) {
      this.inAppWebView.channelDelegate.onUpdateVisitedHistory(event.url, event.isRefreshed);
    }
  }
  onRenderExited = (event: Any) => {
    Log.d(TAG, "onRenderExited=" + JSON.stringify(event))
    if (this.inAppWebView.customSettings.useOnRenderProcessGone && this.inAppWebView.channelDelegate != null) {
      let didCrash = event.renderExitReason == RenderExitReason.ProcessCrashed;
      this.inAppWebView.channelDelegate.onRenderProcessGone(didCrash, event.renderExitReason);
    }
  }
  onShowFileSelector = (event: Any) => {
    Log.d(TAG, "onShowFileSelector=" + JSON.stringify(event))
    Log.d(TAG, "onShowFileSelector=" + JSON.stringify(event.fileSelector))
    let acceptTypes: Array<string> = event.fileSelector.getAcceptType();
    let allowMultiple = event.fileSelector.getMode() == FileSelectorMode.FileOpenMultipleMode;
    let captureEnabled: boolean = event.fileSelector.isCapture();
    let images = this.acceptsImages(acceptTypes);
    let video = this.acceptsVideo(acceptTypes);
    if (captureEnabled) {
      if (!this.needsCameraPermission()) {
        if (images || video) {
          let pickerProfile: cameraPicker.PickerProfile = {
            cameraPosition: camera.CameraPosition.CAMERA_POSITION_BACK
          };
          cameraPicker.pick(this.inAppWebView.context, images ? [cameraPicker.PickerMediaType.PHOTO] : [cameraPicker.PickerMediaType.VIDEO], pickerProfile)
            .then(result => {
              event.result.handleFileList([result.resultUri]);
            }).catch((err: BusinessError) => {
            event.result.handleFileList([]);
            Log.e(TAG, `the pick call failed. error code: ${err.code}`);
          });
          return true;
        }
      }
    }

    //缺少从系统直接选择全部，这里做了一个弹窗选择 这里OHOS存在一个bug。
    ActionSheet.show({
      title: '请选择',
      message: '',
      autoCancel: true,
      isModal: true,
      cancel: () => {
        Log.d(TAG, 'actionSheet canceled')
        event.result.handleFileList([]);
      },
      alignment: DialogAlignment.Center,
      offset: {
        dx: 0, dy: 100
      },
      sheets: [
        {
          title: '相册',
          action: () => {
            Log.d(TAG, 'apples')
            let photoSelectOptions = new picker.PhotoSelectOptions();
            photoSelectOptions.MIMEType = (images && video) ? picker.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE :
              (images ? picker.PhotoViewMIMETypes.IMAGE_TYPE : picker.PhotoViewMIMETypes.VIDEO_TYPE);
            photoSelectOptions.maxSelectNumber = allowMultiple ? 100000 : 1
            let photoPicker = new picker.PhotoViewPicker();
            photoPicker.select(photoSelectOptions).then((photoSelectResult: picker.PhotoSelectResult) => {
              event.result.handleFileList(photoSelectResult.photoUris);
              Log.d(TAG, 'PhotoViewPicker.select successfully, photoSelectResult uri: ' + JSON.stringify(photoSelectResult));
            }).catch((err: BusinessError) => {
              event.result.handleFileList([]);
              Log.e(TAG, 'PhotoViewPicker.select failed with err: ' + JSON.stringify(err));
            });
          }
        },
        {
          title: '档案',
          action: () => {
            let documentPicker = new picker.DocumentViewPicker();
            let documentSelectOptions = new picker.DocumentSelectOptions();
            documentSelectOptions.maxSelectNumber = allowMultiple ? 100000 : 1
            documentSelectOptions.fileSuffixFilters = acceptTypes;
            documentPicker.select(documentSelectOptions).then((documentSelectResult) => {
              Log.d(TAG, 'documentViewPicker.select to file succeed and uri is:' + JSON.stringify(documentSelectResult));
              event.result.handleFileList(documentSelectResult);
            }).catch((err: BusinessError) => {
              event.result.handleFileList([]);
              Log.d(TAG, `Invoke documentViewPicker.select failed, code is ${err.code}, message is ${err.message}`);
            })
          }
        },
        {
          title: '音频',
          action: () => {
            let audioSelectOptions = new picker.AudioSelectOptions();
            let audioPicker = new picker.AudioViewPicker();
            audioPicker.select(audioSelectOptions).then((audioSelectResult: Array<string>) => {
              event.result.handleFileList(audioSelectResult);
              Log.d(TAG, 'AudioViewPicker.select successfully, audioSelectResult uri: ' + JSON.stringify(audioSelectResult));
            }).catch((err: BusinessError) => {
              Log.d(TAG, 'AudioViewPicker.select failed with err: ' + JSON.stringify(err));
              event.result.handleFileList([]);
            });
          }
        }
      ]
    })
    return true;
  }
  onResourceLoad = (event: Any) => {
    // TODO 没有找到安卓对于方法
    Log.d(TAG, "onResourceLoad=" + JSON.stringify(event))
  }
  onScaleChange = (event: Any) => {
    Log.d(TAG, "onScaleChange=" + JSON.stringify(event))
    this.inAppWebView.zoomScale = event.newScale / Util.getPixelDensity();

    if (this.inAppWebView.channelDelegate != null) {
      this.inAppWebView.channelDelegate.onZoomScaleChanged(event.oldScale, event.newScale);
    }
  }
  onInterceptRequest = async (event: Any) => { //对应安卓shouldInterceptRequest
    let request = WebResourceRequestExt.fromWebResourceRequest(event.request);
    Log.d(TAG, "onInterceptRequest=" + JSON.stringify(event))
    if (this.inAppWebView.webViewAssetLoaderExt != null && this.inAppWebView.webViewAssetLoaderExt.loader != null) {
      try {
        let url = new uri.URI(request.getUrl());
        let webResourceResponse = await this.inAppWebView.webViewAssetLoaderExt.loader.shouldInterceptRequest(url);
        if (webResourceResponse != null) {
          return webResourceResponse;
        }
      } catch (e) {
        Log.e(TAG, "", e);
      }
    }
    if (this.inAppWebView.customSettings.useShouldInterceptRequest) {
      let response: WebResourceResponseExt | null = null;
      if (this.inAppWebView.channelDelegate != null) {
        try {
          response = await this.inAppWebView.channelDelegate.shouldInterceptRequest(request);
        } catch (e) {
          Log.e(TAG, "", e);
          return null;
        }
      }
      if (response != null) {
        let webResourceResponse = new WebResourceResponse();
        webResourceResponse.setResponseData(response.getData())
        webResourceResponse.setResponseMimeType(response.getContentType())
        webResourceResponse.setResponseEncoding(response.getContentEncoding())
        webResourceResponse.setResponseCode(response.getStatusCode())
        webResourceResponse.setReasonMessage(response.getReasonPhrase())
        webResourceResponse.setResponseHeader(response.getHeaderArray())
        return new WebResourceResponse();
      }
      return null;
    }

    let url: string = request.getUrl();
    let scheme = url.split(":")[0].toLowerCase();
    try {
      scheme = new uri.URI(url).scheme;
    } catch (e) {

    }

    if (this.inAppWebView.customSettings.resourceCustomSchemes != null && this.inAppWebView.customSettings.resourceCustomSchemes.indexOf(scheme) > -1) {
      let customSchemeResponse: CustomSchemeResponse | null = null;
      if (this.inAppWebView.channelDelegate != null) {
        try {
          customSchemeResponse = await this.inAppWebView.channelDelegate.onLoadResourceWithCustomScheme(request);
        } catch (e) {
          Log.e(TAG, "", e);
          return null;
        }
      }

      if (customSchemeResponse != null) {
        let response: WebResourceResponse | null = null;
        try {
          response = this.inAppWebView.contentBlockerHandler.checkUrl(this.inAppWebView, request, customSchemeResponse.getContentType());
        } catch (e) {
          Log.e(TAG, "", e);
        }
        if (response != null)
          return response;
        let resourceResponse = new WebResourceResponse();
        resourceResponse.setResponseMimeType(customSchemeResponse.getContentType());
        resourceResponse.setResponseEncoding(customSchemeResponse.getContentEncoding());
        resourceResponse.setResponseData(customSchemeResponse.getData())
        return resourceResponse;
      }
    }

    let response: WebResourceResponse | null = null;
    if (this.inAppWebView.contentBlockerHandler.getRuleList().length > 0) {
      try {
        response = this.inAppWebView.contentBlockerHandler.checkUrl(this.inAppWebView, request);
      } catch (e) {
        Log.e(TAG, "", e);
      }
    }
    Log.d(TAG, "onInterceptRequestend= end")
    return response;
  }
  onHttpAuthRequest = (event: Any) => {
    // TODO
    Log.d(TAG, "onHttpAuthRequest=" + JSON.stringify(event))
    return true;
  }
  onSslErrorEventReceive = (event: Any) => {
    // TODO
    Log.d(TAG, "onSslErrorEventReceive=" + JSON.stringify(event))
  }
  onClientAuthenticationRequest = (event: Any) => {
    // TODO
    Log.d(TAG, "onClientAuthenticationRequest=" + JSON.stringify(event))
  }
  onPermissionRequest = (event: Any) => {
    if (this.inAppWebView != null && this.inAppWebView.channelDelegate != null) {
      this.inAppWebView.channelDelegate.onPermissionRequest(event.request.getOrigin(), event.request.getAccessibleResource(), null,
        new InnerPermissionRequestCallback(event.request));
    } else {
      event.request.deny();
    }
    Log.d(TAG, "onPermissionRequest=" + JSON.stringify(event))
  }
  onContextMenuShow = (event: Any) => {
    // TODO
    Log.d(TAG, "onContextMenuShow=" + JSON.stringify(event))
    return false;
  }
  onContextMenuHide = (callback: OnContextMenuHideCallback) => {
    // TODO
    Log.d(TAG, "onContextMenuHide=")
  }
  onScroll = (event: Any) => {
    Log.d(TAG, "onScroll=" + JSON.stringify(event))
    if (this.inAppWebView.channelDelegate != null) this.inAppWebView.channelDelegate.onScrollChanged(event.xOffset, event.yOffset);
  }
  onGeolocationShow = (event: Any) => {
    Log.d(TAG, "onGeolocationShow=" + JSON.stringify(event))
    if (this.inAppWebView != null && this.inAppWebView.channelDelegate != null) {
      this.inAppWebView.channelDelegate.onGeolocationPermissionsShowPrompt(event.origin, new InnerGeolocationPermissionsShowPromptCallback(event.origin, event.geolocation));
    } else {
      event.geolocation.invoke(event.origin, false, false);
    }
  }
  onGeolocationHide = (event: Any) => {
    Log.d(TAG, "onGeolocationHide=" + JSON.stringify(event))
    if (this.inAppWebView != null && this.inAppWebView.channelDelegate != null) {
      this.inAppWebView.channelDelegate.onGeolocationPermissionsHidePrompt();
    }
  }
  onFullScreenEnter = (event: Any) => {
    Log.d(TAG, "onFullScreenEnter=" + JSON.stringify(event))
  }
  onFullScreenExit = (event: Any) => {
    Log.d(TAG, "onFullScreenExit=" + JSON.stringify(event))
  }
  onWindowNew = (event: Any) => {
    Log.d(TAG, "onWindowNew=" + JSON.stringify(event))
  }
  onWindowExit = (event: Any) => {
    Log.d(TAG, "onWindowExit=" + JSON.stringify(event))
  }
  onSearchResultReceive = (event: Any) => {
    Log.d(TAG, "onSearchResultReceive=" + JSON.stringify(event))
  }
  onDataResubmitted = (event: Any) => {
    Log.d(TAG, "onDataResubmitted=" + JSON.stringify(event))
  }
  onPageVisible = (event: Any) => {
    Log.d(TAG, "onPageVisible=" + JSON.stringify(event))
  }
  onInterceptKeyEvent = (event: Any) => {
    Log.d(TAG, "onInterceptKeyEvent=" + JSON.stringify(event))
    return false;
  }
  onTouchIconUrlReceived = (event: Any) => {
    Log.d(TAG, "onTouchIconUrlReceived=" + JSON.stringify(event))
    if (this.inAppWebView.channelDelegate != null) {
      this.inAppWebView.channelDelegate.onReceivedTouchIconUrl(event.url, event.precomposed);
    }
  }
  onFaviconReceived = async (event: Any) => {
    Log.d(TAG, "onFaviconReceived=" + JSON.stringify(event))
    let options: image.PackingOption = {
      format: 'image/png',
      quality: 100
    };
    let packer = image.createImagePacker();
    let imageBuffer = await packer.packing(event.favicon, options);
    if (this.inAppWebView.channelDelegate != null) {
      this.inAppWebView.channelDelegate.onReceivedIcon(imageBuffer);
    }
    await event.favicon.release()
    await packer.release()
  }
  onAudioStateChanged = (event: Any) => {
    Log.d(TAG, "onAudioStateChanged=" + JSON.stringify(event))
  }
  onFirstContentfulPaint = (event: Any) => {
    Log.d(TAG, "onFirstContentfulPaint=" + JSON.stringify(event))
  }
  onLoadIntercept = async (event: Any) => { //对应安卓 shouldOverrideUrlLoading
    Log.d(TAG, "onLoadIntercept=" + event.data.getRequestUrl())
    if (this.inAppWebView.customSettings.useShouldOverrideUrlLoading) {
      let request = WebResourceRequestExt.fromWebResourceRequest(event.data);
      return await this.onShouldOverrideUrlLoading(
        this.inAppWebView,
        request.getUrl(),
        request.getMethod(),
        request.getHeaders(),
        request.getForMainFrame(),
        request.isHasGesture(),
        request.getRedirect());
    }
    Log.d(TAG, "onLoadInterceptEnd=" + event.data.getRequestUrl())
    return false;
  }
  onRequestSelected = (event: Any) => {
    Log.d(TAG, "onRequestSelected=" + JSON.stringify(event))
  }
  onScreenCaptureRequest = (event: Any) => {
    Log.d(TAG, "onScreenCaptureRequest=" + JSON.stringify(event))
  }
  onOverScroll = (event: Any) => {
    Log.d(TAG, "onOverScroll=" + JSON.stringify(event))
  }
  onNavigationEntryCommitted = (callback: OnNavigationEntryCommittedCallback) => {
    Log.d(TAG, "onNavigationEntryCommitted=")
  }
  onSafeBrowsingCheckResult = (callback: OnSafeBrowsingCheckResultCallback) => {
    Log.d(TAG, "onSafeBrowsingCheckResult=")
  }
  onNativeEmbedLifecycleChange = (callback: NativeEmbedDataInfo) => {
    Log.d(TAG, "onNativeEmbedLifecycleChange=")
  }
  onNativeEmbedGestureEvent = (callback: NativeEmbedTouchInfo) => {
    Log.d(TAG, "onNativeEmbedGestureEvent=")
  }

  private async onShouldOverrideUrlLoading(webView: InAppWebView, url: string, method: string, headers: Map<string, string>,
                                           isForMainFrame: boolean, hasGesture: boolean, isRedirect: boolean) {
    let request = new URLRequest(url, method, null, headers);
    let navigationAction = new NavigationAction(request, isForMainFrame, hasGesture, isRedirect);

    let result: NavigationActionPolicy | null = NavigationActionPolicy.ALLOW
    if (webView.channelDelegate != null) {
      result = await webView.channelDelegate.shouldOverrideUrlLoading(navigationAction);
    } else {
      result = NavigationActionPolicy.ALLOW
    }
    Log.d(TAG, "onLoadInterceptEnd=" + url)
    return result == NavigationActionPolicy.CANCEL
  }

  private loadCustomJavaScriptOnPageStarted(webView: InAppWebView) {
    let source = webView.userContentController.generateWrappedCodeForDocumentStart();
    webView.controller.runJavaScriptExt(source)
  }

  private loadCustomJavaScriptOnPageFinished(webView: InAppWebView) {
    let source = webView.userContentController.generateWrappedCodeForDocumentEnd();
    webView.controller.runJavaScriptExt(source)
  }

  private needsCameraPermission(): boolean {
    return false
  }

  private acceptsVideo(types: Array<string>): boolean {
    let mimeTypes = this.getAcceptedMimeType(types);
    return this.acceptsAny(mimeTypes) || this.arrayContainsString(mimeTypes, "video");
  }

  private acceptsImages(types: Array<string>): boolean {
    let mimeTypes = this.getAcceptedMimeType(types);
    return this.acceptsAny(mimeTypes) || this.arrayContainsString(mimeTypes, "image");
  }

  private getAcceptedMimeType(types: Array<string>): Array<string> {
    if (this.isArrayEmpty(types)) {
      return ["*/*"];
    }
    let mimeTypes = new Array<string>();
    for (let i = 0; i < types.length; i++) {
      let t = types[i];
      // convert file extensions to mime types
      if (t.indexOf(".") > -1) {
        let mimeType = MimeTypes.getMimeTypeFromExtension(t.replace(".", ""));
        mimeTypes[i] = mimeType;
      } else {
        mimeTypes[i] = t;
      }
    }
    return mimeTypes;
  }

  private acceptsAny(types: Array<string>) {
    if (this.isArrayEmpty(types)) {
      return true;
    }
    for (let type of types) {
      if (type == "*/*") {
        return true;
      }
    }
    return false;
  }

  private arrayContainsString(array: Array<string>, pattern: string): boolean {
    for (let content of array) {
      if (content != null && content.indexOf(pattern) > -1) {
        return true;
      }
    }
    return false;
  }

  private isArrayEmpty(arr: Array<string>): boolean {
    // when our array returned from getAcceptTypes() has no values set from the webview
    // i.e. <input type="file" />, without any "accept" attr
    // will be an array with one empty string element, afaik
    return arr.length == 0 || (arr.length == 1 && arr[0].length == 0);
  }
}

class InnerJsAlertCallback extends JsAlertCallback {
  private result: JsResult;
  private message: string;

  constructor(result: JsResult, message: string) {
    super();
    this.result = result;
    this.message = message;
  }

  nonNullSuccess(response: JsAlertResponse): boolean {
    if (response.isHandledByClient()) {
      let action = response.getAction();
      action = action != null ? action : 1;
      switch (action) {
        case 0:
          this.result.handleConfirm();
          break;
        case 1:
        default:
          this.result.handleCancel();
      }
      return false;
    }
    return true;
  }

  defaultBehaviour(response: JsAlertResponse | null): void {
    let responseMessage: string | null = null;
    let confirmButtonTitle: string | null = null;
    if (response != null) {
      responseMessage = response.getMessage();
      confirmButtonTitle = response.getConfirmButtonTitle();
    }
    this.createAlertDialog(this.message, this.result, responseMessage, confirmButtonTitle);
  }

  error(errorCode: string, errorMessage: string, errorDetails: Any): void {
    Log.e(TAG, errorCode + ", " + ((errorMessage != null) ? errorMessage : ""));
    this.result.handleCancel();
  }

  private createAlertDialog(message: string, result: JsResult, responseMessage: string | null, confirmButtonTitle: string | null) {
    let alertMessage = (responseMessage != null && responseMessage.length > 0) ? responseMessage : message;
    AlertDialog.show(
      {
        message: alertMessage,
        autoCancel: true,
        alignment: DialogAlignment.Center,
        confirm: {
          value: confirmButtonTitle != null ? confirmButtonTitle : "确定",
          action: () => {
            result.handleConfirm()
          }
        },
        cancel: () => {
          result.handleCancel()
        }
      }
    )
  }
}

class InnerJsConfirmCallback extends JsConfirmCallback {
  private result: JsResult;
  private message: string;

  constructor(result: JsResult, message: string) {
    super();
    this.result = result;
    this.message = message;
  }

  nonNullSuccess(response: JsConfirmResponse): boolean {
    if (response.isHandledByClient()) {
      let action = response.getAction();
      action = action != null ? action : 1;
      switch (action) {
        case 0:
          this.result.handleConfirm();
          break;
        case 1:
        default:
          this.result.handleCancel();
      }
      return false;
    }
    return true;
  }

  defaultBehaviour(response: JsConfirmResponse | null): void {
    let responseMessage: string | null = null;
    let confirmButtonTitle: string | null = null;
    let cancelButtonTitle: string | null = null;
    if (response != null) {
      responseMessage = response.getMessage();
      confirmButtonTitle = response.getConfirmButtonTitle();
      cancelButtonTitle = response.getCancelButtonTitle();
    }
    this.createConfirmDialog(this.message, this.result, responseMessage, confirmButtonTitle, cancelButtonTitle);
  }

  error(errorCode: string, errorMessage: string, errorDetails: Any): void {
    Log.e(TAG, errorCode + ", " + ((errorMessage != null) ? errorMessage : ""));
    this.result.handleCancel();
  }

  private createConfirmDialog(message: string, result: JsResult, responseMessage: string | null,
                              confirmButtonTitle: string | null, cancelButtonTitle: string | null) {
    let alertMessage = (responseMessage != null && responseMessage.length > 0) ? responseMessage : message;
    AlertDialog.show(
      {
        message: alertMessage,
        autoCancel: true,
        alignment: DialogAlignment.Center,
        primaryButton: {
          value: cancelButtonTitle != null ? cancelButtonTitle : "取消",
          action: () => {
            result.handleCancel()
          }
        },
        secondaryButton: {
          defaultFocus: true,
          value: confirmButtonTitle != null ? confirmButtonTitle : "确定",
          action: () => {
            result.handleConfirm()
          }
        },
        cancel: () => {
          result.handleCancel()
        }
      }
    )
  }
}

class InnerJsPromptCallback extends JsPromptCallback {
  private result: JsResult;
  private message: string;
  private defaultValue: string;
  private uiObject: Any;

  constructor(result: JsResult, message: string, defaultValue: string, uiObject: Any) {
    super();
    this.result = result;
    this.message = message;
    this.defaultValue = defaultValue;
    this.uiObject = uiObject;
  }

  nonNullSuccess(response: JsPromptResponse): boolean {
    if (response.isHandledByClient()) {
      let action = response.getAction();
      action = action != null ? action : 1;
      switch (action) {
        case 0:
          this.result.handlePromptConfirm(response.getValue());
          break;
        case 1:
        default:
          this.result.handleCancel();
      }
      return false;
    }
    return true;
  }

  defaultBehaviour(response: JsPromptResponse | null): void {
    let responseMessage: string | null = null;
    let responseDefaultValue: string | null = null;
    let value: string | null = null;
    let confirmButtonTitle: string | null = null;
    let cancelButtonTitle: string | null = null;
    if (response != null) {
      responseMessage = response.getMessage();
      responseDefaultValue = response.getDefaultValue();
      value = response.getValue();
      confirmButtonTitle = response.getConfirmButtonTitle();
      cancelButtonTitle = response.getCancelButtonTitle();
    }
    this.createPromptDialog(this.message, this.defaultValue, this.result, responseMessage, responseDefaultValue, value, cancelButtonTitle, confirmButtonTitle);
  }

  error(errorCode: string, errorMessage: string, errorDetails: Any): void {
    Log.e(TAG, errorCode + ", " + ((errorMessage != null) ? errorMessage : ""));
    this.result.handleCancel();
  }

  private createPromptDialog(message: string, defaultValue: string, result: JsResult, responseMessage: string | null,
                             responseDefaultValue: string | null, value: string | null, cancelButtonTitle: string | null,
                             confirmButtonTitle: string | null) {
    let initValue = (responseDefaultValue != null && responseDefaultValue.length > 0) ? responseDefaultValue : defaultValue;
    let alertMessage = (responseMessage != null && responseMessage.length > 0) ? responseMessage : message;
    let finalValue = value;
    let customDialogId = -1;
    //TODO 这里存在一个缺陷，就是点击空白弹窗消失没办法监听所以没办法调用到cancel方法会知道存在bug 需要再API12才可支持 需要后续完善
    promptAction.openCustomDialog({
      builder: ohosPromptDialogBuilder.bind(this.uiObject, initValue, alertMessage, cancelButtonTitle, confirmButtonTitle, () => {
        result.handleCancel()
        promptAction.closeCustomDialog(customDialogId)
      }, (value: string | null) => {
        promptAction.closeCustomDialog(customDialogId)
        result.handlePromptConfirm(finalValue != null ? finalValue : value);
      }),
      alignment: DialogAlignment.Center
    }).then((dialogId: number) => {
      customDialogId = dialogId
    })
  }
}

class InnerJsBeforeUnloadCallback extends JsBeforeUnloadCallback {
  private result: JsResult;
  private message: string;

  constructor(result: JsResult, message: string) {
    super();
    this.result = result;
    this.message = message;
  }

  nonNullSuccess(response: JsBeforeUnloadResponse): boolean {
    if (response.isHandledByClient()) {
      let action = response.getAction();
      action = action != null ? action : 1;
      switch (action) {
        case 0:
          this.result.handleConfirm();
          break;
        case 1:
        default:
          this.result.handleCancel();
      }
      return false;
    }
    return true;
  }

  defaultBehaviour(response: JsBeforeUnloadResponse | null): void {
    let responseMessage: string | null = null;
    let confirmButtonTitle: string | null = null;
    let cancelButtonTitle: string | null = null;
    if (response != null) {
      responseMessage = response.getMessage();
      confirmButtonTitle = response.getConfirmButtonTitle();
      cancelButtonTitle = response.getCancelButtonTitle();
    }
    this.createBeforeUnloadDialog(this.message, this.result, responseMessage, confirmButtonTitle, cancelButtonTitle);
  }

  error(errorCode: string, errorMessage: string, errorDetails: Any): void {
    Log.e(TAG, errorCode + ", " + ((errorMessage != null) ? errorMessage : ""));
    this.result.handleCancel();
  }

  private createBeforeUnloadDialog(message: string, result: JsResult, responseMessage: string | null,
                                   confirmButtonTitle: string | null, cancelButtonTitle: string | null) {
    let alertMessage = (responseMessage != null && responseMessage.length > 0) ? responseMessage : message;
    AlertDialog.show(
      {
        message: alertMessage,
        autoCancel: true,
        alignment: DialogAlignment.Center,
        primaryButton: {
          value: cancelButtonTitle != null ? cancelButtonTitle : "取消",
          action: () => {
            result.handleCancel()
          }
        },
        secondaryButton: {
          defaultFocus: true,
          value: confirmButtonTitle != null ? confirmButtonTitle : "确定",
          action: () => {
            result.handleConfirm()
          }
        },
        cancel: () => {
          result.handleCancel()
        }
      }
    )
  }
}

class InnerPermissionRequestCallback extends PermissionRequestCallback {
  private request: PermissionRequest;

  constructor(request: PermissionRequest) {
    super();
    this.request = request;
  }

  nonNullSuccess(response: PermissionResponse): boolean {
    let action = response.getAction();
    if (action != null) {
      switch (action) {
        case 1:
          this.request.grant(response.getResources().convertToArray());
          break;
        case 0:
        default:
          this.request.deny();
      }
      return false;
    }
    return true;
  }

  defaultBehaviour(response: PermissionResponse | null): void {
    this.request.deny();
  }

  error(errorCode: string, errorMessage: string, errorDetails: Any): void {
    Log.e(TAG, errorCode + ", " + ((errorMessage != null) ? errorMessage : ""));
    this.defaultBehaviour(null);
  }
}

class InnerGeolocationPermissionsShowPromptCallback extends GeolocationPermissionsShowPromptCallback {
  private geolocation: JsGeolocation;
  private origin: string;

  constructor(origin: string, geolocation: JsGeolocation) {
    super();
    this.geolocation = geolocation;
    this.origin = origin;
  }

  nonNullSuccess(response: GeolocationPermissionShowPromptResponse): boolean {
    this.geolocation.invoke(response.getOrigin(), response.isAllow(), response.isRetain());
    return false;
  }

  defaultBehaviour(response: GeolocationPermissionShowPromptResponse | null): void {
    this.geolocation.invoke(this.origin, false, false);
  }

  error(errorCode: string, errorMessage: string, errorDetails: Any): void {
    Log.e(TAG, errorCode + ", " + ((errorMessage != null) ? errorMessage : ""));
    this.defaultBehaviour(null);
  }
}
