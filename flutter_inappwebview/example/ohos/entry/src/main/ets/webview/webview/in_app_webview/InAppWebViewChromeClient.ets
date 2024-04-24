import { Any, Log } from '@ohos/flutter_ohos';
import InAppWebViewFlutterPlugin from '../../InAppWebViewFlutterPlugin';
import DownloadStartRequest from '../../types/DownloadStartRequest';
import URLUtil from '../../types/URLUtil';
import InAppWebView from './InAppWebView';

const TAG = "InAppWebViewChromeClient";

// 参考文档 所有事件 https://docs.openharmony.cn/pages/v4.1/zh-cn/application-dev/reference/apis-arkweb/ts-basic-components-web.md#onalert
export default class InAppWebViewChromeClient {
  private plugin: InAppWebViewFlutterPlugin;
  private inAppWebView: InAppWebView;

  constructor(plugin: InAppWebViewFlutterPlugin, inAppWebView: InAppWebView) {
    this.plugin = plugin;
    this.inAppWebView = inAppWebView;
  }

  onAlert(event: Any): boolean {
    Log.d(TAG, "onAlert=" + JSON.stringify(event))
    return false;
  }

  onBeforeUnload(event: Any): boolean {
    Log.d(TAG, "onBeforeUnload=" + JSON.stringify(event))
    return false;
  }

  onConfirm(event: Any): boolean {
    Log.d(TAG, "onConfirm=" + JSON.stringify(event))
    return false;
  }

  onPrompt(event: Any): boolean {
    Log.d(TAG, "onPrompt=" + JSON.stringify(event))
    return false;
  }

  onConsole(event: Any): boolean {
    Log.d(TAG, "onPrompt=" + JSON.stringify(event))
    return false;
  }

