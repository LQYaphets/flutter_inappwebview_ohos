import InAppWebView from '../webview/in_app_webview/InAppWebView';
import ContentWorld from './ContentWorld';
import { Disposable } from './Disposable';
import PluginScript from './PluginScript';
import UserScript from './UserScript';
import { UserScriptInjectionTime } from './UserScriptInjectionTime';
import { HashMap, HashSet } from '@kit.ArkTS';
import Util from '../Util';
import PluginScriptsUtil from '../plugin_scripts_js/PluginScriptsUtil';
import JavaScriptBridgeJS from '../plugin_scripts_js/JavaScriptBridgeJS';

const DOCUMENT_READY_WRAPPER_JS_SOURCE = "if (document.readyState === 'interactive' || document.readyState === 'complete') { " +
  "  " + PluginScriptsUtil.VAR_PLACEHOLDER_VALUE +
  "}";

const USER_SCRIPTS_AT_DOCUMENT_START_WRAPPER_JS_SOURCE = "if (window." + JavaScriptBridgeJS.JAVASCRIPT_BRIDGE_NAME + " != null && (window." + JavaScriptBridgeJS.JAVASCRIPT_BRIDGE_NAME + "._userScriptsAtDocumentStartLoaded == null || !window." + JavaScriptBridgeJS.JAVASCRIPT_BRIDGE_NAME + "._userScriptsAtDocumentStartLoaded)) {" +
  "  window." + JavaScriptBridgeJS.JAVASCRIPT_BRIDGE_NAME + "._userScriptsAtDocumentStartLoaded = true;" +
  "  " + PluginScriptsUtil.VAR_PLACEHOLDER_VALUE +
  "}";

const USER_SCRIPTS_AT_DOCUMENT_END_WRAPPER_JS_SOURCE = "if (window." + JavaScriptBridgeJS.JAVASCRIPT_BRIDGE_NAME + " != null && (window." + JavaScriptBridgeJS.JAVASCRIPT_BRIDGE_NAME + "._userScriptsAtDocumentEndLoaded == null || !window." + JavaScriptBridgeJS.JAVASCRIPT_BRIDGE_NAME + "._userScriptsAtDocumentEndLoaded)) {" +
  "  window." + JavaScriptBridgeJS.JAVASCRIPT_BRIDGE_NAME + "._userScriptsAtDocumentEndLoaded = true;" +
  "  " + PluginScriptsUtil.VAR_PLACEHOLDER_VALUE +
  "}";

const CONTENT_WORLD_WRAPPER_JS_SOURCE = "(function() {" +
  "  var interval = setInterval(function() {" +
  "    if (document.body == null) {return;}" +
  "    var iframeId = '" + JavaScriptBridgeJS.JAVASCRIPT_BRIDGE_NAME + "_" + PluginScriptsUtil.VAR_CONTENT_WORLD_NAME + "';" +
  "    var iframe = document.getElementById(iframeId);" +
  "    if (iframe == null) {" +
  "      iframe = document.createElement('iframe');" +
  "      iframe.id = iframeId;" +
  "      iframe.style = 'display: none; z-index: 0; position: absolute; width: 0px; height: 0px';" +
  "      document.body.append(iframe);" +
  "    }" +
  "    if (iframe.contentWindow.document.querySelector('#" + JavaScriptBridgeJS.JAVASCRIPT_BRIDGE_NAME + "_plugin_scripts') == null) {" +
  "      return;" +
  "    }" +
  "    var script = iframe.contentWindow.document.createElement('script');" +
  "    script.innerHTML = " + PluginScriptsUtil.VAR_JSON_SOURCE_ENCODED + ";" +
  "    iframe.contentWindow.document.body.append(script);" +
  "    clearInterval(interval);" +
  "  });" +
  "})();";

