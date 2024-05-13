import { Any } from '@ohos/flutter_ohos';

export default class DownloadStartRequest {
  private url: string;
  private userAgent: string;
  private contentDisposition: string;
  private mimeType: string;
  private contentLength: number;
  private suggestedFilename: string | null;
  private textEncodingName: string | null = null;

  constructor(url: string, userAgent: string, contentDisposition: string, mimeType: string, contentLength: number,
              suggestedFilename: string | null, textEncodingName: string | null) {
    this.url = url;
    this.userAgent = userAgent;
    this.contentDisposition = contentDisposition;
    this.mimeType = mimeType;
    this.contentLength = contentLength;
    this.suggestedFilename = suggestedFilename;
    this.textEncodingName = textEncodingName;
  }

  toMap(): Map<string, Any> {
    let obj: Map<string, Any> = new Map<string, Any>();
    obj.set("url", this.url);
    obj.set("userAgent", this.userAgent);
    obj.set("contentDisposition", this.contentDisposition);
    obj.set("mimeType", this.mimeType);
    obj.set("contentLength", this.contentLength);
    obj.set("suggestedFilename", this.suggestedFilename);
    obj.set("textEncodingName", this.textEncodingName);
    return obj;
  }

  getUrl(): string {
    return this.url;
  }

  setUrl(url: string) {
    this.url = url;
  }

  getUserAgent(): string {
    return this.userAgent;
  }

  setUserAgent(userAgent: string) {
    this.userAgent = userAgent;
  }

  getContentDisposition(): string {
    return this.contentDisposition;
  }

  setContentDisposition(contentDisposition: string) {
    this.contentDisposition = contentDisposition;
  }

  getMimeType(): string {
    return this.mimeType;
  }

  setMimeType(mimeType: string) {
    this.mimeType = mimeType;
  }

  getContentLength(): number {
    return this.contentLength;
  }

  setContentLength(contentLength: number) {
    this.contentLength = contentLength;
  }

  getSuggestedFilename(): string | null {
    return this.suggestedFilename;
  }

  setSuggestedFilename(suggestedFilename: string) {
    this.suggestedFilename = suggestedFilename;
  }

  getTextEncodingName(): string | null {
    return this.textEncodingName;
  }

  setTextEncodingName(textEncodingName: string) {
    this.textEncodingName = textEncodingName;
  }
}