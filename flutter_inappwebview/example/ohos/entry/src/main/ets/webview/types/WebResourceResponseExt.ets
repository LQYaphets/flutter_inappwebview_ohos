import { StringUtils } from '@ohos/flutter_ohos';

export default class WebResourceResponseExt {
  private contentType: string;
  private contentEncoding: string;
  private statusCode: number
  private reasonPhrase: string;
  private headers: Map<string, string>;
  private data: ArrayBuffer;

  constructor(contentType: string, contentEncoding: string, statusCode: number, reasonPhrase: string, headers: Map<string, string>, data: ArrayBuffer) {
    this.contentType = contentType;
    this.contentEncoding = contentEncoding;
    this.statusCode = statusCode;
    this.reasonPhrase = reasonPhrase;
    this.headers = headers;
    this.data = data;
  }

  static fromWebResourceResponse(response: WebResourceResponse): WebResourceResponseExt {
    let headers = new Map<string, string>()
    for (let header of response.getResponseHeader()) {
      headers.set(header.headerKey, header.headerValue)
    }
    return new WebResourceResponseExt(response.getResponseMimeType(),
      response.getResponseEncoding(),
      response.getResponseCode(),
      response.getReasonMessage(),
      headers,
      StringUtils.stringToArrayBuffer(response.getResponseData())
    );
  }

  static fromMap(map: Map<string, ESObject>): WebResourceResponseExt | null {
    if (map == null) {
      return null;
    }
    let contentType: string = map.get("contentType");
    let contentEncoding: string = map.get("contentEncoding");
    let statusCode: number = map.get("statusCode");
    let reasonPhrase: string = map.get("reasonPhrase");
    let headers: Map<string, string> = map.get("headers");
    let data: ArrayBuffer = map.get("data");
    return new WebResourceResponseExt(contentType, contentEncoding, statusCode, reasonPhrase, headers, data);
  }

  toMap(): Map<string, Object> {
    let webResourceResponseMap: Map<string, ESObject> = new Map<string, ESObject>();
    webResourceResponseMap.set("contentType", this.contentType);
    webResourceResponseMap.set("contentEncoding", this.contentEncoding);
    webResourceResponseMap.set("statusCode", this.statusCode);
    webResourceResponseMap.set("reasonPhrase", this.reasonPhrase);
    webResourceResponseMap.set("headers", this.headers);
    webResourceResponseMap.set("data", this.data);
    return webResourceResponseMap;
  }


  getContentType(): string {
    return this.contentType;
  }

  setContentType(contentType: string) {
    this.contentType = contentType;
  }

  getContentEncoding(): string {
    return this.contentEncoding;
  }

  setContentEncoding(contentEncoding: string) {
    this.contentEncoding = contentEncoding;
  }

  getStatusCode(): number {
    return this.statusCode;
  }

  setStatusCode(statusCode: number) {
    this.statusCode = statusCode;
  }

  getReasonPhrase(): string {
    return this.reasonPhrase;
  }

  setReasonPhrase(reasonPhrase: string) {
    this.reasonPhrase = reasonPhrase;
  }

  getHeaders(): Map<string, string> {
    return this.headers;
  }

  setHeaders(headers: Map<string, string>) {
    this.headers = headers;
  }

  getData(): ArrayBuffer {
    return this.data;
  }

  setData(data: ArrayBuffer) {
    this.data = data;
  }
}