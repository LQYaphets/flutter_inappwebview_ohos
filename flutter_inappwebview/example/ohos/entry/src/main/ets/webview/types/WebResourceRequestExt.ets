import { Any } from '@ohos/flutter_ohos'

export default class WebResourceRequestExt {
  private url: string
  private headers: Map<string, string>
  private isRedirect: boolean
  private hasGesture: boolean
  private isForMainFrame: boolean
  private method: string

  constructor(url: string, headers: Map<string, string>, isRedirect: boolean, hasGesture: boolean, isForMainFrame: boolean, method: string) {
    this.url = url
    this.headers = headers
    this.isRedirect = isRedirect
    this.hasGesture = hasGesture
    this.isForMainFrame = isForMainFrame
    this.method = method
  }

  public static fromWebResourceRequest(request: WebResourceRequest): WebResourceRequestExt {
    let headers = new Map<string, string>()
    for (let header of request.getRequestHeader()) {
      headers.set(header.headerKey, header.headerValue)
    }
    return new WebResourceRequestExt(request.getRequestUrl(),
      headers,
      request.isRedirect(),
      request.isRequestGesture(),
      request.isMainFrame(),
      request.getRequestMethod()
    );
  }

  public toMap(): Map<string, Any> {
    let webResourceRequestMap: Map<string, Any> = new Map<string, Any>();
    webResourceRequestMap.set("url", this.url);
    webResourceRequestMap.set("headers", this.headers);
    webResourceRequestMap.set("isRedirect", this.isRedirect);
    webResourceRequestMap.set("hasGesture", this.hasGesture);
    webResourceRequestMap.set("isForMainFrame", this.isForMainFrame);
    webResourceRequestMap.set("method", this.method);
    return webResourceRequestMap;
  }

  public getUrl(): string {
    return this.url;
  }

  public setUrl(url: string): void {
    this.url = url;
  }

  public getHeaders(): Map<string, string> {
    return this.headers;
  }

  public setHeaders(headers: Map<string, string>): void {
    this.headers = headers;
  }

  public getRedirect(): boolean {
    return this.isRedirect;
  }

  public setRedirect(redirect: boolean): void {
    this.isRedirect = redirect;
  }

  public isHasGesture(): boolean {
    return this.hasGesture;
  }

  public setHasGesture(hasGesture: boolean): void {
    this.hasGesture = hasGesture;
  }

  public geForMainFrame(): boolean {
    return this.isForMainFrame;
  }

  public setForMainFrame(forMainFrame: boolean): void {
    this.isForMainFrame = forMainFrame;
  }

  public getMethod(): string {
    return this.method;
  }

  public setMethod(method: string): void {
    this.method = method;
  }

  public toString(): string {
    return "WebResourceRequestExt{" +
      "url=" + this.url +
      ", headers=" + this.headers +
      ", isRedirect=" + this.isRedirect +
      ", hasGesture=" + this.hasGesture +
      ", isForMainFrame=" + this.isForMainFrame +
      ", method='" + this.method + '\'' +
      '}';
  }
}