import PluginScript from '../types/PluginScript';
import { UserScriptInjectionTime } from '../types/UserScriptInjectionTime';
import JavaScriptBridgeJS from './JavaScriptBridgeJS';

export default class PluginScriptsUtil {
  public static VAR_PLACEHOLDER_VALUE = "$IN_APP_WEBVIEW_PLACEHOLDER_VALUE";
  public static VAR_CONTENT_WORLD_NAME_ARRAY = "$IN_APP_WEBVIEW_CONTENT_WORLD_NAME_ARRAY";
  public static VAR_CONTENT_WORLD_NAME = "$IN_APP_WEBVIEW_CONTENT_WORLD_NAME";
  public static VAR_JSON_SOURCE_ENCODED = "$IN_APP_WEBVIEW_JSON_SOURCE_ENCODED";
  public static VAR_FUNCTION_ARGUMENT_NAMES = "$IN_APP_WEBVIEW_FUNCTION_ARGUMENT_NAMES";
  public static VAR_FUNCTION_ARGUMENT_VALUES = "$IN_APP_WEBVIEW_FUNCTION_ARGUMENT_VALUES";
  public static VAR_FUNCTION_ARGUMENTS_OBJ = "$IN_APP_WEBVIEW_FUNCTION_ARGUMENTS_OBJ";
  public static VAR_FUNCTION_BODY = "$IN_APP_WEBVIEW_FUNCTION_BODY";
  public static VAR_RESULT_UUID = "$IN_APP_WEBVIEW_RESULT_UUID";
  public static VAR_RANDOM_NAME = "$IN_APP_WEBVIEW_VARIABLE_RANDOM_NAME";
  public static CALL_ASYNC_JAVA_SCRIPT_WRAPPER_JS_SOURCE = "(function(obj) {" +
    "  (async function(" + PluginScriptsUtil.VAR_FUNCTION_ARGUMENT_NAMES + ") {" +
    "    \n" + PluginScriptsUtil.VAR_FUNCTION_BODY + "\n" +
    "  })(" + PluginScriptsUtil.VAR_FUNCTION_ARGUMENT_VALUES + ").then(function(value) {" +
    "    window." + JavaScriptBridgeJS.JAVASCRIPT_BRIDGE_NAME + ".callHandler('callAsyncJavaScript', {'value': value, 'error': null, 'resultUuid': '" + PluginScriptsUtil.VAR_RESULT_UUID + "'});" +
    "  }).catch(function(error) {" +
    "    window." + JavaScriptBridgeJS.JAVASCRIPT_BRIDGE_NAME + ".callHandler('callAsyncJavaScript', {'value': null, 'error': error + '', 'resultUuid': '" + PluginScriptsUtil.VAR_RESULT_UUID + "'});" +
    "  });" +
    "  return null;" +
    "})(" + PluginScriptsUtil.VAR_FUNCTION_ARGUMENTS_OBJ + ");";
  public static EVALUATE_JAVASCRIPT_WITH_CONTENT_WORLD_WRAPPER_JS_SOURCE = "var $IN_APP_WEBVIEW_VARIABLE_RANDOM_NAME = null;" +
    "try {" +
    "  $IN_APP_WEBVIEW_VARIABLE_RANDOM_NAME = eval(" + PluginScriptsUtil.VAR_PLACEHOLDER_VALUE + ");" +
    "} catch(e) {" +
    "  console.error(e);" +
    "}" +
    "window." + JavaScriptBridgeJS.JAVASCRIPT_BRIDGE_NAME + ".callHandler('evaluateJavaScriptWithContentWorld', {'value': $IN_APP_WEBVIEW_VARIABLE_RANDOM_NAME, 'resultUuid': '" + PluginScriptsUtil.VAR_RESULT_UUID + "'});";
  public static IS_ACTIVE_ELEMENT_INPUT_EDITABLE_JS_SOURCE =
    "var activeEl = document.activeElement;" +
      "var nodeName = (activeEl != null) ? activeEl.nodeName.toLowerCase() : '';" +
      "var isActiveElementInputEditable = activeEl != null && " +
      "(activeEl.nodeType == 1 && (nodeName == 'textarea' || (nodeName == 'input' && /^(?:text|email|number|search|tel|url|password)$/i.test(activeEl.type != null ? activeEl.type : 'text')))) && " +
      "!activeEl.disabled && !activeEl.readOnly;" +
      "var isActiveElementEditable = isActiveElementInputEditable || (activeEl != null && activeEl.isContentEditable) || document.designMode === 'on';";
  // android Workaround to hide context menu when selected text is empty
  // and the document active element is not an input element.
  public static CHECK_CONTEXT_MENU_SHOULD_BE_HIDDEN_JS_SOURCE = "(function(){" +
    "  var txt;" +
    "  if (window.getSelection) {" +
    "    txt = window.getSelection().toString();" +
    "  } else if (window.document.getSelection) {" +
    "    txt = window.document.getSelection().toString();" +
    "  } else if (window.document.selection) {" +
    "    txt = window.document.selection.createRange().text;" +
    "  }" +
  PluginScriptsUtil.IS_ACTIVE_ELEMENT_INPUT_EDITABLE_JS_SOURCE +
    "  return txt === '' && !isActiveElementEditable;" +
    "})();";
  public static GET_SELECTED_TEXT_JS_SOURCE = "(function(){" +
    "  var txt;" +
    "  if (window.getSelection) {" +
    "    txt = window.getSelection().toString();" +
    "  } else if (window.document.getSelection) {" +
    "    txt = window.document.getSelection().toString();" +
    "  } else if (window.document.selection) {" +
    "    txt = window.document.selection.createRange().text;" +
    "  }" +
    "  return txt;" +
    "})();";
  public static CHECK_GLOBAL_KEY_DOWN_EVENT_TO_HIDE_CONTEXT_MENU_JS_PLUGIN_SCRIPT_GROUP_NAME = "CHECK_GLOBAL_KEY_DOWN_EVENT_TO_HIDE_CONTEXT_MENU_JS_PLUGIN_SCRIPT";
  // android Workaround to hide context menu when user emit a keydown event
  public static CHECK_GLOBAL_KEY_DOWN_EVENT_TO_HIDE_CONTEXT_MENU_JS_SOURCE = "(function(){" +
    "  document.addEventListener('keydown', function(e) {" +
    "    window." + JavaScriptBridgeJS.JAVASCRIPT_BRIDGE_NAME + "._hideContextMenu();" +
    "  });" +
    "})();";
  public static CHECK_GLOBAL_KEY_DOWN_EVENT_TO_HIDE_CONTEXT_MENU_JS_PLUGIN_SCRIPT = new PluginScript(
    PluginScriptsUtil.CHECK_GLOBAL_KEY_DOWN_EVENT_TO_HIDE_CONTEXT_MENU_JS_PLUGIN_SCRIPT_GROUP_NAME,
    PluginScriptsUtil.CHECK_GLOBAL_KEY_DOWN_EVENT_TO_HIDE_CONTEXT_MENU_JS_SOURCE,
    UserScriptInjectionTime.AT_DOCUMENT_START,
    null,
    false,
    null
  );
}