  onDownloadStart(event: Any): void {
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
      // TODO
      //this.inAppWebView.channelDelegate.onDownloadStartRequest(downloadStartRequest)
    }
  }

  onErrorReceive(event: Any): void {
    Log.d(TAG, "onErrorReceive=" + JSON.stringify(event))
  }

  onHttpErrorReceive(event: Any): void {
    Log.d(TAG, "onHttpErrorReceive=" + JSON.stringify(event))
  }

  onPageBegin(event: Any): void {
    Log.d(TAG, "onPageBegin=" + JSON.stringify(event))
  }

  onPageEnd(event: Any): void {
    Log.d(TAG, "onPageBegin=" + JSON.stringify(event))
  }

  onProgressChange(event: Any): void {
    Log.d(TAG, "onProgressChange=" + JSON.stringify(event))
  }

  onTitleReceive(event: Any): void {
    Log.d(TAG, "onTitleReceive=" + JSON.stringify(event))
  }

  onRefreshAccessedHistory(event: Any): void {
    Log.d(TAG, "onRefreshAccessedHistory=" + JSON.stringify(event))
  }

  onRenderExited(event: Any): void {
    Log.d(TAG, "onRenderExited=" + JSON.stringify(event))
  }

  onShowFileSelector(event: Any): boolean {
    Log.d(TAG, "onShowFileSelector=" + JSON.stringify(event))
    return false;
  }

  onResourceLoad(event: Any): void {
    Log.d(TAG, "onResourceLoad=" + JSON.stringify(event))
  }

  onScaleChange(event: Any): void {
    Log.d(TAG, "onScaleChange=" + JSON.stringify(event))
  }

  onInterceptRequest(event: Any): WebResourceResponse | null {
    Log.d(TAG, "onInterceptRequest=" + JSON.stringify(event))
    return null
  }

  onHttpAuthRequest(event: Any): boolean {
    Log.d(TAG, "onHttpAuthRequest=" + JSON.stringify(event))
    return true;
  }

  onSslErrorEventReceive(event: Any): void {
    Log.d(TAG, "onSslErrorEventReceive=" + JSON.stringify(event))
  }

  onClientAuthenticationRequest(event: Any): void {
    Log.d(TAG, "onClientAuthenticationRequest=" + JSON.stringify(event))
  }

  onPermissionRequest(event: Any): void {
    Log.d(TAG, "onPermissionRequest=" + JSON.stringify(event))
  }

  onContextMenuShow(event: Any): boolean {
    Log.d(TAG, "onContextMenuShow=" + JSON.stringify(event))
    return false;
  }

  onContextMenuHide(callback: OnContextMenuHideCallback): void {
    Log.d(TAG, "onContextMenuHide=")
  }

  onScroll(event: Any): void {
    Log.d(TAG, "onScroll=" + JSON.stringify(event))
  }

  onGeolocationShow(event: Any): void {
    Log.d(TAG, "onGeolocationShow=" + JSON.stringify(event))
  }

  onGeolocationHide(event: Any): void {
    Log.d(TAG, "onGeolocationHide=" + JSON.stringify(event))
  }

  onFullScreenEnter(event: Any): void {
    Log.d(TAG, "onFullScreenEnter=" + JSON.stringify(event))
  }

  onFullScreenExit(event: Any): void {
    Log.d(TAG, "onFullScreenExit=" + JSON.stringify(event))
  }

  onWindowNew(event: Any): void {
    Log.d(TAG, "onWindowNew=" + JSON.stringify(event))
  }

  onWindowExit(event: Any): void {
    Log.d(TAG, "onWindowExit=" + JSON.stringify(event))
  }

  onSearchResultReceive(event: Any): void {
    Log.d(TAG, "onSearchResultReceive=" + JSON.stringify(event))
  }

  onDataResubmitted(event: Any): void {
    Log.d(TAG, "onDataResubmitted=" + JSON.stringify(event))
  }

  onPageVisible(event: Any): void {
    Log.d(TAG, "onPageVisible=" + JSON.stringify(event))
  }

  onInterceptKeyEvent(event: Any): boolean {
    Log.d(TAG, "onInterceptKeyEvent=" + JSON.stringify(event))
    return false;
  }

  onTouchIconUrlReceived(event: Any): void {
    Log.d(TAG, "onTouchIconUrlReceived=" + JSON.stringify(event))
  }

  onFaviconReceived(event: Any): void {
    Log.d(TAG, "onFaviconReceived=" + JSON.stringify(event))
  }

  onAudioStateChanged(event: Any): void {
    Log.d(TAG, "onAudioStateChanged=" + JSON.stringify(event))
  }

  onFirstContentfulPaint(event: Any): void {
    Log.d(TAG, "onFirstContentfulPaint=" + JSON.stringify(event))
  }

  onLoadIntercept(event: Any): boolean {
    Log.d(TAG, "onLoadIntercept=" + JSON.stringify(event))
    return false;
  }

  onRequestSelected(event: Any): void {
    Log.d(TAG, "onRequestSelected=" + JSON.stringify(event))
  }

  onScreenCaptureRequest(event: Any): void {
    Log.d(TAG, "onScreenCaptureRequest=" + JSON.stringify(event))
  }

  onOverScroll(event: Any): void {
    Log.d(TAG, "onOverScroll=" + JSON.stringify(event))
  }

  onNavigationEntryCommitted(callback: OnNavigationEntryCommittedCallback): void {
    Log.d(TAG, "onNavigationEntryCommitted=")
  }

  onSafeBrowsingCheckResult(callback: OnSafeBrowsingCheckResultCallback): void {
    Log.d(TAG, "onSafeBrowsingCheckResult=")
  }

  onNativeEmbedLifecycleChange(callback: NativeEmbedDataInfo): void {
    Log.d(TAG, "onNativeEmbedLifecycleChange=")
  }

  onNativeEmbedGestureEvent(callback: NativeEmbedTouchInfo): void {
    Log.d(TAG, "onNativeEmbedGestureEvent=")
  }
}