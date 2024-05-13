import PluginScript from '../types/PluginScript';
import { UserScriptInjectionTime } from '../types/UserScriptInjectionTime';
import JavaScriptBridgeJS from './JavaScriptBridgeJS';

export default class OnLoadResourceJS {
  public static ON_LOAD_RESOURCE_JS_PLUGIN_SCRIPT_GROUP_NAME = "IN_APP_WEBVIEW_ON_LOAD_RESOURCE_JS_PLUGIN_SCRIPT";
  public static FLAG_VARIABLE_FOR_ON_LOAD_RESOURCE_JS_SOURCE = JavaScriptBridgeJS.JAVASCRIPT_BRIDGE_NAME + "._useOnLoadResource";
  public static ON_LOAD_RESOURCE_JS_SOURCE = "window." + OnLoadResourceJS.FLAG_VARIABLE_FOR_ON_LOAD_RESOURCE_JS_SOURCE + " = true;" +
    "(function() {" +
    "   var observer = new PerformanceObserver(function(list) {" +
    "       list.getEntries().forEach(function(entry) {" +
    "         if (" + OnLoadResourceJS.FLAG_VARIABLE_FOR_ON_LOAD_RESOURCE_JS_SOURCE + " == null || " + OnLoadResourceJS.FLAG_VARIABLE_FOR_ON_LOAD_RESOURCE_JS_SOURCE + " == true) {" +
    "           var resource = {" +
    "             'url': entry.name," +
    "             'initiatorType': entry.initiatorType," +
    "             'startTime': entry.startTime," +
    "             'duration': entry.duration" +
    "           };" +
    "           window." + JavaScriptBridgeJS.JAVASCRIPT_BRIDGE_NAME + ".callHandler('onLoadResource', resource);" +
    "         }" +
    "       });" +
    "   });" +
    "   observer.observe({entryTypes: ['resource']});" +
    "})();";
  public static ON_LOAD_RESOURCE_JS_PLUGIN_SCRIPT = new PluginScript(
    OnLoadResourceJS.ON_LOAD_RESOURCE_JS_PLUGIN_SCRIPT_GROUP_NAME,
    OnLoadResourceJS.ON_LOAD_RESOURCE_JS_SOURCE,
    UserScriptInjectionTime.AT_DOCUMENT_START,
    null,
    false,
    null);
}