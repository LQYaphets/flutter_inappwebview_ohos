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
import { DynamicUtils } from "./DynamicUtils"

import { BuilderParams, DVModelParameters } from '@ohos/flutter_ohos/src/main/ets/view/DynamicView/dynamicView'

@Component
export struct OhosWebView {
  @Prop params: DVModelParameters = new DVModelParameters();
  controller: web_webview.WebviewController = new web_webview.WebviewController()

  aboutToAppear(): void {

  }

  build() {
    Column() {
      Web(
        {
          src: DynamicUtils.getParams(this.params, "src"),
          controller: this.controller
        })
        .onControllerAttached(DynamicUtils.getParams(this.params, "onControllerAttached"))
        .onAlert(DynamicUtils.getParams(this.params, "onAlert"))
        .onBeforeUnload(DynamicUtils.getParams(this.params, "onBeforeUnload"))
        .onConfirm(DynamicUtils.getParams(this.params, "onConfirm"))
        .onPrompt((event) => {
          return DynamicUtils.getParams(this.params, "onPrompt")(event, this)
        })
        .onConsole(DynamicUtils.getParams(this.params, "onConsole"))
        .onDownloadStart(DynamicUtils.getParams(this.params, "onDownloadStart"))
        .onErrorReceive(DynamicUtils.getParams(this.params, "onErrorReceive"))
        .onHttpErrorReceive(DynamicUtils.getParams(this.params, "onHttpErrorReceive"))
        .onPageBegin(DynamicUtils.getParams(this.params, "onPageBegin"))
        .onPageEnd(DynamicUtils.getParams(this.params, "onPageEnd"))
        .onProgressChange(DynamicUtils.getParams(this.params, "onProgressChange"))
        .onTitleReceive(DynamicUtils.getParams(this.params, "onTitleReceive"))
        .onRefreshAccessedHistory(DynamicUtils.getParams(this.params, "onRefreshAccessedHistory"))
        .onRenderExited(DynamicUtils.getParams(this.params, "onRenderExited"))
        .onShowFileSelector(DynamicUtils.getParams(this.params, "onShowFileSelector"))
        .onResourceLoad(DynamicUtils.getParams(this.params, "onResourceLoad"))
        .onScaleChange(DynamicUtils.getParams(this.params, "onScaleChange"))
        .onInterceptRequest(DynamicUtils.getParams(this.params, "onInterceptRequest"))
        .onHttpAuthRequest(DynamicUtils.getParams(this.params, "onHttpAuthRequest"))
        .onSslErrorEventReceive(DynamicUtils.getParams(this.params, "onSslErrorEventReceive"))
        .onClientAuthenticationRequest(DynamicUtils.getParams(this.params, "onClientAuthenticationRequest"))
        .onPermissionRequest(DynamicUtils.getParams(this.params, "onPermissionRequest"))
        .onContextMenuShow(DynamicUtils.getParams(this.params, "onContextMenuShow"))
        .onContextMenuHide(DynamicUtils.getParams(this.params, "onContextMenuHide"))
        .onScroll(DynamicUtils.getParams(this.params, "onScroll"))
        .onGeolocationShow(DynamicUtils.getParams(this.params, "onGeolocationShow"))
        .onGeolocationHide(DynamicUtils.getParams(this.params, "onGeolocationHide"))
        .onFullScreenEnter(DynamicUtils.getParams(this.params, "onFullScreenEnter"))
        .onFullScreenExit(DynamicUtils.getParams(this.params, "onFullScreenExit"))
        .onWindowNew(DynamicUtils.getParams(this.params, "onWindowNew"))
        .onWindowExit(DynamicUtils.getParams(this.params, "onWindowExit"))
        .onSearchResultReceive(DynamicUtils.getParams(this.params, "onSearchResultReceive"))
        .onDataResubmitted(DynamicUtils.getParams(this.params, "onDataResubmitted"))
        .onPageVisible(DynamicUtils.getParams(this.params, "onPageVisible"))
        .onInterceptKeyEvent(DynamicUtils.getParams(this.params, "onInterceptKeyEvent"))
        .onTouchIconUrlReceived(DynamicUtils.getParams(this.params, "onTouchIconUrlReceived"))
        .onFaviconReceived(DynamicUtils.getParams(this.params, "onFaviconReceived"))
        .onAudioStateChanged(DynamicUtils.getParams(this.params, "onAudioStateChanged"))
        .onFirstContentfulPaint(DynamicUtils.getParams(this.params, "onFirstContentfulPaint"))
        .onLoadIntercept(DynamicUtils.getParams(this.params, "onLoadIntercept"))
        .onRequestSelected(DynamicUtils.getParams(this.params, "onRequestSelected"))
        .onScreenCaptureRequest(DynamicUtils.getParams(this.params, "onScreenCaptureRequest"))
        .onOverScroll(DynamicUtils.getParams(this.params, "onOverScroll"))
        .onNavigationEntryCommitted(DynamicUtils.getParams(this.params, "onNavigationEntryCommitted"))
        .onSafeBrowsingCheckResult(DynamicUtils.getParams(this.params, "onSafeBrowsingCheckResult"))
        .onNativeEmbedLifecycleChange(DynamicUtils.getParams(this.params, "onNativeEmbedLifecycleChange"))
        .onNativeEmbedGestureEvent(DynamicUtils.getParams(this.params, "onNativeEmbedGestureEvent"))
        .domStorageAccess(DynamicUtils.getParams(this.params, "domStorageAccess"))
        .fileAccess(DynamicUtils.getParams(this.params, "fileAccess"))
        .imageAccess(DynamicUtils.getParams(this.params, "imageAccess"))
        .javaScriptAccess(DynamicUtils.getParams(this.params, "javaScriptAccess"))
        .overScrollMode(DynamicUtils.getParams(this.params, "overScrollMode"))
        .mixedMode(DynamicUtils.getParams(this.params, "mixedMode"))
        .onlineImageAccess(DynamicUtils.getParams(this.params, "onlineImageAccess"))
        .zoomAccess(DynamicUtils.getParams(this.params, "zoomAccess"))
        .overviewModeAccess(DynamicUtils.getParams(this.params, "overviewModeAccess"))
        .databaseAccess(DynamicUtils.getParams(this.params, "databaseAccess"))
        .geolocationAccess(DynamicUtils.getParams(this.params, "geolocationAccess"))
        .mediaPlayGestureAccess(DynamicUtils.getParams(this.params, "mediaPlayGestureAccess"))
        .multiWindowAccess(DynamicUtils.getParams(this.params, "multiWindowAccess"))
        .horizontalScrollBarAccess(DynamicUtils.getParams(this.params, "horizontalScrollBarAccess"))
        .verticalScrollBarAccess(DynamicUtils.getParams(this.params, "verticalScrollBarAccess"))
        .cacheMode(DynamicUtils.getParams(this.params, "cacheMode"))
        .textZoomRatio(DynamicUtils.getParams(this.params, "textZoomRatio"))
        .initialScale(DynamicUtils.getParams(this.params, "initialScale"))
        .blockNetwork(DynamicUtils.getParams(this.params, "blockNetwork"))
        .defaultFixedFontSize(DynamicUtils.getParams(this.params, "defaultFixedFontSize"))
        .defaultFontSize(DynamicUtils.getParams(this.params, "defaultFontSize"))
        .minFontSize(DynamicUtils.getParams(this.params, "minFontSize"))
        .minLogicalFontSize(DynamicUtils.getParams(this.params, "minLogicalFontSize"))
        .webFixedFont(DynamicUtils.getParams(this.params, "webFixedFont"))
        .webSansSerifFont(DynamicUtils.getParams(this.params, "webSansSerifFont"))
        .webSerifFont(DynamicUtils.getParams(this.params, "webSerifFont"))
        .webStandardFont(DynamicUtils.getParams(this.params, "webStandardFont"))
        .webFantasyFont(DynamicUtils.getParams(this.params, "webFantasyFont"))
        .webCursiveFont(DynamicUtils.getParams(this.params, "webCursiveFont"))
        .darkMode(DynamicUtils.getParams(this.params, "darkMode"))
        .forceDarkAccess(DynamicUtils.getParams(this.params, "forceDarkAccess"))
        .pinchSmooth(DynamicUtils.getParams(this.params, "pinchSmooth"))
        .allowWindowOpenMethod(DynamicUtils.getParams(this.params, "allowWindowOpenMethod"))
        .layoutMode(DynamicUtils.getParams(this.params, "layoutMode"))
        .enableNativeEmbedMode(DynamicUtils.getParams(this.params, "enableNativeEmbedMode"))
    }
  }
}

@Builder
export function buildOhosWebView(param: BuilderParams) {
  OhosWebView({ params: param.params, controller: DynamicUtils.getParams(param.params, "controller") })
}