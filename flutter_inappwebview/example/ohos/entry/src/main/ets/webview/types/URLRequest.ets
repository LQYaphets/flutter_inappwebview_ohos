export default class URLRequest {
  private url: string;
  private method: string;
  private body: ArrayBuffer;
  private headers: Map<string, string>;

  constructor(url: string, method: string, body: ArrayBuffer, headers: Map<string, string>) {
    this.url = url;
    this.method = method;
    this.body = body;
    this.headers = headers;
  }

  getUrl(): string {
    return this.url;
  }

  setUrl(url: string): void {
    this.url = url;
  }

  getMethod(): string {
    return this.method;
  }

  setMethod(method: string) {
    this.method = method;
  }

  getBody(): ArrayBuffer {
    return this.body;
  }

  setBody(body: ArrayBuffer) {
    this.body = body;
  }

  getHeaders(): Map<string, string> {
    return this.headers;
  }

  setHeaders(headers: Map<string, string>) {
    this.headers = headers;
  }

  static fromMap(map: Map<string, ESObject>): URLRequest | null {
    if (map == null) {
      return null;
    }
    let url = map.get("url") as string;
    if (url == null) {
      url = "about:blank";
    }
    let method = map.get("method") as string;
    let body = map.get("body") as ArrayBuffer;
    let headers: Map<string, string> = map.get("headers");
    return new URLRequest(url, method, body, headers);
  }

  public toMap(): Map<string, ESObject> {
    let urlRequestMap: Map<string, ESObject> = new Map<string, ESObject>();
    urlRequestMap.set("url", this.url);
    urlRequestMap.set("method", this.method);
    urlRequestMap.set("headers", this.headers);
    urlRequestMap.set("body", this.body);
    urlRequestMap.set("allowsCellularAccess", null);
    urlRequestMap.set("allowsConstrainedNetworkAccess", null);
    urlRequestMap.set("allowsExpensiveNetworkAccess", null);
    urlRequestMap.set("cachePolicy", null);
    urlRequestMap.set("httpShouldHandleCookies", null);
    urlRequestMap.set("httpShouldUsePipelining", null);
    urlRequestMap.set("networkServiceType", null);
    urlRequestMap.set("timeoutInterval", null);
    urlRequestMap.set("mainDocumentURL", null);
    urlRequestMap.set("assumesHTTP3Capable", null);
    urlRequestMap.set("attribution", null);
    return urlRequestMap;
  }
}