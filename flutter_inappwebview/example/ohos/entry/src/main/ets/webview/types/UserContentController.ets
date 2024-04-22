import InAppWebView from '../webview/in_app_webview/InAppWebView';
import ContentWorld from './ContentWorld';
import { Disposable } from './Disposable';
import PluginScript from './PluginScript';
import UserScript from './UserScript';

export default class UserContentController implements Disposable {
  protected static LOG_TAG: string = "UserContentController";

  private contentWorlds: Set<ContentWorld> = new Set<ContentWorld>().add(ContentWorld.PAGE);

  private inAppWebView: InAppWebView

  /// 未完善，缺少androidx.webkit.ScriptHandler
  // private contentWorldsCreatorScript: ScriptHandler

  /// 缺少android.webkit.WebView
  // public webView: WebView
  //
  // constructor(webView: WebView) {
  //   this.webView = webView
  // }

  constructor(inAppWebView: InAppWebView) {
    this.inAppWebView = inAppWebView;
  }

  public static escapeCode(code: string): string {
    // let escapedCode: string = JSONObject.quote(code);
    // escapedCode = escapedCode.substring(1, escapedCode.length() - 1);
    // return escapedCode;
    return ""
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
    // if (this.contentWorlds.size() == 1) {
    //   return "";
    // }
    //
    // StringBuilder source = new StringBuilder();
    // LinkedHashSet<PluginScript> pluginScriptsRequired = this.getPluginScriptsRequiredInAllContentWorlds();
    // for (PluginScript script : pluginScriptsRequired) {
    //   source.append(script.getSource());
    // }
    // List<String> contentWorldsNames = new ArrayList<>();
    // for (ContentWorld contentWorld : this.contentWorlds) {
    // if (contentWorld.equals(ContentWorld.PAGE)) {
    //   continue;
    // }
    // contentWorldsNames.add("'" + escapeContentWorldName(contentWorld.getName()) + "'");
    // }
    //
    // return CONTENT_WORLDS_GENERATOR_JS_SOURCE
    //   .replace(PluginScriptsUtil.VAR_CONTENT_WORLD_NAME_ARRAY, TextUtils.join(", ", contentWorldsNames))
    //   .replace(PluginScriptsUtil.VAR_JSON_SOURCE_ENCODED, escapeCode(source.toString()));
    return ""
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
    // return this.pluginScripts.get(pluginScript.getInjectionTime()).add(pluginScript);
    return true
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
    // this.userOnlyScripts.get(UserScriptInjectionTime.AT_DOCUMENT_START).clear();
    // this.userOnlyScripts.get(UserScriptInjectionTime.AT_DOCUMENT_END).clear();
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
    // this.pluginScripts.get(UserScriptInjectionTime.AT_DOCUMENT_START).clear();
    // this.pluginScripts.get(UserScriptInjectionTime.AT_DOCUMENT_END).clear();
  }

  addUserOnlyScripts(userOnlyScripts: Array<UserScript>) {

  }

  public dispose(): void {
    // if (WebViewFeature.isFeatureSupported(WebViewFeature.DOCUMENT_START_SCRIPT) && contentWorldsCreatorScript != null) {
    //   contentWorldsCreatorScript.remove();
    // }
    this.removeAllUserOnlyScripts();
    this.removeAllPluginScripts();
    // this.webView = null;
  }
}