const CONTENT_WORLDS_GENERATOR_JS_SOURCE = "(function() {" +
  "  var interval = setInterval(function() {" +
  "    if (document.body == null) {return;}" +
  "    var contentWorldNames = [" + PluginScriptsUtil.VAR_CONTENT_WORLD_NAME_ARRAY + "];" +
  "    for (var contentWorldName of contentWorldNames) {" +
  "      var iframeId = '" + JavaScriptBridgeJS.JAVASCRIPT_BRIDGE_NAME + "_' + contentWorldName;" +
  "      var iframe = document.getElementById(iframeId);" +
  "      if (iframe == null) {" +
  "        iframe = document.createElement('iframe');" +
  "        iframe.id = iframeId;" +
  "        iframe.style = 'display: none; z-index: 0; position: absolute; width: 0px; height: 0px';" +
  "        document.body.append(iframe);" +
  "      }" +
  "      if (iframe.contentWindow.document.getElementById('" + JavaScriptBridgeJS.JAVASCRIPT_BRIDGE_NAME + "_plugin_scripts') == null) {" +
  "        var script = iframe.contentWindow.document.createElement('script');" +
  "        script.id = '" + JavaScriptBridgeJS.JAVASCRIPT_BRIDGE_NAME + "_plugin_scripts';" +
  "        script.innerHTML = " + PluginScriptsUtil.VAR_JSON_SOURCE_ENCODED + ";" +
  "        iframe.contentWindow.document.body.append(script);" +
  "      }" +
  "    }" +
  "    clearInterval(interval);" +
  "  });" +
  "})();";

export default class UserContentController implements Disposable {
  protected static LOG_TAG: string = "UserContentController";
  private contentWorlds: Set<ContentWorld> = new Set<ContentWorld>().add(ContentWorld.PAGE);
  private inAppWebView: InAppWebView | null
  private userOnlyScripts = new HashMap<UserScriptInjectionTime, HashSet<UserScript>>();
  private pluginScripts = new HashMap<UserScriptInjectionTime, HashSet<PluginScript>>()
  private isSupportedDocumentStartScript = false

  constructor(inAppWebView: InAppWebView) {
    this.inAppWebView = inAppWebView;
    this.userOnlyScripts.set(UserScriptInjectionTime.AT_DOCUMENT_START, new HashSet<UserScript>())
    this.userOnlyScripts.set(UserScriptInjectionTime.AT_DOCUMENT_END, new HashSet<UserScript>())

    this.pluginScripts.set(UserScriptInjectionTime.AT_DOCUMENT_START, new HashSet<PluginScript>());
    this.pluginScripts.set(UserScriptInjectionTime.AT_DOCUMENT_END, new HashSet<PluginScript>());
  }

  generateWrappedCodeForDocumentStart(): string {
    return Util.replaceAll(
      DOCUMENT_READY_WRAPPER_JS_SOURCE,
      PluginScriptsUtil.VAR_PLACEHOLDER_VALUE,
      this.generateCodeForDocumentStart())
  }

  generateCodeForDocumentStart(): string {
    let injectionTime = UserScriptInjectionTime.AT_DOCUMENT_START;
    let js = "";
    js += this.generatePluginScriptsCodeAt(injectionTime);
    js += this.generateContentWorldsCreatorCode();
    js += this.generateUserOnlyScriptsCodeAt(injectionTime);
    js = USER_SCRIPTS_AT_DOCUMENT_START_WRAPPER_JS_SOURCE.replace(PluginScriptsUtil.VAR_PLACEHOLDER_VALUE, js);
    return js;
  }

  generatePluginScriptsCodeAt(injectionTime: UserScriptInjectionTime) {
    let js = "";
    let scripts = this.getPluginScriptsAt(injectionTime);
    for (let script of scripts) {
      let source = ";" + script.getSource();
      source = this.wrapSourceCodeInContentWorld(script.getContentWorld(), source);
      js += source;
    }
    return js;
  }

  generateUserOnlyScriptsCodeAt(injectionTime: UserScriptInjectionTime): string {
    let js = "";
    let scripts = this.getUserOnlyScriptsAt(injectionTime);
    for (let script of scripts) {
      let source = ";" + script.getSource();
      source = this.wrapSourceCodeInContentWorld(script.getContentWorld(), source);
      js += source;
    }
    return js;
  }

