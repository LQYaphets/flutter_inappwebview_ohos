> 模板版本: v0.0.1

<p align="center">
  <h1 align="center"> <code>flutter_inappwebview</code> </h1>
</p>

本项目基于 [flutter_inappwebview@6.0.0](https://pub.dev/packages/flutter_inappwebview/versions/6.0.0) 开发。

## 1. 安装与使用

### 1.1 安装方式

进入到工程目录并在 pubspec.yaml 中添加以下依赖：

<!-- tabs:start -->

#### pubspec.yaml

```yaml
...

dependencies:
  flutter_inappwebview:
    git:
      url: "https://gitcode.com/openharmony-sig/flutter_inappwebview.git"
      path: "flutter_inappwebview"  

...
```

执行命令

```bash
flutter pub get
```

<!-- tabs:end -->

### 1.2 使用案例

使用案例详见 [example](https://gitcode.com/openharmony-sig/flutter_inappwebview/blob/master/flutter_inappwebview/example/lib/main.dart)

## 2. 约束与限制

### 2.1 兼容性

在以下版本中已测试通过

1. Flutter: 3.7.12-ohos-1.0.6; SDK: 5.0.0(12); IDE: DevEco Studio: 5.0.13.200; ROM: 5.1.0.120 SP3;
2. Flutter: 3.22.1-ohos-1.0.1; SDK: 5.0.0(12); IDE: DevEco Studio: 5.0.13.200; ROM: 5.1.0.120 SP3;


## 3. API

> [!TIP] "Platform"列表示该属性在原三方库上支持的平台。

> [!TIP] "ohos Support"列为 yes 表示 ohos 平台支持该属性；no 则表示不支持；partially 表示部分支持。使用方法跨平台一致，效果对标 iOS 或 Android 的效果。


### InAppWebView API

| Name                | Description                         | Type     | Required | Platform    | ohos Support |
|---------------------|-------------------------------------|----------|----------|-------------|--------------|
| key                 | Flutter框架基础标识符             | Key      | no       | Android/iOS/Mac/Web | yes         |
| controllerFromPlatform | 从平台获取WebView控制器的回调 | function | yes      | Android/iOS/Mac/Web | yes         |
| windowId            | 窗口ID标识符                     | int      | no       | Android/iOS/Mac   | no           |
| initialUrlRequest   | 初始加载的URLRequest             | WebUri   | no       | Android/iOS/Mac/Web | yes          |
| initialFile         | 初始加载的本地文件路径           | String   | no       | Android/iOS/Mac/Web | yes          |
| initialData         | 初始加载的HTML数据               | InAppWebViewInitialData | no | Android/iOS/Mac/Web | yes          |
| onWebViewCreated    | WebView创建事件回调              | function | no       | Android/iOS/Mac/Web | yes          |
| onLoadStart         | 开始加载URL事件回调              | function | no       | Android/iOS/Mac/Web | partially    |
| onLoadStop          | 加载完成事件回调                 | function | no       | Android/iOS/Mac/Web | yes          |
| onReceivedError     | 接收加载错误事件回调             | function | no       | Android/iOS/Mac/Web | partially    |
| onReceivedHttpError | 接收HTTP错误事件回调             | function | no       | Android/iOS/Mac/Web | partially    |
| shouldOverrideUrlLoading | URL加载拦截回调            | function | no       | Android/iOS/Mac/Web | yes          |
| onConsoleMessage    | 控制台消息回调                  | function | no       | Android/iOS/Mac/Web | yes          |
| onProgressChanged   | 加载进度变化回调                | function | no       | Android/iOS/Mac/Web | yes          |
| onPermissionRequest | 权限请求回调（摄像头/定位等）    | function | no       | Android         | yes          |
| onSafeBrowsingHit   | 安全浏览拦截回调                 | function | no       | Android         | no           |
| onZoomScaleChanged  | 缩放比例变化回调                 | function | no       | iOS/Mac         | partially    |
| gestureRecognizers  | 手势识别器集合                   | Set<Factory<OneSequenceGestureRecognizer>> | no | Android/iOS/Mac/Web | yes          |
| keepAlive           | 是否保持WebView存活              | InAppWebViewKeepAlive | no | Android/iOS/Mac/Web | no           |
| onJsAlert           | JavaScript警告对话框回调        | function | no       | Android/iOS/Mac/Web | partially    |
| onJsConfirm         | JavaScript确认对话框回调        | function | no       | Android/iOS/Mac/Web | partially    |
| onJsPrompt          | JavaScript提示对话框回调         | function | no       | Android/iOS/Mac/Web | partially    |
| onLoadResource      | 资源加载完成回调                | function | no       | Android/iOS/Mac/Web | no           |
| onDownloadStartRequest | 文件下载开始回调              | function | no       | Android/iOS/Mac/Web | no           |
| onCreateWindow      | 窗口创建请求回调                | function | no       | Android/iOS/Mac   | no           |
| onCloseWindow       | 窗口关闭请求回调                | function | no       | Android/iOS/Mac   | no           |
| onFormResubmission  | 表单重新提交请求               | function | no       | Android/iOS/Mac   | no           |
| onNavigationResponse| 导航响应处理                    | function | no       | Android/iOS/Mac   | no           |
| onContentSizeChanged| 内容尺寸变化回调                | function | no       | Android/iOS/Mac/Web | partially    |
| onOverScrolled      | 超出滚动边界回调              | function | no       | Android/iOS/Mac/Web | yes          |
| onEnterFullscreen   | 进入全屏回调                   | function | no       | Android/iOS/Mac/Web | no           |
| onExitFullscreen    | 退出全屏回调                   | function | no       | Android/iOS/Mac/Web | no           |
| onPrintRequest      | 打印请求回调                    | function | no       | Android/iOS/Mac/Web | no           |
| onPermissionRequest | 权限请求回调（摄像头/定位等）        | function | no       | Android         | yes          |
| onGeolocationPermissionsShowPrompt | 地理位置权限请求 | function | no | Android/iOS/Mac/Web | partially    |
| shouldInterceptRequest | 请求拦截                       | function | no       | Android/iOS/Mac/Web | yes          |
| shouldInterceptAjaxRequest | AJAX请求拦截               | function | no       | Android/iOS/Mac/Web | yes          |
| onRenderProcessGone | 渲染进程崩溃回调               | function | no       | Android/iOS/Mac/Web | no           |
| onRenderProcessResponsive | 渲染进程恢复回调           | function | no       | Android/iOS/Mac/Web | no           |
| ohosParams          | OHOS特有配置参数                 | OhosInAppWebViewWidgetCreationParams | no | ohos | yes          |
| useHybridComposition | 是否使用混合渲染模式            | bool     | no       | ohos | yes          |
---

### InAppWebViewSettings API

| Name | Description | Type | Required | Platform | ohos Support |
|------|-------------|------|----------|-----------|--------------|
| javaScriptEnabled | 是否启用 JavaScript 执行 | bool | no | Android, iOS, MacOS, Web | yes |
| mediaPlaybackRequiresUserGesture | 是否需要用户手势才能播放媒体 | bool | no | Android, iOS, MacOS | yes |
| domStorageEnabled | 是否启用 DOM 存储（localStorage/sessionStorage） | bool | no | Android, iOS, MacOS, Web | yes |
| userAgent | 自定义 WebView 的 User-Agent 字符串 | String | no | Android, iOS, MacOS, Web | yes |
| applicationNameForUserAgent | 在 User-Agent 后追加的应用名称 | String | no | Android, iOS, MacOS, Web | yes |
| javaScriptCanOpenWindowsAutomatically | JavaScript 是否可以自动打开新窗口 | bool | no | Android, iOS, MacOS, Web | partially |
| useShouldOverrideUrlLoading | 是否通过 shouldOverrideUrlLoading 拦截 URL 加载 | bool | no | Android, iOS, MacOS, Web | yes |
| useOnLoadResource | 是否监听资源加载事件 | bool | no | Android, iOS, MacOS, Web | yes |
| useOnDownloadStart | 是否处理下载开始事件 | bool | no | Android, iOS, MacOS, Web | yes |
| clearCache | 是否在加载前清除缓存 | bool | no | Android, iOS, MacOS, Web | no |
| verticalScrollBarEnabled | 是否启用垂直滚动条 | bool | no | Android, iOS, MacOS, Web | yes |
| horizontalScrollBarEnabled | 是否启用水平滚动条 | bool | no | Android, iOS, MacOS, Web | yes |
| supportZoom | 是否支持缩放控制 | bool | no | Android, iOS, MacOS, Web | partially |
| allowFileAccess | 是否允许文件访问 | bool | no | Android, iOS, MacOS, Web | yes |
| allowFileAccessFromFileURLs | 是否允许从 file:// URLs 访问文件 | bool | no | Android | partially |
| allowUniversalAccessFromFileURLs | 是否允许从 file:// URLs 进行通用访问 | bool | no | Android | no |
| blockNetworkImage | 是否阻止网络图片加载 | bool | no | Android | no |
| blockNetworkLoads | 是否阻止所有网络请求 | bool | no | Android | no |
| contentBlockers | 应用于 WebView 的内容拦截规则列表 | List | no | Android, iOS, MacOS, Web | partially |
| preferredContentMode | 首选的内容渲染模式（如桌面、移动） | enum | no | Android, iOS, MacOS, Web | partially |
| minimumFontSize | 显示网页内容的最小字体大小 | int | no | Android | no |
| minimumLogicalFontSize | 网页内容的最小逻辑字体大小 | int | no | Android | no |
| layoutAlgorithm | HTML 渲染使用的布局算法 | enum | no | Android | no |
| mixedContentMode | 控制混合 HTTP/HTTPS 内容的加载策略 | enum | no | Android, OHOS | partially |
| geolocationEnabled | 是否启用地理位置权限 | bool | no | Android, iOS, OHOS | partially |
| databaseEnabled | 是否启用数据库存储 | bool | no | Android, iOS | no |
| appCacheEnabled | 是否启用应用缓存 | bool | no | Android, iOS | no |
| appCachePath | 存储应用缓存数据的路径 | String | no | Android | no |
| textZoom | 页面文字缩放比例（默认为 100） | int | no | Android, iOS, MacOS, Web | yes |
| enableNativeEmbedMode | 启用 WebView 的原生嵌入模式 | bool | no | OHOS | yes |
| onlineImageAccess | 控制是否可以访问在线图片资源 | bool | no | OHOS | no |
| blockNetwork | 是否阻止所有网络请求 | bool | no | OHOS | no |
| darkMode | 设置 WebView 的暗色模式行为 | enum | no | OHOS | yes |
| fileAccess | 是否启用文件访问权限 | bool | no | OHOS | yes |
| domStorageAccess | 是否启用 DOM 存储访问权限 | bool | no | OHOS | yes |
| multiWindowAccess | 是否允许多窗口访问 | bool | no | OHOS | partially |
| initialScale | WebView 的初始缩放比例（0 表示默认） | int | no | Android, OHOS | yes |
| needInitialFocus | WebView 是否需要初始焦点 | bool | no | Android | no |
| forceDark | 强制对 WebView 内容启用暗色主题 | enum | no | Android, OHOS | partially |
| hardwareAcceleration | 是否启用硬件加速 | bool | no | Android | no |
| supportMultipleWindows | 是否支持多个窗口 | bool | no | Android, OHOS | partially |
| setGeolocationEnabled | 启用或禁用地理位置支持 | function | no | Android, iOS | partially |
| setTextZoom | 设置页面文字缩放比例（百分比） | function | no | Android, iOS, MacOS, Web | yes |
| setJavaScriptEnabled | 启用或禁用 JavaScript 执行 | function | no | Android, iOS, MacOS, Web | yes |
| setDomStorageEnabled | 启用或禁用 DOM 存储 | function | no | Android, iOS, MacOS, Web | yes |
| setSupportZoom | 启用或禁用缩放控制 | function | no | Android, iOS, MacOS, Web | partially |
| setMixedContentMode | 设置混合内容（HTTP/HTTPS）的处理方式 | function | no | Android, OHOS | partially |
| setAllowFileAccess | 启用或禁用文件系统访问 | function | no | Android, OHOS | yes |
| setDatabaseEnabled | 启用或禁用数据库存储 | function | no | Android, iOS | no |
| setMinimumFontSize | 设置网页内容的最小字体大小 | function | no | Android | no |
| setLayoutAlgorithm | 设置 HTML 渲染使用的布局算法 | function | no | Android | no |
---

### HeadlessInAppWebView API

| Name                | Description                         | Type     | Required | Platform    | ohos Support |
|---------------------|-------------------------------------|----------|----------|-------------|--------------|
| run                 | 运行无头模式的 WebView            | function | no       | Android/iOS/Mac/Web | no           |
| getSize             | 获取无头 WebView 的大小           | function | no       | Android/iOS/Mac/Web | no           |
| setSize             | 设置无头 WebView 的大小            | function | no       | Android/iOS/Mac/Web | no           |
| dispose             | 销毁无头 WebView                 | function | no       | Android/iOS/Mac/Web | no           |
| initialSize         | 初始尺寸                          | Size     | no       | Android/iOS/Mac/Web | no           |
| initialUrlRequest   | 初始加载的URLRequest              | WebUri   | no       | Android/iOS/Mac/Web | yes          |
| initialFile         | 初始加载的本地文件路径            | String   | no       | Android/iOS/Mac/Web | yes          |
| initialData         | 初始加载的HTML数据                | InAppWebViewInitialData | no | Android/iOS/Mac/Web | yes          |
| onWebViewCreated    | WebView创建事件回调               | function | no       | Android/iOS/Mac/Web | yes          |
| onLoadStart         | 开始加载URL事件回调               | function | no       | Android/iOS/Mac/Web | partially    |
| onLoadStop          | 加载完成事件回调                  | function | no       | Android/iOS/Mac/Web | yes          |
| onReceivedError     | 接收加载错误事件回调              | function | no       | Android/iOS/Mac/Web | partially    |
| onConsoleMessage    | 控制台消息回调                    | function | no       | Android/iOS/Mac/Web | yes          |
| shouldOverrideUrlLoading | URL加载拦截回调                | function | no       | Android/iOS/Mac/Web | yes          |
| onJsAlert           | JavaScript警告对话框回调          | function | no       | Android/iOS/Mac/Web | partially    |
| onJsConfirm         | JavaScript确认对话框回调          | function | no       | Android/iOS/Mac/Web | partially    |
| onPermissionRequest | 权限请求回调（摄像头/定位等）     | function | no       | Android         | yes          |
| onDownloadStartRequest | 文件下载开始回调                | function | no       | Android/iOS/Mac/Web | no           |
| onContentSizeChanged| 内容尺寸变化回调                  | function | no       | Android/iOS/Mac/Web | partially    |
| onRenderProcessGone | 渲染进程崩溃回调                | function | no       | Android/iOS/Mac/Web | no           |
---

### InAppWebViewController API

| Name | Description | Type | Required | Platform | ohos Support |
|------|-------------|------|----------|-----------|--------------|
| getUrl | 获取当前页面的 URL | function | no | Android, iOS, MacOS, Web | yes |
| getTitle | 获取当前页面的标题 | function | no | Android, iOS, MacOS, Web | yes |
| getProgress | 获取当前页面的加载进度（0-100） | function | no | Android, iOS, MacOS, Web | yes |
| loadUrl | 在 WebView 中加载指定的 URL | function | no | Android, iOS, MacOS, Web | yes |
| reload | 重新加载 WebView | function | no | Android, iOS, MacOS, Web | yes |
| goBack | 返回 WebView 的历史记录 | function | no | Android, iOS, MacOS, Web | partially |
| setSettings | 使用新的 settings 设置 WebView 配置 | function | no | Android, iOS, MacOS, Web | partially |
| getSettings | 获取当前的 WebView 配置 | function | no | Android, iOS, MacOS, Web | partially |
| evaluateJavascript | 执行一段 JavaScript 表达式并返回结果 | function | no | Android, iOS, MacOS, Web | yes |
| loadData | 加载 HTML 数据到 WebView 中 | function | no | Android, iOS, MacOS, Web | yes |
| postUrl | 使用 POST 请求加载指定 URL | function | no | Android, iOS, MacOS | yes |
| getOriginalUrl | 获取当前页面的原始请求 URL | function | no | Android, iOS, MacOS, Web | yes |
| getScrollX | 获取水平滚动位置 | function | no | Android, iOS, MacOS, Web | yes |
| getScrollY | 获取垂直滚动位置 | function | no | Android, iOS, MacOS, Web | yes |
| scrollTo | 滚动到指定坐标位置 | function | no | Android, iOS, MacOS, Web | yes |
| scrollBy | 按增量滚动 | function | no | Android, iOS, MacOS, Web | yes |
| canGoBack | 是否可以返回上一历史记录 | function | no | Android, iOS, MacOS, Web | partially |
| canGoForward | 是否可以前进下一历史记录 | function | no | Android, iOS, MacOS, Web | partially |
| goForward | 在 WebView 浏览历史中向前导航 | function | no | Android, iOS, MacOS, Web | no |
| pauseTimers | 暂停 WebView 的所有定时器 | function | no | Android, iOS | no |
| resumeTimers | 恢复 WebView 的所有定时器 | function | no | Android, iOS | no |
| clearCache | 清除缓存 | function | no | Android, iOS | no |
| zoomBy | 按比例缩放 | function | no | Android, iOS | no |
| getZoomScale | 获取当前缩放比例 | function | no | Android, iOS | no |
| getCertificate | 获取 SSL 证书信息 | function | no | Android, iOS | no |
| createPdf | 创建 PDF 文档 | function | no | Android, iOS | no |
| printCurrentPage | 打印当前页面 | function | no | Android, iOS, MacOS | no |
| addJavaScriptHandler | 添加 JavaScript 消息处理器 | function | no | Android, iOS, MacOS | partially |
| removeJavaScriptHandler | 移除 JavaScript 消息处理器 | function | no | Android, iOS, MacOS | partially |
| hasJavaScriptHandler | 检查是否存在指定处理器 | function | no | Android, iOS, MacOS | partially |
| canScrollVertically | 是否可以垂直滚动 | function | no | Android, iOS, MacOS, Web | yes |
| canScrollHorizontally | 是否可以水平滚动 | function | no | Android, iOS, MacOS, Web | yes |
| getHitTestResult | 获取触摸 HTML 元素时的命中测试结果 | function | no | Android, iOS | no |
| getSelectedText | 获取 WebView 中选中的文本 | function | no | Android, iOS, MacOS | no |
| getContentHeight | 获取页面内容高度 | function | no | Android, iOS, MacOS | yes |
| getContentWidth | 获取页面内容宽度 | function | no | Android, iOS, MacOS | yes |
| pause | 暂停 WebView | function | no | Android, iOS | yes |
| resume | 恢复 WebView | function | no | Android, iOS | yes |
| pageDown | 页面向下滚动 | function | no | Android, iOS | yes |
| pageUp | 页面向上滚动 | function | no | Android, iOS | yes |
| setAllMediaPlaybackSuspended | 设置媒体播放状态 | function | no | Android, iOS | no |
| isInFullscreen | 是否处于全屏状态 | function | no | Android, iOS, MacOS, Web | no |
| getDefaultUserAgent | 获取默认 User-Agent | static function | no | Android, iOS, MacOS, Web | yes |
| clearAllCache | 清除所有缓存 | static function | no | Android, iOS | yes |
---

### WebStorage API

| Name                | Description                         | Type     | Required | Platform    | ohos Support |
|---------------------|-------------------------------------|----------|----------|-------------|--------------|
| localStorage        | 表示 `window.localStorage`          | Object   | no       | Android, iOS, MacOS, Web | yes      |
| sessionStorage      | 表示 `window.sessionStorage`        | Object   | no       | Android, iOS, MacOS, Web | yes      |
| length              | 返回存储的数据项数量                | function | no       | Android, iOS, MacOS, Web | partially |
| setItem             | 向存储中添加或更新一项数据          | function | no       | Android, iOS, MacOS, Web | yes      |
| getItem             | 从存储中检索一个数据项              | function | no       | Android, iOS, MacOS, Web | yes      |
| removeItem          | 从存储中移除一个数据项              | function | no       | Android, iOS, MacOS, Web | yes      |
| clear               | 清除存储中所有的键                  | function | no       | Android, iOS, MacOS, Web | yes      |
| key                 | 获取指定索引的键名                  | function | no       | Android, iOS, MacOS, Web | partially |
---

### WebStorageManager API

| Name                | Description                         | Type     | Required | Platform    | ohos Support |
|---------------------|-------------------------------------|----------|----------|-------------|--------------|
| getOrigins          | 获取特定来源的存储使用情况          | function | no       | Android, iOS | no        |
| deleteAllData       | 移除所有存储数据                   | function | no       | Android, iOS | yes       |
| deleteOrigin        | 移除指定来源的存储数据             | function | no       | Android, iOS | no        |
| getQuotaForOrigin   | 获取指定来源的存储配额             | function | no       | Android      | no        |
| getUsageForOrigin   | 获取指定来源的存储使用量            | function | no       | Android      | no        |
| fetchDataRecords    | 获取网站数据记录                   | function | no       | iOS, MacOS   | no        |
| removeDataFor       | 移除指定网站数据记录               | function | no       | iOS, MacOS   | no        |
| removeDataModifiedSince | 移除指定时间后的网站数据        | function | no       | iOS, MacOS   | no        |
---

### PrintJobController API

| Name         | Description         | Type     | Required | Platform       | ohos Support |
|--------------|---------------------|----------|----------|----------------|--------------|
| cancel       | 取消正在进行的打印任务 | function | no       | Android, iOS, MacOS | no           |
| restart      | 重新启动已取消的打印任务 | function | no       | Android, iOS, MacOS | no           |
| dismiss      | 关闭打印界面         | function | no       | Android, iOS, MacOS | no           |
| getInfo      | 获取打印任务信息       | function | no       | Android, iOS, MacOS | no           |
| dispose      | 释放资源             | function | no       | Android, iOS, MacOS | no           |
| id           | 打印任务唯一标识符    | String   | no       | Android, iOS, MacOS | no           |
| onComplete   | 打印完成回调         | function | no       | Android, iOS, MacOS | no           |
---

### FindInteractionController API

| Name                  | Description                   | Type     | Required | Platform       | ohos Support |
|-----------------------|-------------------------------|----------|----------|----------------|--------------|
| findAll               | 查找所有匹配项                | function | no       | Android, iOS, MacOS, Web | yes      |
| findNext              | 查找下一项                    | function | no       | Android, iOS, MacOS, Web | yes      |
| clearMatches          | 清除所有匹配项高亮            | function | no       | Android, iOS, MacOS, Web | yes      |
| setSearchText         | 设置搜索文本                  | function | no       | Android, iOS, MacOS, Web | yes      |
| getSearchText         | 获取当前搜索文本               | function | no       | Android, iOS, MacOS, Web | yes      |
| isFindNavigatorVisible| 检查查找导航器是否可见        | function | no       | Android, iOS, MacOS, Web | partially |
| presentFindNavigator  | 显示查找导航器                 | function | no       | Android, iOS, MacOS, Web | partially |
| dismissFindNavigator  | 隐藏查找导航器                 | function | no       | Android, iOS, MacOS, Web | partially |
| onFindResultReceived  | 查找结果回调                  | function | no       | Android, iOS, MacOS, Web | yes      |
---

### ProxyController API

| Name                | Description                         | Type     | Required | Platform    | ohos Support |
|---------------------|-------------------------------------|----------|----------|-------------|--------------|
| setProxy            | 设置网络代理配置                    | function | no       | Android, iOS | no |
| clearProxy          | 清除网络代理配置                    | function | no       | Android, iOS | no        |
| isProxySet          | 检查代理是否已设置                 | function | no       | Android, iOS | no        |
| getProxy            | 获取当前代理配置                   | function | no       | Android, iOS | no        |
| onProxyCheck        | 代理检查回调                       | function | no       | Android, iOS | no        |
---

### PullToRefreshController API

| Name | Description | Type | Required | Platform | ohos Support |
|------|-------------|------|----------|-----------|--------------|
| setEnabled | 启用/禁用下拉刷新功能 | function | no | Android, iOS | yes |
| beginRefreshing | 手动开始刷新动画 | function | no | Android, iOS | yes |
| endRefreshing | 结束刷新动画 | function | no | Android, iOS | yes |
| isEnabled | 检查刷新是否启用 | function | no | Android, iOS | yes |
| isRefreshing | 检查是否正在刷新 | function | no | Android, iOS | yes |
| setColor | 设置刷新指示器颜色 | function | no | Android, iOS | partially |
| setBackgroundColor | 设置刷新背景颜色 | function | no | Android, iOS | partially |
| setDistanceToTriggerSync | 设置触发刷新的距离 | function | no | Android | no |
| setSlingshotDistance | 设置弹性回弹距离（iOS特有） | function | no | iOS | no |
| setIndicatorSize | 设置指示器大小（Android特有） | function | no | Android | partially |
| setStyledTitle | 设置刷新标题（iOS特有） | function | no | iOS | no |
---

### WebViewAssetLoader API

| Name | Description | Type | Required | Platform | ohos Support |
|------|-------------|------|----------|-----------|--------------|
| handle | 处理指定路径的资源请求 | function | no | Android, iOS, Web | partially |
| path | 资源路径匹配规则 | String | no | Android, iOS, Web | yes |
| type | 路径处理器类型 | String | no | Android, iOS, Web | yes |
| AssetsPathHandler | 资产文件处理器 | Object | no | Android, iOS, Web | yes |
| ResourcesPathHandler | 资源文件处理器 | Object | no | Android, iOS, Web | partially |
| InternalStoragePathHandler | 内部存储处理器 | Object | no | Android, iOS | no |
| CustomPathHandler | 自定义路径处理器 | Object | no | Android, iOS, Web | partially |
---

### ContentBlocker API

| Name | Description | Type | Required | Platform | ohos Support |
|------|-------------|------|----------|-----------|--------------|
| ContentBlocker | 内容拦截规则容器 | Object | no | Android, iOS, MacOS | partially |
| trigger | 触发器规则定义 | ContentBlockerTrigger | no | Android, iOS, MacOS | partially |
| action | 触发后的执行动作 | ContentBlockerAction | no | Android, iOS, MacOS | partially |
| urlFilter | URL匹配正则表达式 | String | yes | Android, iOS, MacOS | yes |
| urlFilterIsCaseSensitive | URL匹配是否区分大小写 | bool | no | Android, iOS, MacOS | yes |
| resourceType | 资源类型过滤器 | List<ContentBlockerTriggerResourceType> | no | Android, iOS, MacOS | no |
| ifDomain | 限定生效域名列表 | List<String> | no | Android, iOS, MacOS | yes |
| unlessDomain | 排除的域名列表 | List<String> | no | Android, iOS, MacOS | yes |
| loadType | 加载类型过滤器 | List<ContentBlockerTriggerLoadType> | no | Android, iOS, MacOS | no |
| ifFrameUrl | iframe URL匹配规则 | List<String> | no | iOS, MacOS | no |
| unlessTopUrl | 排除的主文档URL | List<String> | no | Android, iOS, MacOS | partially |
| type | 动作类型（block/display-none等） | enum | yes | Android, iOS, MacOS | partially |
| selector | CSS选择器（仅display-none有效） | String | no | Android, iOS, MacOS | no |
---

### InAppWebViewKeepAlive API

| Name | Description | Type | Required | Platform | ohos Support |
|------|-------------|------|----------|-----------|--------------|
| InAppWebViewKeepAlive | 创建 WebView 保活实例 | constructor | no | Android, iOS, Web, MacOS | yes |
| id | 获取/设置保活实例唯一标识符 | String | no | Android, iOS, Web, MacOS | yes |
| javaScriptHandlersMap | JavaScript处理器映射表 | Map<String, JavaScriptHandlerCallback> | yes | Android, iOS, Web, MacOS | yes |
| userScripts | 用户脚本集合 | Map<UserScriptInjectionTime, List<UserScript>> | yes | Android, iOS, Web, MacOS | yes |
| webMessageListenerObjNames | Web消息监听器对象名称集合 | Set<String> | yes | Android, iOS, Web, MacOS | yes |
| injectedScriptsFromURL | 通过URL注入的脚本属性 | Map<String, ScriptHtmlTagAttributes> | yes | Android, iOS, Web, MacOS | yes |
| webMessageChannels | Web消息通道集合 | Set<PlatformWebMessageChannel> | yes | Android, iOS, Web, MacOS | yes |
| webMessageListeners | Web消息监听器集合 | Set<PlatformWebMessageListener> | yes | Android, iOS, Web, MacOS | yes |
---

### InAppBrowser API 

| Name | Description | Type | Required | Platform | ohos Support |
|------|-------------|------|----------|-----------|--------------|
| openUrlRequest | 使用指定URLRequest打开网页 | function | no | Android, iOS | yes |
| openFile | 打开本地文件 | function | no | Android, iOS | partially |
| openData | 打开HTML数据 | function | no | Android, iOS | yes |
| show | 显示浏览器窗口 | function | no | Android, iOS | yes |
| hide | 隐藏浏览器窗口 | function | no | Android, iOS | yes |
| close | 关闭浏览器窗口 | function | no | Android, iOS | yes |
| setSettings | 设置浏览器配置 | function | no | Android, iOS | partially |
| getSettings | 获取当前配置 | function | no | Android, iOS | partially |
| addMenuItem | 添加菜单项 | function | no | Android, iOS | no |
| removeMenuItem | 移除菜单项 | function | no | Android, iOS | no |
| isHidden | 检查是否隐藏 | function | no | Android, iOS | yes |
| isOpened | 检查是否已打开 | function | no | Android, iOS | yes |
| onBrowserCreated | 浏览器创建回调 | function | no | Android, iOS | yes |
| onLoadStart | 页面开始加载回调 | function | no | Android, iOS | yes |
| onLoadStop | 页面停止加载回调 | function | no | Android, iOS | yes |
| onLoadError | 加载错误回调 | function | no | Android, iOS | yes |
| onProgressChanged | 加载进度变化回调 | function | no | Android, iOS | yes |
| onTitleChanged | 页面标题变化回调 | function | no | Android, iOS | yes |
| onExit | 浏览器退出回调 | function | no | Android, iOS | no |
| onConsoleMessage | 控制台消息回调 | function | no | Android, iOS | yes |
| onReceivedIcon | 接收网站图标回调 | function | no | Android | no |
| onPermissionRequest | 权限请求回调 | function | no | Android | yes |
| onJsAlert | JavaScript警告回调 | function | no | Android, iOS | yes |
| onJsConfirm | JavaScript确认回调 | function | no | Android, iOS | yes |
---

### ChromeSafariBrowser API 

| Name | Description | Type | Required | Platform | ohos Support |
|------|-------------|------|----------|-----------|--------------|
| open | 使用指定URL打开浏览器 | function | no | Android | no       |
| launchUrl | 启动指定URL | function | no | Android | no       |
| close | 关闭浏览器 | function | no | Android | no       |
| isAvailable | 检查浏览器可用性 | static function | no | Android | no       |
| clearWebsiteData | 清除网站数据 | static function | no | Android | no       |
| prewarmConnections | 预热连接 | static function | no | Android | no       |
| onClosed | 浏览器关闭回调 | function | no | Android | no       |
| onOpened | 浏览器打开回调 | function | no | Android | no       |
| onCompletedInitialLoad | 初始加载完成回调 | function | no | Android | no       |
| onNavigationEvent | 导航事件回调 | function | no | Android | no       |
| onPostMessage | postMessage回调 | function | no | Android | no       |
| setActionButton | 设置动作按钮 | function | no | Android | no       |
| setSecondaryToolbar | 设置次级工具栏 | function | no | Android | no       |
| addMenuItem | 添加菜单项 | function | no | Android | no       |
| requestPostMessageChannel | 请求消息通道 | function | no | Android | no       |
| validateRelationship | 验证关系 | function | no | Android | no       |
---

### InAppLocalhostServer API 

| Name | Description | Type | Required | Platform | ohos Support |
|------|-------------|------|----------|-----------|--------------|
| InAppLocalhostServer | 创建本地服务器实例 | constructor | no | Android, iOS | no       |
| start | 启动本地服务器 | function | no | Android, iOS | no       |
| close | 停止本地服务器 | function | no | Android, iOS | no       |
| isRunning | 检查服务器是否运行中 | function | no | Android, iOS | no       |
| port | 获取服务器端口号 | int | no | Android, iOS | no       |
| directoryIndex | 获取目录索引文件名 | String | no | Android, iOS | no       |
| documentRoot | 获取文档根目录 | String | no | Android, iOS | no       |
| shared | 检查是否共享实例 | bool | no | Android, iOS | no       |
---

### CookieManager API 

| Name | Description | Type | Required | Platform | ohos Support |
|------|-------------|------|----------|-----------|--------------|
| setCookie | 设置指定URL的Cookie | function | yes | Android, iOS | **yes**       |
| getCookies | 获取指定URL的所有Cookie | function | yes | Android, iOS | **yes** |
| getCookie | 获取指定名称的Cookie | function | yes | Android, iOS | **yes** |
| deleteCookie | 删除指定Cookie | function | yes | Android, iOS | **yes**       |
| deleteCookies | 删除指定URL的所有Cookie | function | yes | Android, iOS | **yes**       |
| deleteAllCookies | 删除所有Cookie | static function | no | Android, iOS | **yes**      |
| getAllCookies | 获取所有Cookie | static function | no | Android, iOS | **yes** |
| removeSessionCookies | 移除会话Cookie | static function | no | Android, iOS | **yes**       |
| IOSCookieManager | iOS专用Cookie管理类（已废弃） | Object | no | iOS | **no**       |
---

### OhosHttpAuthCredentialDatabase  API 
| Name                | Description                         | Type     | Required | Platform    | ohos Support |
|---------------------|-------------------------------------|----------|----------|-------------|--------------|
| getAllAuthCredentials | 获取所有HTTP认证凭据               | function | no       | ohos        | yes          |
| getHttpAuthCredentials | 获取指定保护空间的HTTP认证凭据   | function | yes      | ohos        | yes          |
| setHttpAuthCredential | 设置HTTP认证凭据                 | function | yes      | ohos        | yes          |
| removeHttpAuthCredential | 移除指定HTTP认证凭据           | function | yes      | ohos        | yes          |
| removeHttpAuthCredentials | 移除指定保护空间的所有认证凭据 | function | yes      | ohos        | yes          |
| clearAllAuthCredentials | 清除所有认证凭据                 | function | no       | ohos        | yes          |
| dispose             | 释放资源                          | function | no       | ohos        | yes          |
---

### ContextMenu API 
| Name                | Description                         | Type     | Required | Platform    | ohos Support |
|---------------------|-------------------------------------|----------|----------|-------------|--------------|
| onCreateContextMenu | 当上下文菜单正在构建时触发事件       | function | no       | Android, iOS | partially    |
| onHideContextMenu   | 当上下文菜单隐藏时触发事件           | function | no       | Android, iOS | partially    |
| onContextMenuActionItemClicked | 当上下文菜单项被点击时触发事件 | function | no       | Android, iOS | partially    |
| options             | 使用 settings 替代                   | enum     | no       | Android, iOS | no           |
| settings            | 上下文菜单设置                       | ContextMenuSettings_ | no | Android, iOS | partially    |
| menuItems           | 自定义上下文菜单项列表               | List<ContextMenuItem_> | no | Android, iOS | partially    |
---

### WebViewFeature API 
| Name                | Description                         | Type     | Required | Platform    | ohos Support |
|---------------------|-------------------------------------|----------|----------|-------------|--------------|
| CREATE_WEB_MESSAGE_CHANNEL | WebMessageChannel创建功能       | enum     | no       | Android     | partially    |
| DISABLED_ACTION_MODE_MENU_ITEMS | 禁用ActionMode菜单项      | enum     | no       | Android     | partially    |
| FORCE_DARK          | 强制深色模式                       | enum     | no       | Android     | partially    |
| SAFE_BROWSING_ALLOWLIST | 安全浏览白名单                  | enum     | no       | Android     | partially    |
| SERVICE_WORKER_BASIC_USAGE | ServiceWorker基础功能        | enum     | no       | Android     | partially    |
| DOCUMENT_START_SCRIPT | 文档开始脚本注入                | enum     | no       | Android     | partially    |
| SUPPRESS_ERROR_PAGE | 抑制错误页面                     | enum     | no       | Android     | partially    |
| WEB_MESSAGE_LISTENER | Web消息监听器                   | enum     | no       | Android     | partially    |
---

### WebAuthenticationSession API 
| Name                | Description                         | Type     | Required | Platform    | ohos Support |
|---------------------|-------------------------------------|----------|----------|-------------|--------------|
| create              | 创建Web认证会话                    | function | yes      | Android, iOS | no           |
| canStart            | 检查会话是否可以启动               | function | no       | Android, iOS | no           |
| start               | 启动Web认证会话                    | function | no       | Android, iOS | no           |
| cancel              | 取消正在进行的认证会话             | function | no       | Android, iOS | no           |
| dispose             | 释放会话资源                       | function | no       | Android, iOS | no           |
| isAvailable         | 检查设备是否支持Web认证功能        | function | no       | Android, iOS | no           |
| id                  | 获取会话唯一标识                   | String   | no       | Android, iOS | no           |
| url                 | 获取认证会话的URL                  | WebUri   | no       | Android, iOS | no           |
| callbackURLScheme   | 获取回调URL协议方案                | String   | no       | Android, iOS | no           |
| initialSettings     | 获取初始会话配置                   | WebAuthenticationSessionSettings | no | Android, iOS | no           |
| onComplete          | 认证完成时的回调处理器             | WebAuthenticationSessionCompletionHandler | no | Android, iOS | no           |
---

### WebUri API 
| Name                | Description                         | Type     | Required | Platform    | ohos Support |
|---------------------|-------------------------------------|----------|----------|-------------|--------------|
| authority           | 获取URI的权限部分（host:port形式） | String   | no       | all        | yes          |
| data                | 获取URI的数据部分                 | UriData? | no       | all        | yes          |
| fragment            | 获取URI的片段标识符               | String   | no       | all        | yes          |
| hasAbsolutePath     | 检查路径是否为绝对路径            | bool     | no       | all        | yes          |
| hasAuthority        | 检查是否存在权限部分              | bool     | no       | all        | yes          |
| hasEmptyPath        | 检查路径是否为空                  | bool     | no       | all        | yes          |
| hasFragment         | 检查是否存在片段标识符            | bool     | no       | all        | yes          |
| hasPort             | 检查是否存在端口号                | bool     | no       | all        | yes          |
| hasQuery            | 检查是否存在查询参数              | bool     | no       | all        | yes          |
| hasScheme           | 检查是否存在协议方案              | bool     | no       | all        | yes          |
| host                | 获取主机名（区分大小写）           | String   | no       | all        | yes          |
| isAbsolute          | 检查是否为绝对URI                | bool     | no       | all        | yes          |
| isScheme            | 检查协议方案是否匹配              | function | yes      | all        | yes          |
| normalizePath       | 标准化路径（去除冗余）            | function | no       | all        | yes          |
| origin              | 获取源（协议+权限部分）            | String   | no       | all        | yes          |
| path                | 获取路径（区分大小写）             | String   | no       | all        | yes          |
| pathSegments        | 获取路径分段列表                  | List<String> | no | all        | yes          |
| port                | 获取端口号                         | int      | no       | all        | yes          |
| query               | 获取原始查询字符串                | String   | no       | all        | yes          |
| queryParameters     | 获取查询参数映射（仅首值）        | Map<String, String> | no | all | yes          |
| queryParametersAll  | 获取完整查询参数映射              | Map<String, List<String>> | no | all | yes          |
| removeFragment      | 移除片段创建新URI                | function | no       | all        | yes          |
| replace             | 替换URI各组成部分                | function | yes      | all        | yes          |
| resolve             | 解析相对URI                       | function | yes      | all        | yes          |
| resolveUri          | 解析相对URI对象                   | function | yes      | all        | yes          |
| scheme              | 获取协议方案（如http）            | String   | no       | all        | yes          |
| toFilePath          | 转换为文件路径                   | function | no       | all        | yes          |
| userInfo            | 获取用户信息部分                  | String   | no       | all        | yes          |
| rawValue            | 获取原始未解析的URI字符串         | String   | no       | all        | yes          |
| uriValue            | 获取解析后的标准URI对象           | Uri      | no       | all        | yes          |
| isValidUri          | 指示URI是否解析成功              | bool     | no       | all        | yes          |
| forceToStringRawValue | 控制toString()是否使用原始值     | bool     | no       | all        | yes          |
| normalizePath()     | 返回标准化路径的新URI              | function | no       | all        | yes          |
| toString()          | 字符串表示（可配置使用原始值）    | function | no       | all        | yes          |
---

## 4. 遗留问题

- [ ] ohos端本地资源跨域问题: [issues#94](https://gitcode.com/openharmony-sig/flutter_inappwebview/issues/94)

## 5. 其他

## 6. 开源协议

本项目基于 [The MIT License (MIT)](https://gitcode.com/openharmony-sig/flutter_inappwebview/blob/master/flutter_inappwebview/LICENSE) ，请自由地享受和参与开源。
