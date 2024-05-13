import PluginScript from '../types/PluginScript';
import { UserScriptInjectionTime } from '../types/UserScriptInjectionTime';
import JavaScriptBridgeJS from './JavaScriptBridgeJS';

export default class PrintJS {
  public static PRINT_JS_PLUGIN_SCRIPT_GROUP_NAME = "IN_APP_WEBVIEW_PRINT_JS_PLUGIN_SCRIPT";
  public static PRINT_JS_SOURCE = "window.print = function() {" +
    "  if (window.top == null || window.top === window) {" +
    "     window." + JavaScriptBridgeJS.JAVASCRIPT_BRIDGE_NAME + ".callHandler('onPrintRequest', window.location.href);" +
    "  } else {" +
    "     window.top.print();" +
    "  }" +
    "};";
  public static PRINT_JS_PLUGIN_SCRIPT = new PluginScript(
    PrintJS.PRINT_JS_PLUGIN_SCRIPT_GROUP_NAME,
    PrintJS.PRINT_JS_SOURCE,
    UserScriptInjectionTime.AT_DOCUMENT_START,
    null,
    false,
    null
  );
}