  getPluginScriptsAt(injectionTime: UserScriptInjectionTime): HashSet<PluginScript> {
    return this.pluginScripts.get(injectionTime);
  }

  getUserOnlyScriptsAt(injectionTime: UserScriptInjectionTime): HashSet<UserScript> {
    return this.userOnlyScripts.get(injectionTime);
  }

  wrapSourceCodeInContentWorld(contentWorld: ContentWorld, source: string): string {
    let sourceWrapped = contentWorld == null || contentWorld.equals(ContentWorld.PAGE) ? source :
    CONTENT_WORLD_WRAPPER_JS_SOURCE
      .replace(PluginScriptsUtil.VAR_CONTENT_WORLD_NAME, UserContentController.escapeContentWorldName(contentWorld.getName()))
      .replace(PluginScriptsUtil.VAR_JSON_SOURCE_ENCODED, UserContentController.escapeCode(source));

    return sourceWrapped;
  }

  static escapeContentWorldName(name: string): string {
    return Util.replaceAll(name, "'", "\\\\'");
  }

  generateWrappedCodeForDocumentEnd(): string {
    let injectionTime = UserScriptInjectionTime.AT_DOCUMENT_END;
    let js = "";
    if (!this.isSupportedDocumentStartScript) {
      // try to reload scripts if they were not loaded during the AT_DOCUMENT_START event
      js += this.generateCodeForDocumentStart();
    }
    js += this.generatePluginScriptsCodeAt(injectionTime);
    js += this.generateUserOnlyScriptsCodeAt(injectionTime);
    js = USER_SCRIPTS_AT_DOCUMENT_END_WRAPPER_JS_SOURCE.replace(PluginScriptsUtil.VAR_PLACEHOLDER_VALUE, js);
    return js;
  }

  public static escapeCode(code: string): string {
    let escapedCode = JSON.stringify(code);
    // escapedCode = escapedCode.substring(1, escapedCode.length() - 1);
    return escapedCode;
  }

  private updateContentWorldsCreatorScript(): void {
    let source: string = this.generateContentWorldsCreatorCode();
    // if (WebViewFeature.isFeatureSupported(WebViewFeature.DOCUMENT_START_SCRIPT)) {
    //   if (contentWorldsCreatorScript != null) {
    //     contentWorldsCreatorScript.remove();
    //   }
    //   if (!source.isEmpty() && webView != null) {
    //     contentWorldsCreatorScript = WebViewCompat.addDocumentStartJavaScript(
    //     webView,
    //     source,
    //     new HashSet<String>() {{
    //       add("*");
    //     }}
    //     );
    //   }
    // }
  }

  public generateContentWorldsCreatorCode(): string {
    if (this.contentWorlds.size == 1) {
      return "";
    }

    let source = "";
    let pluginScriptsRequired = this.getPluginScriptsRequiredInAllContentWorlds();
    for (let script of pluginScriptsRequired) {
      source += script.getSource();
    }
    let contentWorldsNames = new Array<string>();
    for (let contentWorld of this.contentWorlds) {
      if (contentWorld.equals(ContentWorld.PAGE)) {
        continue;
      }
      contentWorldsNames.push("'" + UserContentController.escapeContentWorldName(contentWorld.getName()) + "'");
    }

    return CONTENT_WORLDS_GENERATOR_JS_SOURCE
      .replace(PluginScriptsUtil.VAR_CONTENT_WORLD_NAME_ARRAY, contentWorldsNames.join(", "))
      .replace(PluginScriptsUtil.VAR_JSON_SOURCE_ENCODED, UserContentController.escapeCode(source.toString()));
  }

