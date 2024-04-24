import { Any, Log } from '@ohos/flutter_ohos';
import uri from '@ohos.uri'
import InAppWebViewFlutterPlugin from '../../InAppWebViewFlutterPlugin';
import DownloadStartRequest from '../../types/DownloadStartRequest';
import URLUtil from '../../types/URLUtil';
import InAppWebView from './InAppWebView';
import WebResourceResponseExt from '../../types/WebResourceResponseExt';
import CustomSchemeResponse from '../../types/CustomSchemeResponse';
import WebResourceRequestExt from '../../types/WebResourceRequestExt';

const TAG = "InAppWebViewChromeClient";

// 参考文档 所有事件 https://docs.openharmony.cn/pages/v4.1/zh-cn/application-dev/reference/apis-arkweb/ts-basic-components-web.md#onalert
export default class InAppWebViewChromeClient {
  private plugin: InAppWebViewFlutterPlugin;
  private inAppWebView: InAppWebView;

  constructor(plugin: InAppWebViewFlutterPlugin, inAppWebView: InAppWebView) {
    this.plugin = plugin;
    this.inAppWebView = inAppWebView;
  }

  onAlert = (event: Any) => {
    Log.d(TAG, "onAlert=" + JSON.stringify(event))
    return false;
  }
  onBeforeUnload = (event: Any) => {
    Log.d(TAG, "onBeforeUnload=" + JSON.stringify(event))
    return false;
  }
  onConfirm = (event: Any) => {
    Log.d(TAG, "onConfirm=" + JSON.stringify(event))
    return false;
  }
  onPrompt = (event: Any) => {
    Log.d(TAG, "onPrompt=" + JSON.stringify(event))
    return false;
  }
  onConsole = (event: Any) => {
    Log.d(TAG, "onPrompt=" + JSON.stringify(event))
    return false;
  }
  onDownloadStart = (event: Any) => {
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
  }
  onHttpErrorReceive = (event: Any) => {
    Log.d(TAG, "onHttpErrorReceive=" + JSON.stringify(event))
  }
  onPageBegin = (event: Any) => {
    Log.d(TAG, "onPageBegin=" + JSON.stringify(event))
  }
  onPageEnd = (event: Any) => {
    Log.d(TAG, "onPageBegin=" + JSON.stringify(event))
  }
  onProgressChange = (event: Any) => {
    Log.d(TAG, "onProgressChange=" + JSON.stringify(event))
  }
  onTitleReceive = (event: Any) => {
    Log.d(TAG, "onTitleReceive=" + JSON.stringify(event))
  }
  onRefreshAccessedHistory = (event: Any) => {
    Log.d(TAG, "onRefreshAccessedHistory=" + JSON.stringify(event))
  }
  onRenderExited = (event: Any) => {
    Log.d(TAG, "onRenderExited=" + JSON.stringify(event))
  }
  onShowFileSelector = (event: Any) => {
    Log.d(TAG, "onShowFileSelector=" + JSON.stringify(event))
    return false;
  }
  onResourceLoad = (event: Any) => {
    Log.d(TAG, "onResourceLoad=" + JSON.stringify(event))
  }
  onScaleChange = (event: Any) => {
    Log.d(TAG, "onScaleChange=" + JSON.stringify(event))
  }
  onInterceptRequest = async (event: Any) => {
    let request = WebResourceRequestExt.fromWebResourceRequest(event.request);
    Log.d(TAG, "onInterceptRequest=" + JSON.stringify(event))
    Log.d(TAG, "webViewAssetLoaderExt=" + this.inAppWebView.webViewAssetLoaderExt)
    if (this.inAppWebView.webViewAssetLoaderExt != null && this.inAppWebView.webViewAssetLoaderExt.loader != null) {
      try {
        let url = new uri.URI(request.getUrl());
        let webResourceResponse = await this.inAppWebView.webViewAssetLoaderExt.loader.shouldInterceptRequest(url);
        Log.d(TAG, "onInterceptRequestend= webResourceResponse=" + webResourceResponse)
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
    Log.d(TAG, "onHttpAuthRequest=" + JSON.stringify(event))
    return true;
  }
  onSslErrorEventReceive = (event: Any) => {
    Log.d(TAG, "onSslErrorEventReceive=" + JSON.stringify(event))
  }
  onClientAuthenticationRequest = (event: Any) => {
    Log.d(TAG, "onClientAuthenticationRequest=" + JSON.stringify(event))
  }
  onPermissionRequest = (event: Any) => {
    Log.d(TAG, "onPermissionRequest=" + JSON.stringify(event))
  }
  onContextMenuShow = (event: Any) => {
    Log.d(TAG, "onContextMenuShow=" + JSON.stringify(event))
    return false;
  }
  onContextMenuHide = (callback: OnContextMenuHideCallback) => {
    Log.d(TAG, "onContextMenuHide=")
  }
  onScroll = (event: Any) => {
    Log.d(TAG, "onScroll=" + JSON.stringify(event))
  }
  onGeolocationShow = (event: Any) => {
    Log.d(TAG, "onGeolocationShow=" + JSON.stringify(event))
  }
  onGeolocationHide = (event: Any) => {
    Log.d(TAG, "onGeolocationHide=" + JSON.stringify(event))
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
  }
  onFaviconReceived = (event: Any) => {
    Log.d(TAG, "onFaviconReceived=" + JSON.stringify(event))
  }
  onAudioStateChanged = (event: Any) => {
    Log.d(TAG, "onAudioStateChanged=" + JSON.stringify(event))
  }
  onFirstContentfulPaint = (event: Any) => {
    Log.d(TAG, "onFirstContentfulPaint=" + JSON.stringify(event))
  }
  onLoadIntercept = (event: Any) => {
    Log.d(TAG, "onLoadIntercept=" + JSON.stringify(event))
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
}