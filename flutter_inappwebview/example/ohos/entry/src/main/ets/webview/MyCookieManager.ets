import ChannelDelegateImpl from './types/ChannelDelegateImpl';
import web_webview from '@ohos.web.webview';
import InAppWebViewFlutterPlugin from './InAppWebViewFlutterPlugin';
import { Any, MethodCall, MethodChannel } from '@ohos/flutter_ohos';
import { MethodResult } from '@ohos/flutter_ohos/src/main/ets/plugin/common/MethodChannel';
import business_error from '@ohos.base'
import Intl from '@ohos.intl';
import { List } from '@kit.ArkTS';
import systemDateTime from '@ohos.systemDateTime';

const LOG_TAG = "MyCookieManager"
const METHOD_CHANNEL_NAME = "com.pichillilorenzo/flutter_inappwebview_cookiemanager"

export default class MyCookieManager extends ChannelDelegateImpl {
  public plugin: InAppWebViewFlutterPlugin | null

  constructor(plugin: InAppWebViewFlutterPlugin) {
    super(new MethodChannel(plugin.messenger!, METHOD_CHANNEL_NAME))
    this.plugin = plugin
  }


  public async onMethodCall(call: MethodCall, result: MethodResult): Promise<void> {

    switch (call.method) {
      case "setCookie":
        {
          let url: string = call.argument("url") as string;
          let name: string = call.argument("name") as string;
          let value: string = call.argument("value") as string;
          let domain: string = call.argument("domain") as string;
          let path: string = call.argument("path") as string;
          let expiresDateString: string = call.argument("expiresDate") as string;
          let expiresDate: number | null = (expiresDateString != null ? new Number(expiresDateString).valueOf() : null);
          let maxAge: number = call.argument("maxAge") as number;
          let isSecure: boolean = call.argument("isSecure") as boolean;
          let isHttpOnly: boolean = call.argument("isHttpOnly") as boolean;
          let sameSite: string = call.argument("sameSite") as string;
          this.setCookie(url,
                  name,
                  value,
                  domain,
                  path,
                  expiresDate,
                  maxAge,
                  isSecure,
                  isHttpOnly,
                  sameSite,
                  result);
        }
        break;
      case "getCookies":
        result.success(await this.getCookies(call.argument("url") as string));
        break;
      case "deleteCookie":
        {
          let url: string = call.argument("url") as string;
          let name: string = call.argument("name") as string;
          let domain: string = call.argument("domain") as string;
          let path: string = call.argument("path") as string;
          this.deleteCookie(url, name, domain, path, result);
        }
        break;
      case "deleteCookies":
        {
          let url: string = call.argument("url") as string;
          let domain: string = call.argument("domain") as string;
          let path: string = call.argument("path") as string;
          this.deleteCookies(url, domain, path, result);
        }
        break;
      case "deleteAllCookies":
        this.deleteAllCookies(result);
        break;
      case "removeSessionCookies":
        this.removeSessionCookies(result);
        break;
      default:
        result.notImplemented();
    }
  }

  public setCookie(url: string, name: string, value: string, domain: string, path: string,
                   expiresDate: number | null, maxAge: number, isSecure: boolean, isHttpOnly: boolean, sameSite: string, result: MethodResult): void {

    try {
      web_webview.WebCookieManager.configCookie(url, name + "=" + value)
      web_webview.WebCookieManager.configCookie(url, "Path=" + path)
      if (domain != null) web_webview.WebCookieManager.configCookie(url, "Domain=" + domain)
      if (expiresDate != null) web_webview.WebCookieManager.configCookie(url, "Expires=" + this.getCookieExpirationDate(expiresDate))
      if (maxAge != null) web_webview.WebCookieManager.configCookie(url, "Max-Age=" + maxAge.toString())
      if (isSecure != null && isSecure) web_webview.WebCookieManager.configCookie(url, "Secure=" + isSecure)
      if (isHttpOnly != null && isHttpOnly) web_webview.WebCookieManager.configCookie(url, "HttpOnly=" + isHttpOnly)
      if (sameSite != null) web_webview.WebCookieManager.configCookie(url, "SameSite=" + sameSite)
      result.success(true)
    } catch (error) {
      let e: business_error.BusinessError = error as business_error.BusinessError
      console.error(`ErrorCode: ${e.code},  Message: ${e.message}`)
      result.success(false)
    }

  }