  public addPluginScript(pluginScript: PluginScript): boolean {
    let contentWorld: ContentWorld = pluginScript.getContentWorld();
    if (contentWorld != null) {
      this.contentWorlds.add(contentWorld);
    }
    this.updateContentWorldsCreatorScript();
    // if (this.webView != null && pluginScript.getInjectionTime() == UserScriptInjectionTime.AT_DOCUMENT_START
    //   && WebViewFeature.isFeatureSupported(WebViewFeature.DOCUMENT_START_SCRIPT)) {
    //       ScriptHandler scriptHandler = WebViewCompat.addDocumentStartJavaScript(
    //               webView,
    //               wrapSourceCodeInContentWorld(pluginScript.getContentWorld(), pluginScript.getSource()),
    //               pluginScript.getAllowedOriginRules()
    //       );
    //       this.scriptHandlerMap.put(pluginScript, scriptHandler);
    //     }
    return this.pluginScripts.get(pluginScript.getInjectionTime()).add(pluginScript);
  }

  addPluginScripts(pluginScripts: Array<PluginScript>) {
    for (let pluginScript of pluginScripts) {
      this.addPluginScript(pluginScript);
    }
  }

  removePluginScript(pluginScript: PluginScript) {
    //   if (WebViewFeature.isFeatureSupported(WebViewFeature.DOCUMENT_START_SCRIPT)) {
    //   ScriptHandler scriptHandler = this.scriptHandlerMap.get(pluginScript);
    //   if (scriptHandler != null) {
    //   scriptHandler.remove();
    //   this.scriptHandlerMap.remove(pluginScript);
    // }
    // this.updateContentWorldsCreatorScript();
    // }
    return this.pluginScripts.get(pluginScript.getInjectionTime()).remove(pluginScript);
  }

  public removeAllUserOnlyScripts(): void {
    // if (WebViewFeature.isFeatureSupported(WebViewFeature.DOCUMENT_START_SCRIPT)) {
    //   for (let userOnlyScript of this.userOnlyScripts.get(UserScriptInjectionTime.AT_DOCUMENT_START)) {
    //     ScriptHandler scriptHandler = this.scriptHandlerMap.get(userOnlyScript);
    //     if (scriptHandler != null) {
    //       scriptHandler.remove();
    //       this.scriptHandlerMap.remove(userOnlyScript);
    //     }
    //   }
    // }
    this.userOnlyScripts.get(UserScriptInjectionTime.AT_DOCUMENT_START).clear();
    this.userOnlyScripts.get(UserScriptInjectionTime.AT_DOCUMENT_END).clear();
  }

  public removeAllPluginScripts(): void {
    // if (WebViewFeature.isFeatureSupported(WebViewFeature.DOCUMENT_START_SCRIPT)) {
    //   for (PluginScript pluginScript : this.pluginScripts.get(UserScriptInjectionTime.AT_DOCUMENT_START)) {
    //     ScriptHandler scriptHandler = this.scriptHandlerMap.get(pluginScript);
    //     if (scriptHandler != null) {
    //       scriptHandler.remove();
    //       this.scriptHandlerMap.remove(pluginScript);
    //     }
    //   }
    // }
    this.pluginScripts.get(UserScriptInjectionTime.AT_DOCUMENT_START).clear();
    this.pluginScripts.get(UserScriptInjectionTime.AT_DOCUMENT_END).clear();
  }

  public addUserOnlyScript(userOnlyScript: UserScript): boolean {
    let contentWorld: ContentWorld = userOnlyScript.getContentWorld()
    if (contentWorld != null) {
      this.contentWorlds.add(contentWorld);
    }
    throw Error("Ohos currently does not support this feature")
  }

  getUserOnlyScriptAsList(): HashSet<UserScript> {
    let userOnlyScripts = new HashSet<UserScript>();
    let collection = this.userOnlyScripts.values();
    for (let list of collection) {
      for (let listElement of list) {
        userOnlyScripts.add(listElement);
      }
    }
    return userOnlyScripts;
  }

  getPluginScriptAsList(): HashSet<PluginScript> {
    let pluginScripts = new HashSet<PluginScript>();
    let collection = this.pluginScripts.values();
    for (let list of collection) {
      for (let listElement of list) {
        pluginScripts.add(listElement);
      }
    }
    return pluginScripts;
  }

