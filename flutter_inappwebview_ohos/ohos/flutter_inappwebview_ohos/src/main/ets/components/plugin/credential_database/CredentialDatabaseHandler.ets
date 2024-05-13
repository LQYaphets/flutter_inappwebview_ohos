import { Any, MethodCall, MethodChannel } from '@ohos/flutter_ohos';
import InAppWebViewFlutterPlugin from '../InAppWebViewFlutterPlugin';
import ChannelDelegateImpl from '../types/ChannelDelegateImpl';
import CredentialDatabase from './CredentialDatabase';
import common from '@ohos.app.ability.common';
import { MethodResult } from '@ohos/flutter_ohos/src/main/ets/plugin/common/MethodChannel';
import List from '@ohos.util.List';
import URLProtectionSpace from '../types/URLProtectionSpace';

const TAG = "CredentialDatabaseHandler"
const METHOD_CHANNEL_NAME = "com.pichillilorenzo/flutter_inappwebview_credential_database"

export default class CredentialDatabaseHandler extends ChannelDelegateImpl {
  public credentialDatabase: CredentialDatabase | null = null
  public plugin: InAppWebViewFlutterPlugin | null

  constructor(plugin: InAppWebViewFlutterPlugin) {
    super(new MethodChannel(plugin.messenger!, METHOD_CHANNEL_NAME))
    this.plugin = plugin
  }

  public init(plugin: InAppWebViewFlutterPlugin): void {
    if (this.credentialDatabase == null) {
      this.credentialDatabase = CredentialDatabase.getInstance(plugin.applicationContext!);
    }
  }

  public onMethodCall(call: MethodCall, result: MethodResult): void {
    if (this.plugin != null) {
      this.init(this.plugin);
    }

    switch (call.method) {
      case "getAllAuthCredentials":
        {
          let allCredentials: List<Map<string, Any>> = new List<Map<string, Any>>();
          // if (this.credentialDatabase != null) {
          //   let protectionSpaces: List<URLProtectionSpace> = credentialDatabase.protectionSpaceDao.getAll();
          //   for (URLProtectionSpace protectionSpace : protectionSpaces) {
          //     List<Map<String, Object>> credentials = new ArrayList<>();
          //     for (URLCredential credential : credentialDatabase.credentialDao.getAllByProtectionSpaceId(protectionSpace.getId())) {
          //       credentials.add(credential.toMap());
          //     }
          //     Map<String, Object> obj = new HashMap<>();
          //     obj.put("protectionSpace", protectionSpace.toMap());
          //     obj.put("credentials", credentials);
          //     allCredentials.add(obj);
          //   }
          // }
          result.success(allCredentials);
        }
        break;
      case "getHttpAuthCredentials":
        {
          let credentials: List<Map<string, Any>> = new List<Map<string, Any>>();
          if (this.credentialDatabase != null) {
            let host: string = call.argument("host") as string;
            let protocol: string = call.argument("protocol") as string;
            let realm: string = call.argument("realm") as string;
            let port: number = call.argument("port") as number;

            // for (URLCredential credential : credentialDatabase.getHttpAuthCredentials(host, protocol, realm, port)) {
            //   credentials.add(credential.toMap());
            // }
          }
          result.success(credentials);
        }
        break;
      case "setHttpAuthCredential":
        {
          if (this.credentialDatabase != null) {
            let host: string = call.argument("host") as string;
            let protocol: string = call.argument("protocol") as string;
            let realm: string = call.argument("realm") as string;
            let port: number = call.argument("port") as number;
            let username: string = call.argument("username") as string;
            let password: string = call.argument("password") as string;

            // this.credentialDatabase.setHttpAuthCredential(host, protocol, realm, port, username, password);
            result.success(true);
          } else {
            result.success(false);
          }
        }
        break;
      case "removeHttpAuthCredential":
        {
          if (this.credentialDatabase != null) {
            let host = call.argument("host") as string;
            let protocol: string = call.argument("protocol") as string;
            let realm: string = call.argument("realm") as string;
            let port: number = call.argument("port") as number;
            let username: string = call.argument("username") as string;
            let password: string = call.argument("password") as string;

            // this.credentialDatabase.removeHttpAuthCredential(host, protocol, realm, port, username, password);
            result.success(true);
          } else {
            result.success(false);
          }
        }
        break;
      case "removeHttpAuthCredentials":
        {
          if (this.credentialDatabase != null) {
            let host: string = call.argument("host") as string;
            let protocol: string = call.argument("protocol") as string;
            let realm: string = call.argument("realm") as string;
            let port: number = call.argument("port") as number;

            // this.credentialDatabase.removeHttpAuthCredentials(host, protocol, realm, port);
            result.success(true);
          } else {
            result.success(false);
          }
        }
        break;
      case "clearAllAuthCredentials":
        if (this.credentialDatabase != null) {
          // this.credentialDatabase.clearAllAuthCredentials();
          if (this.plugin != null && this.plugin.applicationContext != null) {
            // WebViewDatabase.getInstance(this.plugin.applicationContext).clearHttpAuthUsernamePassword();
          }
          result.success(true);
        } else {
          result.success(false);
        }
        break;
      default:
        result.notImplemented();
    }
  }

  public dispose(): void {
    super.dispose();
    this.plugin = null;
    this.credentialDatabase = null;
  }
}