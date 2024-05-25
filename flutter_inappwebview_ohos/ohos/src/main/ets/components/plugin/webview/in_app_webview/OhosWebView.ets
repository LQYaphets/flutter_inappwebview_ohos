/*
* Copyright (c) 2024 Hunan OpenValley Digital Industry Development Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import web_webview from '@ohos.web.webview'
import { Params } from '@ohos/flutter_ohos/src/main/ets/plugin/platform/PlatformView'
import { FlutterWebView } from './FlutterWebView'
import InAppWebView from './InAppWebView'

@Component
export struct OhosWebView {
  @Prop params: Params;
  controller: web_webview.WebviewController = new web_webview.WebviewController()
  inAppWebview: InAppWebView | null = null

  aboutToAppear(): void {

  }

  build() {
    Column() {
      Web(
        {
          src: "",
          controller: this.controller
        })
        .onControllerAttached(this.inAppWebView!.onControllerAttached)
        .onAlert(this.inAppWebView!.inAppWebViewChromeClient?.onAlert)
        .onBeforeUnload(this.inAppWebView!.inAppWebViewChromeClient?.onBeforeUnload)
        .onConfirm(this.inAppWebView!.inAppWebViewChromeClient?.onConfirm)
        .onPrompt((event) => {
          return this.inAppWebView!.inAppWebViewChromeClient?.onPrompt(event, this)
        })
        .onConsole(this.inAppWebView!.inAppWebViewChromeClient?.onConsole)
        .onDownloadStart(this.inAppWebView!.inAppWebViewChromeClient?.onDownloadStart)
        .onErrorReceive(this.inAppWebView!.inAppWebViewChromeClient?.onErrorReceive)
        .onHttpErrorReceive(this.inAppWebView!.inAppWebViewChromeClient?.onHttpErrorReceive)
        .onPageBegin(this.inAppWebView!.inAppWebViewChromeClient?.onPageBegin)
        .onPageEnd(this.inAppWebView!.inAppWebViewChromeClient?.onPageEnd)
        .onProgressChange(this.inAppWebView!.inAppWebViewChromeClient?.onProgressChange)
        .onTitleReceive(this.inAppWebView!.inAppWebViewChromeClient?.onTitleReceive)
        .onRefreshAccessedHistory(this.inAppWebView!.inAppWebViewChromeClient?.onRefreshAccessedHistory)
        .onRenderExited(this.inAppWebView!.inAppWebViewChromeClient?.onRenderExited)
        .onShowFileSelector(this.inAppWebView!.inAppWebViewChromeClient?.onShowFileSelector)
        .onResourceLoad(this.inAppWebView!.inAppWebViewChromeClient?.onResourceLoad)
        .onScaleChange(this.inAppWebView!.inAppWebViewChromeClient?.onScaleChange)
        // .onInterceptRequest(this.inAppWebView!.inAppWebViewChromeClient?.onInterceptRequest)
        .onHttpAuthRequest(this.inAppWebView!.inAppWebViewChromeClient?.onHttpAuthRequest)
        .onSslErrorEventReceive(this.inAppWebView!.inAppWebViewChromeClient?.onSslErrorEventReceive)
        .onClientAuthenticationRequest(this.inAppWebView!.inAppWebViewChromeClient?.onClientAuthenticationRequest)
        .onPermissionRequest(this.inAppWebView!.inAppWebViewChromeClient?.onPermissionRequest)
        .onContextMenuShow(this.inAppWebView!.inAppWebViewChromeClient?.onContextMenuShow)
        // .onContextMenuHide(this.inAppWebView!.inAppWebViewChromeClient?.onContextMenuHide)
        .onScroll(this.inAppWebView!.inAppWebViewChromeClient?.onScroll)
        .onGeolocationShow(this.inAppWebView!.inAppWebViewChromeClient?.onGeolocationShow)
        // .onGeolocationHide(this.inAppWebView!.inAppWebViewChromeClient?.onGeolocationHide)
        .onFullScreenEnter(this.inAppWebView!.inAppWebViewChromeClient?.onFullScreenEnter)
        // .onFullScreenExit(this.inAppWebView!.inAppWebViewChromeClient?.onFullScreenExit)
        .onWindowNew(this.inAppWebView!.inAppWebViewChromeClient?.onWindowNew)
        // .onWindowExit(this.inAppWebView!.inAppWebViewChromeClient?.onWindowExit)
        .onSearchResultReceive(this.inAppWebView!.inAppWebViewChromeClient?.onSearchResultReceive)
        .onDataResubmitted(this.inAppWebView!.inAppWebViewChromeClient?.onDataResubmitted)
        .onPageVisible(this.inAppWebView!.inAppWebViewChromeClient?.onPageVisible)
        .onInterceptKeyEvent(this.inAppWebView!.inAppWebViewChromeClient?.onInterceptKeyEvent)
        .onTouchIconUrlReceived(this.inAppWebView!.inAppWebViewChromeClient?.onTouchIconUrlReceived)
        .onFaviconReceived(this.inAppWebView!.inAppWebViewChromeClient?.onFaviconReceived)
        .onAudioStateChanged(this.inAppWebView!.inAppWebViewChromeClient?.onAudioStateChanged)
        .onFirstContentfulPaint(this.inAppWebView!.inAppWebViewChromeClient?.onFirstContentfulPaint)
        // .onLoadIntercept(this.inAppWebView!.inAppWebViewChromeClient?.onLoadIntercept)
        // .onRequestSelected(this.inAppWebView!.inAppWebViewChromeClient?.onRequestSelected)
        .onScreenCaptureRequest(this.inAppWebView!.inAppWebViewChromeClient?.onScreenCaptureRequest)
        .onOverScroll(this.inAppWebView!.inAppWebViewChromeClient?.onOverScroll)
        // .onNavigationEntryCommitted(this.inAppWebView!.inAppWebViewChromeClient?.onNavigationEntryCommitted)
        // .onSafeBrowsingCheckResult(this.inAppWebView!.inAppWebViewChromeClient?.onSafeBrowsingCheckResult)
        .onNativeEmbedLifecycleChange(this.inAppWebView!.inAppWebViewChromeClient?.onNativeEmbedLifecycleChange)
        .onNativeEmbedGestureEvent(this.inAppWebView!.inAppWebViewChromeClient?.onNativeEmbedGestureEvent)
        .domStorageAccess(this.inAppWebView!.customSettings.domStorageAccess)
        .fileAccess(this.inAppWebView!.customSettings.fileAccess)
        .imageAccess(this.inAppWebView!.customSettings.imageAccess)
        .javaScriptAccess(this.inAppWebView!.customSettings.javaScriptAccess)
        .overScrollMode(this.inAppWebView!.customSettings.overScrollMode)
        .mixedMode(this.inAppWebView!.customSettings.mixedMode)
        .onlineImageAccess(this.inAppWebView!.customSettings.onlineImageAccess)
        .zoomAccess(this.inAppWebView!.customSettings.zoomAccess)
        .overviewModeAccess(this.inAppWebView!.customSettings.overviewModeAccess)
        .databaseAccess(this.inAppWebView!.customSettings.databaseAccess)
        .geolocationAccess(this.inAppWebView!.customSettings.geolocationAccess)
        .mediaPlayGestureAccess(this.inAppWebView!.customSettings.mediaPlayGestureAccess)
        .multiWindowAccess(this.inAppWebView!.customSettings.multiWindowAccess)
        .horizontalScrollBarAccess(this.inAppWebView!.customSettings.horizontalScrollBarAccess)
        .verticalScrollBarAccess(this.inAppWebView!.customSettings.verticalScrollBarAccess)
        .cacheMode(this.inAppWebView!.customSettings.cacheMode)
        .textZoomRatio(this.inAppWebView!.customSettings.textZoomRatio)
        .initialScale(this.inAppWebView!.customSettings.initialScale)
        .blockNetwork(this.inAppWebView!.customSettings.blockNetwork)
        .defaultFixedFontSize(this.inAppWebView!.customSettings.defaultFixedFontSize)
        .defaultFontSize(this.inAppWebView!.customSettings.defaultFontSize)
        .minFontSize(this.inAppWebView!.customSettings.minFontSize)
        .minLogicalFontSize(this.inAppWebView!.customSettings.minLogicalFontSize)
        .webFixedFont(this.inAppWebView!.customSettings.webFixedFont)
        .webSansSerifFont(this.inAppWebView!.customSettings.webSansSerifFont)
        .webSerifFont(this.inAppWebView!.customSettings.webSerifFont)
        .webStandardFont(this.inAppWebView!.customSettings.webStandardFont)
        .webFantasyFont(this.inAppWebView!.customSettings.webFantasyFont)
        .webCursiveFont(this.inAppWebView!.customSettings.webCursiveFont)
        .darkMode(this.inAppWebView!.customSettings.darkMode)
        .forceDarkAccess(this.inAppWebView!.customSettings.forceDarkAccess)
        .pinchSmooth(this.inAppWebView!.customSettings.pinchSmooth)
        .allowWindowOpenMethod(this.inAppWebView!.customSettings.allowWindowOenMethod)
        .layoutMode(this.inAppWebView!.customSettings.layoutMode)
        .enableNativeEmbedMode(this.inAppWebView!.customSettings.enableNativeEmbedMode)
    }
  }
}

@Builder
export function buildOhosWebView(params: Params) {
  OhosWebView({ params: params, controller: (params.platformView as FlutterWebView).getController(), inAppWebView: (params.platformView as FlutterWebView).getWebView() })
}