  removeUserOnlyScript(userOnlyScript: UserScript): boolean {
    //   if (WebViewFeature.isFeatureSupported(WebViewFeature.DOCUMENT_START_SCRIPT)) {
    //   ScriptHandler scriptHandler = this.scriptHandlerMap.get(userOnlyScript);
    //   if (scriptHandler != null) {
    //   scriptHandler.remove();
    //   this.scriptHandlerMap.remove(userOnlyScript);
    // }
    // this.updateContentWorldsCreatorScript();
    // }
    return this.userOnlyScripts.get(userOnlyScript.getInjectionTime()).remove(userOnlyScript);
  }

  public removeUserOnlyScriptAt(index: number, injectionTime: UserScriptInjectionTime): boolean {
    return this.removeUserOnlyScript(this.userOnlyScripts.get(injectionTime)[index]);
  }

  public removeUserOnlyScriptsByGroupName(groupName: string): void {
    let userOnlyScripts = this.getUserOnlyScriptAsList();
    for (let userOnlyScript of userOnlyScripts) {
      if (Util.objEquals(groupName, userOnlyScript.getGroupName())) {
        this.removeUserOnlyScript(userOnlyScript);
      }
    }
  }

  addUserOnlyScripts(userOnlyScripts: Array<UserScript>) {
    for (let userOnlyScript of userOnlyScripts) {
      this.addUserOnlyScript(userOnlyScript);
    }
  }

  resetContentWorlds() {
    this.contentWorlds.clear();
    this.contentWorlds.add(ContentWorld.PAGE);

    let pluginScripts = this.getPluginScriptAsList();
    for (let pluginScript of pluginScripts) {
      let contentWorld = pluginScript.getContentWorld();
      this.contentWorlds.add(contentWorld);
    }

    let userOnlyScripts = this.getUserOnlyScriptAsList();
    for (let userOnlyScript of userOnlyScripts) {
      let contentWorld = userOnlyScript.getContentWorld();
      this.contentWorlds.add(contentWorld);
    }
  }

  getPluginScriptsRequiredInAllContentWorlds(): HashSet<PluginScript> {
    let pluginScriptsRequired = new HashSet<PluginScript>();
    let scripts = this.getPluginScriptsAt(UserScriptInjectionTime.AT_DOCUMENT_START);
    for (let script of scripts) {
      if (script.isRequiredInAllContentWorlds()) {
        pluginScriptsRequired.add(script);
      }
    }
    return pluginScriptsRequired;
  }

  generateCodeForScriptEvaluation(source: string, contentWorld: ContentWorld | null): string {
    if (contentWorld != null && !contentWorld.equals(ContentWorld.PAGE)) {
      let sourceWrapped = "";
      if (!this.hasContentWorld(contentWorld)) {
        this.contentWorlds.add(contentWorld);

        let pluginScriptsSource = "";
        let pluginScriptsRequired = this.getPluginScriptsRequiredInAllContentWorlds();
        for (let script of pluginScriptsRequired) {
          pluginScriptsSource += script.getSource();
        }
        let contentWorldCreatorCode = CONTENT_WORLDS_GENERATOR_JS_SOURCE
          .replace(PluginScriptsUtil.VAR_CONTENT_WORLD_NAME_ARRAY, "'" + UserContentController.escapeContentWorldName(contentWorld.getName()) + "'")
          .replace(PluginScriptsUtil.VAR_JSON_SOURCE_ENCODED, UserContentController.escapeCode(pluginScriptsSource.toString()));
        sourceWrapped += (contentWorldCreatorCode + ";")
      }
      sourceWrapped += this.wrapSourceCodeInContentWorld(contentWorld, source)
      return sourceWrapped;
    }
    return source;
  }

  private hasContentWorld(contentWorld: ContentWorld) {
    for (let contentWorldsElement of this.contentWorlds) {
      if (contentWorld.equals(contentWorldsElement)) {
        return true;
      }
    }
    return false;
  }

  public dispose(): void {
    // if (WebViewFeature.isFeatureSupported(WebViewFeature.DOCUMENT_START_SCRIPT) && contentWorldsCreatorScript != null) {
    //   contentWorldsCreatorScript.remove();
    // }
    this.removeAllUserOnlyScripts();
    this.removeAllPluginScripts();
    this.inAppWebView = null;
  }
}