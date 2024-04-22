import InAppWebView from '../webview/in_app_webview/InAppWebView';
import { Disposable } from './Disposable';
import PluginScript from './PluginScript';
import UserScript from './UserScript';

export default class UserContentController implements Disposable {
  private inAppWebView: InAppWebView

  constructor(inAppWebView: InAppWebView) {
    this.inAppWebView = inAppWebView;
  }

  addPluginScript(pluginScript: PluginScript) {

  }

  addPluginScripts(pluginScripts: Array<PluginScript>) {

  }

  addUserOnlyScripts(userOnlyScripts: Array<UserScript>) {

  }

  dispose(): void {

  }
}