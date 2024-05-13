import PluginScript from '../types/PluginScript';
import { UserScriptInjectionTime } from '../types/UserScriptInjectionTime';
import JavaScriptBridgeJS from './JavaScriptBridgeJS';

export default class OnWindowBlurEventJS {
  public static ON_WINDOW_BLUR_EVENT_JS_PLUGIN_SCRIPT_GROUP_NAME = "IN_APP_WEBVIEW_ON_WINDOW_BLUR_EVENT_JS_PLUGIN_SCRIPT";
  public static ON_WINDOW_BLUR_EVENT_JS_SOURCE = "(function(){" +
    "  window.addEventListener('blur', function(e) {" +
    "    window." + JavaScriptBridgeJS.JAVASCRIPT_BRIDGE_NAME + ".callHandler('onWindowBlur');" +
    "  });" +
    "})();";
  public static ON_WINDOW_BLUR_EVENT_JS_PLUGIN_SCRIPT = new PluginScript(
    OnWindowBlurEventJS.ON_WINDOW_BLUR_EVENT_JS_PLUGIN_SCRIPT_GROUP_NAME,
    OnWindowBlurEventJS.ON_WINDOW_BLUR_EVENT_JS_SOURCE,
    UserScriptInjectionTime.AT_DOCUMENT_START,
    null,
    false,
    null
  );
}