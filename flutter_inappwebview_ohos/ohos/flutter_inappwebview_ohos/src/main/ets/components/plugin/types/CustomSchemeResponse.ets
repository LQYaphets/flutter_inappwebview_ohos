import { Any } from '@ohos/flutter_ohos';

export default class CustomSchemeResponse {
  private data: ArrayBuffer;
  private contentType: string;
  private contentEncoding: string;

  constructor(data: ArrayBuffer, contentType: string, contentEncoding: string) {
    this.data = data;
    this.contentType = contentType;
    this.contentEncoding = contentEncoding;
  }

  static fromMap(map: Map<string, Any>): CustomSchemeResponse | null {
    if (map == null) {
      return null;
    }
    let data: ArrayBuffer = map.get("data");
    let contentType: string = map.get("contentType");
    let contentEncoding: string = map.get("contentEncoding");
    return new CustomSchemeResponse(data, contentType, contentEncoding);
  }

  getData(): ArrayBuffer {
    return this.data;
  }

  setData(data: ArrayBuffer) {
    this.data = data;
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
}