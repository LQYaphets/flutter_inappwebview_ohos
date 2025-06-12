> Template version: v0.0.1

<p align="center">
  <h1 align="center"> <code>flutter_inappwebview</code> </h1>
</p>

This project is based on [flutter_blue_plus@6.0.0](https://pub.dev/packages/flutter_inappwebview/versions/6.0.0).

## 1. Installation and Usage

### 1.1 Installation

Go to the project directory and add the following dependencies in pubspec.yaml

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

Execute Command

```bash
flutter pub get
```

<!-- tabs:end -->

### 1.2 Usage

For use cases [example](https://gitcode.com/openharmony-sig/flutter_inappwebview/blob/master/flutter_inappwebview/example/lib/main.dart)

## 2. Constraints

### 2.1 Compatibility

This document is verified based on the following versions:

1. Flutter: 3.7.12-ohos-1.0.6; SDK: 5.0.0(12); IDE: DevEco Studio: 5.0.13.200; ROM: 5.1.0.120 SP3;
2. Flutter: 3.22.1-ohos-1.0.1; SDK: 5.0.0(12); IDE: DevEco Studio: 5.0.13.200; ROM: 5.1.0.120 SP3;


## 3. API

> [!TIP] The **Platform** column indicates the platform where the properties are supported in the original third-party library.

> [!TIP] If the value of **ohos Support** is **yes**, it means that the ohos platform supports this property; **no** means the opposite; **partially** means some capabilities of this property are supported. The usage method is the same on different platforms and the effect is the same as that of iOS or Android.

### InAppWebView API

| Name                | Description                         | Type     | Required | Platform    | ohos Support |
|---------------------|-------------------------------------|----------|----------|-------------|--------------|
| key                 | Flutter framework base identifier   | Key      | no       | Android/iOS/Mac/Web | yes         |
| controllerFromPlatform | Callback to get WebView controller from platform | function | yes | Android/iOS/Mac/Web | yes         |
| windowId            | Window ID identifier               | int      | no       | Android/iOS/Mac   | no           |
| initialUrlRequest   | Initial URLRequest to load         | WebUri   | no       | Android/iOS/Mac/Web | yes          |
| initialFile         | Initial local file path to load    | String   | no       | Android/iOS/Mac/Web | yes          |
| initialData         | Initial HTML data to load          | InAppWebViewInitialData | no | Android/iOS/Mac/Web | yes          |
| onWebViewCreated    | WebView creation event callback    | function | no       | Android/iOS/Mac/Web | yes          |
| onLoadStart         | URL loading start event callback   | function | no       | Android/iOS/Mac/Web | partially    |
| onLoadStop          | URL loading completion callback    | function | no       | Android/iOS/Mac/Web | yes          |
| onReceivedError     | Loading error reception callback   | function | no       | Android/iOS/Mac/Web | partially    |
| onReceivedHttpError | HTTP error reception callback      | function | no       | Android/iOS/Mac/Web | partially    |
| shouldOverrideUrlLoading | URL loading interception callback | function | no | Android/iOS/Mac/Web | yes          |
| onConsoleMessage    | Console message callback           | function | no       | Android/iOS/Mac/Web | yes          |
| onProgressChanged   | Loading progress change callback   | function | no       | Android/iOS/Mac/Web | yes          |
| onPermissionRequest | Permission request callback (camera/location, etc.) | function | no | Android | yes          |
| onSafeBrowsingHit   | Safe browsing interception callback  | function | no       | Android | no           |
| onZoomScaleChanged  | Zoom scale change callback         | function | no       | iOS/Mac | partially    |
| gestureRecognizers  | Gesture recognizer collection      | Set<Factory<OneSequenceGestureRecognizer>> | no | Android/iOS/Mac/Web | yes          |
| keepAlive           | Whether to keep WebView alive      | InAppWebViewKeepAlive | no | Android/iOS/Mac/Web | no           |
| onJsAlert           | JavaScript alert dialog callback   | function | no       | Android/iOS/Mac/Web | partially    |
| onJsConfirm         | JavaScript confirmation dialog callback | function | no | Android/iOS/Mac/Web | partially    |
| onJsPrompt          | JavaScript prompt dialog callback  | function | no       | Android/iOS/Mac/Web | partially    |
| onLoadResource      | Resource loading completion callback | function | no | Android/iOS/Mac/Web | no           |
| onDownloadStartRequest | File download start callback    | function | no       | Android/iOS/Mac/Web | no           |
| onCreateWindow      | Window creation request callback   | function | no       | Android/iOS/Mac   | no           |
| onCloseWindow       | Window closure request callback    | function | no       | Android/iOS/Mac   | no           |
| onFormResubmission  | Form resubmission request          | function | no       | Android/iOS/Mac   | no           |
| onNavigationResponse| Navigation response handling       | function | no       | Android/iOS/Mac   | no           |
| onContentSizeChanged| Content size change callback       | function | no       | Android/iOS/Mac/Web | partially    |
| onOverScrolled      | Overscroll boundary callback       | function | no       | Android/iOS/Mac/Web | yes          |
| onEnterFullscreen   | Fullscreen entry callback          | function | no       | Android/iOS/Mac/Web | no           |
| onExitFullscreen    | Fullscreen exit callback           | function | no       | Android/iOS/Mac/Web | no           |
| onPrintRequest      | Print request callback             | function | no       | Android/iOS/Mac/Web | no           |
| onPermissionRequest | Permission request callback (camera/location, etc.) | function | no | Android | yes          |
| onGeolocationPermissionsShowPrompt | Geolocation permission request | function | no | Android/iOS/Mac/Web | partially    |
| shouldInterceptRequest | Request interception            | function | no       | Android/iOS/Mac/Web | yes          |
| shouldInterceptAjaxRequest | AJAX request interception    | function | no       | Android/iOS/Mac/Web | yes          |
| onRenderProcessGone | Render process crash callback     | function | no       | Android/iOS/Mac/Web | no           |
| onRenderProcessResponsive | Render process recovery callback | function | no | Android/iOS/Mac/Web | no           |
| ohosParams          | OHOS-specific configuration parameters | OhosInAppWebViewWidgetCreationParams | no | ohos | yes          |
| useHybridComposition | Whether to use hybrid rendering mode | bool | no | ohos | yes          |
---

### InAppWebViewSettings API

| Name | Description | Type | Required | Platform | ohos Support |
|------|-------------|------|----------|-----------|--------------|
| javaScriptEnabled | Whether to enable JavaScript execution | bool | no | Android, iOS, MacOS, Web | yes |
| mediaPlaybackRequiresUserGesture | Whether media playback requires user gesture | bool | no | Android, iOS, MacOS | yes |
| domStorageEnabled | Whether DOM storage (localStorage/sessionStorage) is enabled | bool | no | Android, iOS, MacOS, Web | yes |
| userAgent | Custom User-Agent string for WebView | String | no | Android, iOS, MacOS, Web | yes |
| applicationNameForUserAgent | Application name appended to User-Agent | String | no | Android, iOS, MacOS, Web | yes |
| javaScriptCanOpenWindowsAutomatically | Whether JavaScript can open new windows automatically | bool | no | Android, iOS, MacOS, Web | partially |
| useShouldOverrideUrlLoading | Whether to intercept URL loading via shouldOverrideUrlLoading | bool | no | Android, iOS, MacOS, Web | yes |
| useOnLoadResource | Whether to monitor resource loading events | bool | no | Android, iOS, MacOS, Web | yes |
| useOnDownloadStart | Whether to handle download start events | bool | no | Android, iOS, MacOS, Web | yes |
| clearCache | Whether to clear cache before loading | bool | no | Android, iOS, MacOS, Web | no |
| verticalScrollBarEnabled | Whether vertical scrollbar is enabled | bool | no | Android, iOS, MacOS, Web | yes |
| horizontalScrollBarEnabled | Whether horizontal scrollbar is enabled | bool | no | Android, iOS, MacOS, Web | yes |
| supportZoom | Whether zoom control is supported | bool | no | Android, iOS, MacOS, Web | partially |
| allowFileAccess | Whether file access is allowed | bool | no | Android, iOS, MacOS, Web | yes |
| allowFileAccessFromFileURLs | Whether to allow file access from file:// URLs | bool | no | Android | partially |
| allowUniversalAccessFromFileURLs | Whether universal access from file:// URLs is allowed | bool | no | Android | no |
| blockNetworkImage | Whether network image loading is blocked | bool | no | Android | no |
| blockNetworkLoads | Whether all network requests are blocked | bool | no | Android | no |
| contentBlockers | List of content blocking rules applied to WebView | List | no | Android, iOS, MacOS, Web | partially |
| preferredContentMode | Preferred content rendering mode (e.g., desktop, mobile) | enum | no | Android, iOS, MacOS, Web | partially |
| minimumFontSize | Minimum font size for displaying web content | int | no | Android | no |
| minimumLogicalFontSize | Minimum logical font size for web content | int | no | Android | no |
| layoutAlgorithm | Layout algorithm used for HTML rendering | enum | no | Android | no |
| mixedContentMode | Controls loading strategy for mixed HTTP/HTTPS content | enum | no | Android, OHOS | partially |
| geolocationEnabled | Whether geolocation permission is enabled | bool | no | Android, iOS, OHOS | partially |
| databaseEnabled | Whether database storage is enabled | bool | no | Android, iOS | no |
| appCacheEnabled | Whether application cache is enabled | bool | no | Android, iOS | no |
| appCachePath | Path to store application cache data | String | no | Android | no |
| textZoom | Page text zoom scale (default 100) | int | no | Android, iOS, MacOS, Web | yes |
| enableNativeEmbedMode | Enables WebView's native embedding mode | bool | no | OHOS | yes |
| onlineImageAccess | Controls whether online image resources can be accessed | bool | no | OHOS | no |
| blockNetwork | Whether to block all network requests | bool | no | OHOS | no |
| darkMode | Sets WebView's dark mode behavior | enum | no | OHOS | yes |
| fileAccess | Whether file access permissions are enabled | bool | no | OHOS | yes |
| domStorageAccess | Whether DOM storage access is enabled | bool | no | OHOS | yes |
| multiWindowAccess | Whether multiple window access is allowed | bool | no | OHOS | partially |
| initialScale | Initial zoom scale for WebView (0 means default) | int | no | Android, OHOS | yes |
| needInitialFocus | Whether WebView needs initial focus | bool | no | Android | no |
| forceDark | Forces dark theme for WebView content | enum | no | Android, OHOS | partially |
| hardwareAcceleration | Whether hardware acceleration is enabled | bool | no | Android | no |
| supportMultipleWindows | Whether multiple windows are supported | bool | no | Android, OHOS | partially |
| setGeolocationEnabled | Enables/disables geolocation support | function | no | Android, iOS | partially |
| setTextZoom | Sets page text zoom scale (percentage value) | function | no | Android, iOS, MacOS, Web | yes |
| setJavaScriptEnabled | Enables/disables JavaScript execution | function | no | Android, iOS, MacOS, Web | yes |
| setDomStorageEnabled | Enables/disables DOM storage | function | no | Android, iOS, MacOS, Web | yes |
| setSupportZoom | Enables/disables zoom control | function | no | Android, iOS, MacOS, Web | partially |
| setMixedContentMode | Sets handling method for mixed content (HTTP/HTTPS) | function | no | Android, OHOS | partially |
| setAllowFileAccess | Enables/disables file system access | function | no | Android, OHOS | yes |
| setDatabaseEnabled | Enables/disables database storage | function | no | Android, iOS | no |
| setMinimumFontSize | Sets minimum font size for web content | function | no | Android | no |
| setLayoutAlgorithm | Sets layout algorithm for HTML rendering | function | no | Android | no |
---

### HeadlessInAppWebView API

| Name                | Description                         | Type     | Required | Platform    | ohos Support |
|---------------------|-------------------------------------|----------|----------|-------------|--------------|
| run                 | Runs WebView in headless mode       | function | no       | Android/iOS/Mac/Web | no           |
| getSize             | Gets size of headless WebView       | function | no       | Android/iOS/Mac/Web | no           |
| setSize             | Sets size for headless WebView      | function | no       | Android/iOS/Mac/Web | no           |
| dispose             | Disposes headless WebView           | function | no       | Android/iOS/Mac/Web | no           |
| initialSize         | Initial size setting                | Size     | no       | Android/iOS/Mac/Web | no           |
| initialUrlRequest   | Initial URLRequest to load          | WebUri   | no       | Android/iOS/Mac/Web | yes          |
| initialFile         | Initial local file path to load     | String   | no       | Android/iOS/Mac/Web | yes          |
| initialData         | Initial HTML data to load           | InAppWebViewInitialData | no | Android/iOS/Mac/Web | yes          |
| onWebViewCreated    | WebView creation event callback     | function | no       | Android/iOS/Mac/Web | yes          |
| onLoadStart         | URL loading start event callback    | function | no       | Android/iOS/Mac/Web | partially    |
| onLoadStop          | URL loading completion callback     | function | no       | Android/iOS/Mac/Web | yes          |
| onReceivedError     | Loading error reception callback    | function | no       | Android/iOS/Mac/Web | partially    |
| onConsoleMessage    | Console message callback            | function | no       | Android/iOS/Mac/Web | yes          |
| shouldOverrideUrlLoading | URL loading interception callback | function | no | Android/iOS/Mac/Web | yes          |
| onJsAlert           | JavaScript alert dialog callback    | function | no       | Android/iOS/Mac/Web | partially    |
| onJsConfirm         | JavaScript confirmation dialog callback | function | no | Android/iOS/Mac/Web | partially    |
| onPermissionRequest | Permission request callback (camera/location, etc.) | function | no | Android | yes          |
| onDownloadStartRequest | File download start callback     | function | no       | Android/iOS/Mac/Web | no           |
| onContentSizeChanged| Content size change callback        | function | no       | Android/iOS/Mac/Web | partially    |
| onRenderProcessGone | Render process crash callback      | function | no       | Android/iOS/Mac/Web | no           |
---

### InAppWebViewController API

| Name | Description | Type | Required | Platform | ohos Support |
|------|-------------|------|----------|-----------|--------------|
| getUrl | Gets the URL of the current page | function | no | Android, iOS, MacOS, Web | yes |
| getTitle | Gets the title of the current page | function | no | Android, iOS, MacOS, Web | yes |
| getProgress | Gets the loading progress of the current page (0-100) | function | no | Android, iOS, MacOS, Web | yes |
| loadUrl | Loads the specified URL in the WebView | function | no | Android, iOS, MacOS, Web | yes |
| reload | Reloads the WebView | function | no | Android, iOS, MacOS, Web | yes |
| goBack | Navigates back in the WebView's history | function | no | Android, iOS, MacOS, Web | partially |
| setSettings | Sets WebView configuration with new settings | function | no | Android, iOS, MacOS, Web | partially |
| getSettings | Gets current WebView configuration | function | no | Android, iOS, MacOS, Web | partially |
| evaluateJavascript | Executes a JavaScript expression and returns the result | function | no | Android, iOS, MacOS, Web | yes |
| loadData | Loads HTML data into the WebView | function | no | Android, iOS, MacOS, Web | yes |
| postUrl | Loads a specified URL using POST request | function | no | Android, iOS, MacOS | yes |
| getOriginalUrl | Gets the original request URL of the current page | function | no | Android, iOS, MacOS, Web | yes |
| getScrollX | Gets horizontal scroll position | function | no | Android, iOS, MacOS, Web | yes |
| getScrollY | Gets vertical scroll position | function | no | Android, iOS, MacOS, Web | yes |
| scrollTo | Scrolls to specified coordinates | function | no | Android, iOS, MacOS, Web | yes |
| scrollBy | Scrolls by specified delta values | function | no | Android, iOS, MacOS, Web | yes |
| canGoBack | Checks if navigation back in history is possible | function | no | Android, iOS, MacOS, Web | partially |
| canGoForward | Checks if navigation forward in history is possible | function | no | Android, iOS, MacOS, Web | partially |
| goForward | Navigates forward in WebView history | function | no | Android, iOS, MacOS, Web | no |
| pauseTimers | Pauses all timers in WebView | function | no | Android, iOS | no |
| resumeTimers | Resumes all timers in WebView | function | no | Android, iOS | no |
| clearCache | Clears cache | function | no | Android, iOS | no |
| zoomBy | Zooms by specified scale | function | no | Android, iOS | no |
| getZoomScale | Gets current zoom scale | function | no | Android, iOS | no |
| getCertificate | Gets SSL certificate information | function | no | Android, iOS | no |
| createPdf | Creates PDF document | function | no | Android, iOS | no |
| printCurrentPage | Prints current page | function | no | Android, iOS, MacOS | no |
| addJavaScriptHandler | Adds JavaScript message handler | function | no | Android, iOS, MacOS | partially |
| removeJavaScriptHandler | Removes JavaScript message handler | function | no | Android, iOS, MacOS | partially |
| hasJavaScriptHandler | Checks existence of specified handler | function | no | Android, iOS, MacOS | partially |
| canScrollVertically | Checks if vertical scrolling is possible | function | no | Android, iOS, MacOS, Web | yes |
| canScrollHorizontally | Checks if horizontal scrolling is possible | function | no | Android, iOS, MacOS, Web | yes |
| getHitTestResult | Gets hit test result for touched HTML element | function | no | Android, iOS | no |
| getSelectedText | Gets selected text in WebView | function | no | Android, iOS, MacOS | no |
| getContentHeight | Gets page content height | function | no | Android, iOS, MacOS | yes |
| getContentWidth | Gets page content width | function | no | Android, iOS, MacOS | yes |
| pause | Pauses the WebView | function | no | Android, iOS | yes |
| resume | Resumes the WebView | function | no | Android, iOS | yes |
| pageDown | Scrolls page down | function | no | Android, iOS | yes |
| pageUp | Scrolls page up | function | no | Android, iOS | yes |
| setAllMediaPlaybackSuspended | Sets media playback state | function | no | Android, iOS | no |
| isInFullscreen | Checks if in fullscreen mode | function | no | Android, iOS, MacOS, Web | no |
| getDefaultUserAgent | Gets default User-Agent | static function | no | Android, iOS, MacOS, Web | yes |
| clearAllCache | Clears all caches | static function | no | Android, iOS | yes |
---

### WebStorage API

| Name                | Description                         | Type     | Required | Platform    | ohos Support |
|---------------------|-------------------------------------|----------|----------|-------------|--------------|
| localStorage        | Represents `window.localStorage`      | Object   | no       | Android, iOS, MacOS, Web | yes      |
| sessionStorage      | Represents `window.sessionStorage`    | Object   | no       | Android, iOS, MacOS, Web | yes      |
| length              | Returns number of stored items        | function | no       | Android, iOS, MacOS, Web | partially |
| setItem             | Adds/updates a storage item         | function | no       | Android, iOS, MacOS, Web | yes      |
| getItem             | Retrieves a storage item            | function | no       | Android, iOS, MacOS, Web | yes      |
| removeItem          | Removes a storage item              | function | no       | Android, iOS, MacOS, Web | yes      |
| clear               | Clears all keys from storage        | function | no       | Android, iOS, MacOS, Web | yes      |
| key                 | Gets key name at specified index    | function | no       | Android, iOS, MacOS, Web | partially |
---

### WebStorageManager API

| Name                | Description                         | Type     | Required | Platform    | ohos Support |
|---------------------|-------------------------------------|----------|----------|-------------|--------------|
| getOrigins          | Gets storage usage for specific origins | function | no       | Android, iOS | no        |
| deleteAllData       | Removes all storage data             | function | no       | Android, iOS | yes       |
| deleteOrigin        | Removes storage data for specific origin | function | no       | Android, iOS | no        |
| getQuotaForOrigin   | Gets storage quota for specific origin | function | no       | Android      | no        |
| getUsageForOrigin   | Gets storage usage for specific origin | function | no       | Android      | no        |
| fetchDataRecords    | Gets website data records            | function | no       | iOS, MacOS   | no        |
| removeDataFor       | Removes specified website data records | function | no       | iOS, MacOS   | no        |
| removeDataModifiedSince | Removes website data modified after specified time | function | no | iOS, MacOS | no        |
---

### PrintJobController API

| Name         | Description                     | Type     | Required | Platform       | ohos Support |
|--------------|---------------------------------|----------|----------|----------------|--------------|
| cancel       | Cancels an ongoing print job    | function | no       | Android, iOS, MacOS | no           |
| restart      | Restarts a cancelled print job  | function | no       | Android, iOS, MacOS | no           |
| dismiss      | Closes print interface          | function | no       | Android, iOS, MacOS | no           |
| getInfo      | Gets print job information      | function | no       | Android, iOS, MacOS | no           |
| dispose      | Releases resources              | function | no       | Android, iOS, MacOS | no           |
| id           | Unique identifier for print job | String   | no       | Android, iOS, MacOS | no           |
| onComplete   | Print completion callback       | function | no       | Android, iOS, MacOS | no           |
---

### FindInteractionController API

| Name                  | Description                   | Type     | Required | Platform       | ohos Support |
|-----------------------|-------------------------------|----------|----------|----------------|--------------|
| findAll               | Finds all matching items        | function | no       | Android, iOS, MacOS, Web | yes      |
| findNext              | Finds next matching item        | function | no       | Android, iOS, MacOS, Web | yes      |
| clearMatches          | Clears all match highlights   | function | no       | Android, iOS, MacOS, Web | yes      |
| setSearchText         | Sets search text value        | function | no       | Android, iOS, MacOS, Web | yes      |
| getSearchText         | Gets current search text      | function | no       | Android, iOS, MacOS, Web | yes      |
| isFindNavigatorVisible| Checks if find navigator visible | function | no | Android, iOS, MacOS, Web | partially |
| presentFindNavigator  | Shows find navigator          | function | no       | Android, iOS, MacOS, Web | partially |
| dismissFindNavigator  | Hides find navigator          | function | no       | Android, iOS, MacOS, Web | partially |
| onFindResultReceived  | Find result callback          | function | no       | Android, iOS, MacOS, Web | yes      |
---

### ProxyController API

| Name                | Description                    | Type     | Required | Platform    | ohos Support |
|---------------------|--------------------------------|----------|----------|-------------|--------------|
| setProxy            | Sets network proxy configuration | function | no       | Android, iOS | no           |
| clearProxy          | Clears network proxy configuration | function | no | Android, iOS | no           |
| isProxySet          | Checks if proxy is configured  | function | no       | Android, iOS | no           |
| getProxy            | Gets current proxy configuration | function | no | Android, iOS | no           |
| onProxyCheck        | Proxy verification callback    | function | no       | Android, iOS | no           |

---

### PullToRefreshController API

| Name | Description | Type | Required | Platform | ohos Support |
|------|-------------|------|----------|-----------|--------------|
| setEnabled | Enables/disables pull-to-refresh feature | function | no | Android, iOS | yes |
| beginRefreshing | Manually starts refresh animation | function | no | Android, iOS | yes |
| endRefreshing | Ends refresh animation | function | no | Android, iOS | yes |
| isEnabled | Checks if refresh is enabled | function | no | Android, iOS | yes |
| isRefreshing | Checks if currently refreshing | function | no | Android, iOS | yes |
| setColor | Sets refresh indicator color | function | no | Android, iOS | partially |
| setBackgroundColor | Sets refresh background color | function | no | Android, iOS | partially |
| setDistanceToTriggerSync | Sets trigger distance for refresh | function | no | Android | no |
| setSlingshotDistance | Sets elastic rebound distance (iOS-specific) | function | no | iOS | no |
| setIndicatorSize | Sets indicator size (Android-specific) | function | no | Android | partially |
| setStyledTitle | Sets refresh title (iOS-specific) | function | no | iOS | no |
---

### WebViewAssetLoader API

| Name | Description | Type | Required | Platform | ohos Support |
|------|-------------|------|----------|-----------|--------------|
| handle | Handles resource requests at specified path | function | no | Android, iOS, Web | partially |
| path | Resource path matching rules | String | no | Android, iOS, Web | yes |
| type | Path handler type | String | no | Android, iOS, Web | yes |
| AssetsPathHandler | Asset file handler | Object | no | Android, iOS, Web | yes |
| ResourcesPathHandler | Resource file handler | Object | no | Android, iOS, Web | partially |
| InternalStoragePathHandler | Internal storage handler | Object | no | Android, iOS | no |
| CustomPathHandler | Custom path handler | Object | no | Android, iOS, Web | partially |
---

### ContentBlocker API

| Name | Description | Type | Required | Platform | ohos Support |
|------|-------------|------|----------|-----------|--------------|
| ContentBlocker | Content blocking rule container | Object | no | Android, iOS, MacOS | partially |
| trigger | Trigger rule definition | ContentBlockerTrigger | no | Android, iOS, MacOS | partially |
| action | Execution action after trigger | ContentBlockerAction | no | Android, iOS, MacOS | partially |
| urlFilter | URL matching regular expression | String | yes | Android, iOS, MacOS | yes |
| urlFilterIsCaseSensitive | URL matching case sensitivity | bool | no | Android, iOS, MacOS | yes |
| resourceType | Resource type filter list | List<ContentBlockerTriggerResourceType> | no | Android, iOS, MacOS | no |
| ifDomain | Domain list for effective rules | List<String> | no | Android, iOS, MacOS | yes |
| unlessDomain | Excluded domain list | List<String> | no | Android, iOS, MacOS | yes |
| loadType | Loading type filter | List<ContentBlockerTriggerLoadType> | no | Android, iOS, MacOS | no |
| ifFrameUrl | iframe URL matching rules | List<String> | no | iOS, MacOS | no |
| unlessTopUrl | Excluded main document URLs | List<String> | no | Android, iOS, MacOS | partially |
| type | Action type (block/display-none, etc.) | enum | yes | Android, iOS, MacOS | partially |
| selector | CSS selector (display-none only) | String | no | Android, iOS, MacOS | no |
---

### InAppWebViewKeepAlive API

| Name | Description | Type | Required | Platform | ohos Support |
|------|-------------|------|----------|-----------|--------------|
| InAppWebViewKeepAlive | Creates WebView keep-alive instance | constructor | no | Android, iOS, Web, MacOS | yes |
| id | Gets/sets keep-alive instance ID | String | no | Android, iOS, Web, MacOS | yes |
| javaScriptHandlersMap | JavaScript handler mapping table | Map<String, JavaScriptHandlerCallback> | yes | Android, iOS, Web, MacOS | yes |
| userScripts | User script collection | Map<UserScriptInjectionTime, List<UserScript>> | yes | Android, iOS, Web, MacOS | yes |
| webMessageListenerObjNames | Web message listener object names | Set<String> | yes | Android, iOS, Web, MacOS | yes |
| injectedScriptsFromURL | Script attributes injected via URL | Map<String, ScriptHtmlTagAttributes> | yes | Android, iOS, Web, MacOS | yes |
| webMessageChannels | Web message channel collection | Set<PlatformWebMessageChannel> | yes | Android, iOS, Web, MacOS | yes |
| webMessageListeners | Web message listener collection | Set<PlatformWebMessageListener> | yes | Android, iOS, Web, MacOS | yes |
---

### InAppBrowser API 

| Name | Description | Type | Required | Platform | ohos Support |
|------|-------------|------|----------|-----------|--------------|
| openUrlRequest | Opens webpage with specified URLRequest | function | no | Android, iOS | yes |
| openFile | Opens local file | function | no | Android, iOS | partially |
| openData | Opens HTML data | function | no | Android, iOS | yes |
| show | Shows browser window | function | no | Android, iOS | yes |
| hide | Hides browser window | function | no | Android, iOS | yes |
| close | Closes browser window | function | no | Android, iOS | yes |
| setSettings | Sets browser configuration | function | no | Android, iOS | partially |
| getSettings | Gets current configuration | function | no | Android, iOS | partially |
| addMenuItem | Adds menu item | function | no | Android, iOS | no |
| removeMenuItem | Removes menu item | function | no | Android, iOS | no |
| isHidden | Checks if browser is hidden | function | no | Android, iOS | yes |
| isOpened | Checks if browser is open | function | no | Android, iOS | yes |
| onBrowserCreated | Browser creation callback | function | no | Android, iOS | yes |
| onLoadStart | Page loading start callback | function | no | Android, iOS | yes |
| onLoadStop | Page loading completion callback | function | no | Android, iOS | yes |
| onLoadError | Loading error callback | function | no | Android, iOS | yes |
| onProgressChanged | Loading progress change callback | function | no | Android, iOS | yes |
| onTitleChanged | Page title change callback | function | no | Android, iOS | yes |
| onExit | Browser exit callback | function | no | Android, iOS | no |
| onConsoleMessage | Console message callback | function | no | Android, iOS | yes |
| onReceivedIcon | Website icon reception callback | function | no | Android | no |
| onPermissionRequest | Permission request callback | function | no | Android | yes |
| onJsAlert | JavaScript alert callback | function | no | Android, iOS | yes |
| onJsConfirm | JavaScript confirmation callback | function | no | Android, iOS | yes |
---

### ChromeSafariBrowser API 

| Name | Description | Type | Required | Platform | ohos Support |
|------|-------------|------|----------|-----------|--------------|
| open | Opens browser with specified URL | function | no | Android | no       |
| launchUrl | Launches specified URL | function | no | Android | no       |
| close | Closes browser | function | no | Android | no       |
| isAvailable | Checks browser availability | static function | no | Android | no       |
| clearWebsiteData | Clears website data | static function | no | Android | no       |
| prewarmConnections | Prewarms connections | static function | no | Android | no       |
| onClosed | Browser closure callback | function | no | Android | no       |
| onOpened | Browser open callback | function | no | Android | no       |
| onCompletedInitialLoad | Initial load completion callback | function | no | Android | no       |
| onNavigationEvent | Navigation event callback | function | no | Android | no       |
| onPostMessage | postMessage callback | function | no | Android | no       |
| setActionButton | Sets action button | function | no | Android | no       |
| setSecondaryToolbar | Sets secondary toolbar | function | no | Android | no       |
| addMenuItem | Adds menu item | function | no | Android | no       |
| requestPostMessageChannel | Requests message channel | function | no | Android | no       |
| validateRelationship | Validates relationship | function | no | Android | no       |
---

### InAppLocalhostServer API 

| Name | Description | Type | Required | Platform | ohos Support |
|------|-------------|------|----------|-----------|--------------|
| InAppLocalhostServer | Creates local server instance | constructor | no | Android, iOS | no       |
| start | Starts local server | function | no | Android, iOS | no       |
| close | Stops local server | function | no | Android, iOS | no       |
| isRunning | Checks server running status | function | no | Android, iOS | no       |
| port | Gets server port number | int | no | Android, iOS | no       |
| directoryIndex | Gets directory index filename | String | no | Android, iOS | no       |
| documentRoot | Gets document root directory | String | no | Android, iOS | no       |
| shared | Checks if instance is shared | bool | no | Android, iOS | no       |
---

### CookieManager API 

| Name | Description | Type | Required | Platform | ohos Support |
|------|-------------|------|----------|-----------|--------------|
| setCookie | Sets cookie for specified URL | function | yes | Android, iOS | **yes**       |
| getCookies | Gets all cookies for URL | function | yes | Android, iOS | **yes** |
| getCookie | Gets cookie by name | function | yes | Android, iOS | **yes** |
| deleteCookie | Deletes specified cookie | function | yes | Android, iOS | **yes**       |
| deleteCookies | Deletes all cookies for URL | function | yes | Android, iOS | **yes**       |
| deleteAllCookies | Deletes all cookies | static function | no | Android, iOS | **yes**      |
| getAllCookies | Gets all cookies | static function | no | Android, iOS | **yes** |
| removeSessionCookies | Removes session cookies | static function | no | Android, iOS | **yes**       |
| IOSCookieManager | iOS-specific cookie manager class (deprecated) | Object | no | iOS | **no**       |
---

### OhosHttpAuthCredentialDatabase API 
| Name                | Description                         | Type     | Required | Platform    | ohos Support |
|---------------------|-------------------------------------|----------|----------|-------------|--------------|
| getAllAuthCredentials | Gets all HTTP authentication credentials | function | no       | ohos        | yes          |
| getHttpAuthCredentials | Gets HTTP credentials for specified protection space | function | yes      | ohos        | yes          |
| setHttpAuthCredential | Sets HTTP authentication credentials | function | yes      | ohos        | yes          |
| removeHttpAuthCredential | Removes specified HTTP authentication credentials | function | yes      | ohos        | yes          |
| removeHttpAuthCredentials | Removes all credentials for specified protection space | function | yes      | ohos        | yes          |
| clearAllAuthCredentials | Clears all authentication credentials | function | no       | ohos        | yes          |
| dispose             | Releases resources                  | function | no       | ohos        | yes          |
---

### ContextMenu API 
| Name                | Description                         | Type     | Required | Platform    | ohos Support |
|---------------------|-------------------------------------|----------|----------|-------------|--------------|
| onCreateContextMenu | Triggered when context menu is being built | function | no       | Android, iOS | partially    |
| onHideContextMenu   | Triggered when context menu is hidden | function | no       | Android, iOS | partially    |
| onContextMenuActionItemClicked | Triggered when context menu item is clicked | function | no       | Android, iOS | partially    |
| options             | Replaced by settings                | enum     | no       | Android, iOS | no           |
| settings            | Context menu configuration          | ContextMenuSettings_ | no | Android, iOS | partially    |
| menuItems           | Custom context menu item list       | List<ContextMenuItem_> | no | Android, iOS | partially    |
---

### WebViewFeature API 
| Name                | Description                         | Type     | Required | Platform    | ohos Support |
|---------------------|-------------------------------------|----------|----------|-------------|--------------|
| CREATE_WEB_MESSAGE_CHANNEL | WebMessageChannel creation capability | enum     | no       | Android     | partially    |
| DISABLED_ACTION_MODE_MENU_ITEMS | Disabled ActionMode menu items | enum     | no       | Android     | partially    |
| FORCE_DARK          | Force dark mode                     | enum     | no       | Android     | partially    |
| SAFE_BROWSING_ALLOWLIST | Safe browsing allowlist            | enum     | no       | Android     | partially    |
| SERVICE_WORKER_BASIC_USAGE | ServiceWorker basic functionality | enum     | no       | Android     | partially    |
| DOCUMENT_START_SCRIPT | Document start script injection    | enum     | no       | Android     | partially    |
| SUPPRESS_ERROR_PAGE | Suppress error page               | enum     | no       | Android     | partially    |
| WEB_MESSAGE_LISTENER | Web message listener              | enum     | no       | Android     | partially    |
---

### WebAuthenticationSession API 
| Name                | Description                         | Type     | Required | Platform    | ohos Support |
|---------------------|-------------------------------------|----------|----------|-------------|--------------|
| create              | Creates Web authentication session  | function | yes      | Android, iOS | no           |
| canStart            | Checks if session can be started  | function | no       | Android, iOS | no           |
| start               | Starts Web authentication session | function | no       | Android, iOS | no           |
| cancel              | Cancels ongoing authentication session | function | no       | Android, iOS | no           |
| dispose             | Releases session resources          | function | no       | Android, iOS | no           |
| isAvailable         | Checks device support for Web authentication | function | no | Android, iOS | no           |
| id                  | Gets session unique identifier    | String   | no       | Android, iOS | no           |
| url                 | Gets authentication session URL   | WebUri   | no       | Android, iOS | no           |
| callbackURLScheme   | Gets callback URL scheme          | String   | no       | Android, iOS | no           |
| initialSettings     | Gets initial session configuration  | WebAuthenticationSessionSettings | no | Android, iOS | no           |
| onComplete          | Authentication completion handler   | WebAuthenticationSessionCompletionHandler | no | Android, iOS | no           |
---

### WebUri API 
| Name                | Description                         | Type     | Required | Platform    | ohos Support |
|---------------------|-------------------------------------|----------|----------|-------------|--------------|
| authority           | Gets URI authority part (host:port format) | String   | no       | all        | yes          |
| data                | Gets URI data part                | UriData? | no       | all        | yes          |
| fragment            | Gets URI fragment identifier      | String   | no       | all        | yes          |
| hasAbsolutePath     | Checks if path is absolute         | bool     | no       | all        | yes          |
| hasAuthority        | Checks existence of authority       | bool     | no       | all        | yes          |
| hasEmptyPath        | Checks if path is empty            | bool     | no       | all        | yes          |
| hasFragment         | Checks existence of fragment        | bool     | no       | all        | yes          |
| hasPort             | Checks existence of port number     | bool     | no       | all        | yes          |
| hasQuery            | Checks existence of query parameters | bool     | no       | all        | yes          |
| hasScheme           | Checks existence of protocol scheme | bool     | no       | all        | yes          |
| host                | Gets hostname (case-sensitive)      | String   | no       | all        | yes          |
| isAbsolute          | Checks if URI is absolute         | bool     | no       | all        | yes          |
| isScheme            | Checks protocol scheme match        | function | yes      | all        | yes          |
| normalizePath       | Standardizes path (removes redundancy) | function | no       | all        | yes          |
| origin              | Gets origin (scheme+authority)    | String   | no       | all        | yes          |
| path                | Gets path (case-sensitive)          | String   | no       | all        | yes          |
| pathSegments        | Gets path segment list              | List<String> | no | all        | yes          |
| port                | Gets port number                  | int      | no       | all        | yes          |
| query               | Gets raw query string             | String   | no       | all        | yes          |
| queryParameters     | Gets query parameters map (first value only) | Map<String, String> | no | all | yes          |
| queryParametersAll  | Gets complete query parameters map  | Map<String, List<String>> | no | all | yes          |
| removeFragment      | Creates new URI with fragment removed | function | no       | all        | yes          |
| replace             | Replaces URI components           | function | yes      | all        | yes          |
| resolve             | Resolves relative URI             | function | yes      | all        | yes          |
| resolveUri          | Resolves relative URI object      | function | yes      | all        | yes          |
| scheme              | Gets protocol scheme (e.g., http) | String   | no       | all        | yes          |
| toFilePath          | Converts to file path             | function | no       | all        | yes          |
| userInfo            | Gets user info component          | String   | no       | all        | yes          |
| rawValue            | Gets raw unparsed URI string      | String   | no       | all        | yes          |
| uriValue            | Gets parsed standard URI object    | Uri      | no       | all        | yes          |
| isValidUri          | Indicates if URI parsing succeeded  | bool     | no       | all        | yes          |
| forceToStringRawValue | Controls toString() to use raw value | bool     | no       | all        | yes          |
| normalizePath()     | Returns new standardized path URI   | function | no       | all        | yes          |
| toString()          | String representation (configurable to use raw value) | function | no | all        | yes          |
---

## 4. Known Issues

- [ ] Cross-domain issue with local resources on ohos: [issues#94](https://gitcode.com/openharmony-sig/flutter_inappwebview/issues/94)

## 5. Others

## 6. License

This project is licensed under [The MIT License (MIT)](https://gitcode.com/openharmony-sig/flutter_inappwebview/blob/master/flutter_inappwebview/LICENSE).