  public async getCookies(url: string): Promise<List<Map<string, Any>>> {
    let cookieListMap: List<Map<string, Any>> = new List<Map<string, Any>>()

    let cookiesString: string = web_webview.WebCookieManager.fetchCookieSync(url)

    let cookieMap: Map<string, Any> = new Map<string, Any>()
    cookieMap.set("expiresDate", null);
    cookieMap.set("isSessionOnly", null);
    cookieMap.set("domain", null);
    cookieMap.set("sameSite", null);
    cookieMap.set("isSecure", false);
    cookieMap.set("isHttpOnly", false);
    cookieMap.set("path", null);
    for(let cookiesValue of cookiesString.split(";")) {
      if (cookiesValue.split("=")[0].trim().localeCompare("Expires", undefined, { sensitivity: 'accent' })) {
        try{
          let dateFormat = new Intl.DateTimeFormat("en-US", {weekday: 'short', day: '2-digit',
            month: '2-digit', year: 'numeric', hour: '2-digit', minute: '2-digit', second: '2-digit', timeZone: 'GMT'})
          let expiryDate: Date = new Date(dateFormat.format(new Date(cookiesValue.split("=")[1].trim())))
          if(expiryDate != null) {
            cookieMap.set("expiresDate", expiryDate.getTime());
          }
        } catch (e) {
          console.error(LOG_TAG, "", e);
        }
      } else if (cookiesValue.split("=")[0].trim().localeCompare("Max-Age", undefined, { sensitivity: 'accent' })) {
        try {
          let maxAge: number = Number(cookiesValue.split("=")[1].trim());
          cookieMap.set("expiresDate", await systemDateTime.getCurrentTime(false) + maxAge)
        } catch (e) {
          console.error(LOG_TAG, "", e)
        }
      } else if (cookiesValue.split("=")[0].trim().localeCompare("Domain", undefined, { sensitivity: 'accent' })) {
        cookieMap.set("domain", cookiesValue.split("=")[1].trim())
      } else if (cookiesValue.split("=")[0].trim().localeCompare("SameSite", undefined, { sensitivity: 'accent' })) {
        cookieMap.set("sameSite", cookiesValue.split("=")[1].trim())
      } else if (cookiesValue.split("=")[0].trim().localeCompare("Secure", undefined, { sensitivity: 'accent' })) {
        cookieMap.set("isSecure", true)
      } else if (cookiesValue.split("=")[0].trim().localeCompare("HttpOnly", undefined, { sensitivity: 'accent' })) {
        cookieMap.set("isHttpOnly", true)
      } else if (cookiesValue.split("=")[0].trim().localeCompare("Path", undefined, { sensitivity: 'accent' })) {
        cookieMap.set("path", cookiesValue.split("=")[1].trim())
      } else {
        cookieMap.set("name", cookiesValue.split("=")[0].trim())
        cookieMap.set("value", cookiesValue.split("=")[1].trim())
      }
    }

    cookieListMap.add(cookieMap)

    return cookieListMap
  }

  public deleteCookie(url: string, name: string, domain: string, path: string, result: MethodResult): void {
    try {
      web_webview.WebCookieManager.configCookie(url, name + "=")
      web_webview.WebCookieManager.configCookie(url, "Path=" + path)
      web_webview.WebCookieManager.configCookie(url, "Max-Age=-1")
      if (domain != null) web_webview.WebCookieManager.configCookie(url, "Domain=" + domain)
      result.success(true)
    } catch (error) {
      let e: business_error.BusinessError = error as business_error.BusinessError
      console.error(`ErrorCode: ${e.code},  Message: ${e.message}`)
    }
  }

  public deleteCookies(url: string, domain: string, path: string, result: MethodResult): void {
    let cookiesString: string = web_webview.WebCookieManager.fetchCookieSync(url)
    if (cookiesString != null) {
      for(let cookiesValue of cookiesString.split(";")) {
        let nameValue: string[] = cookiesValue.split("=", 2)
        let name: string = nameValue[0].trim()

        web_webview.WebCookieManager.configCookie(url, name + "=")
        web_webview.WebCookieManager.configCookie(url, "Path=" + path)
        web_webview.WebCookieManager.configCookie(url, "Max-Age=-1")
        if (domain != null) web_webview.WebCookieManager.configCookie(url, "Domain=" + domain)
      }
    }

    result.success(true);
  }

  public deleteAllCookies(result: MethodResult): void {
    try {
      web_webview.WebCookieManager.clearAllCookiesSync()
      result.success(true)
    } catch (e) {
      console.error(LOG_TAG, e)
    }
  }

  public removeSessionCookies(result: MethodResult): void {
    try {
      web_webview.WebCookieManager.clearSessionCookieSync()
      result.success(true)
    } catch (e) {
      console.error(LOG_TAG, e)
    }
  }

  public getCookieExpirationDate(timestamp: number): string {
    let dateFormat = new Intl.DateTimeFormat("en-US", {weekday: 'short', day: '2-digit',
      month: '2-digit', year: 'numeric', hour: '2-digit', minute: '2-digit', second: '2-digit', timeZone: 'GMT'})
    return dateFormat.format(new Date(timestamp))
  }

  public dispose(): void {
    super.dispose();
    this.plugin = null;
  }
}