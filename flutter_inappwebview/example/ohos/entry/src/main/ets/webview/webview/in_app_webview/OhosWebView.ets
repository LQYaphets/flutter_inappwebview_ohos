import web_webview from '@ohos.web.webview'
import { DynamicUtils } from "./DynamicUtils"

import { BuilderParams, DVModelParameters } from '@ohos/flutter_ohos/src/main/ets/view/DynamicView/dynamicView'

@Component
export struct OhosWebView {
  @Prop params: DVModelParameters = new DVModelParameters();
  controller: web_webview.WebviewController = new web_webview.WebviewController()

  build() {
    Column() {
      Web(
        {
          src: DynamicUtils.getParams(this.params, "src"),
          controller: this.controller
        })
        .onDownloadStart(DynamicUtils.getParams(this.params, "onDownloadStart"))
        .onPageBegin(DynamicUtils.getParams(this.params, "onPageBegin"))
        .onPageEnd(DynamicUtils.getParams(this.params, "onPageEnd"))
        .onErrorReceive(DynamicUtils.getParams(this.params, "onErrorReceive"))
        .onLoadIntercept(DynamicUtils.getParams(this.params, "onLoadIntercept"))
        .onRefreshAccessedHistory(DynamicUtils.getParams(this.params, "onRefreshAccessedHistory"))
        .onProgressChange(DynamicUtils.getParams(this.params, "onProgressChange"))
        .onGeolocationShow(DynamicUtils.getParams(this.params, "onGeolocationShow"))
        .onGeolocationHide(DynamicUtils.getParams(this.params, "onGeolocationHide"))
        .onShowFileSelector(DynamicUtils.getParams(this.params, "onShowFileSelector"))
        .onPermissionRequest(DynamicUtils.getParams(this.params, "onPermissionRequest"))
        .onConsole(DynamicUtils.getParams(this.params, "onConsoleMessage"))
        .onWindowExit(DynamicUtils.getParams(this.params, "onWindowExit"))
        .onScroll(DynamicUtils.getParams(this.params, "onScroll"))
        .onControllerAttached(DynamicUtils.getParams(this.params, "onControllerAttached"))
        .onWindowNew((event) => {
          let newWebViewController: web_webview.WebviewController = new web_webview.WebviewController();
          let dialogController: CustomDialogController = new CustomDialogController({
            builder: NewWebView({ webViewController: newWebViewController })
          })
          dialogController.open();
          event.handler.setWebController(newWebViewController);
        })
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

@CustomDialog
struct NewWebView {
  controller?: CustomDialogController
  webViewController: web_webview.WebviewController = new web_webview.WebviewController();

  build() {
    Web({ src: "", controller: this.webViewController })
      .javaScriptAccess(true)
      .multiWindowAccess(false)
      .onWindowExit(
        () => {
          if (this.controller) {
            this.controller.close();
          }
        }
      )
  }
}