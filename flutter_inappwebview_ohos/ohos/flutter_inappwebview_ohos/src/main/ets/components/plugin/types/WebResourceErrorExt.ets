import { Any } from '@ohos/flutter_ohos'

export default class WebResourceErrorExt {
  private type: number
  private description: string

  constructor(type: number, description: string) {
    this.type = type
    this.description = description
  }

  public toMap(): Map<string, Any> {
    let webResourceErrorMap: Map<string, Any> = new Map<string, Any>();
    webResourceErrorMap.set("type", this.getType());
    webResourceErrorMap.set("description", this.getDescription());
    return webResourceErrorMap;
  }

  static fromWebResourceError(error: WebResourceError) {
    return new WebResourceErrorExt(error.getErrorCode(), error.getErrorInfo());
  }

  public getType(): number {
    return this.type;
  }

  public setType(type: number): void {
    this.type = type;
  }

  public getDescription(): string {
    return this.description;
  }

  public setDescription(description: string): void {
    this.description = description;
  }

  public toString(): string {
    return "WebResourceErrorExt{" +
      "type=" + this.type +
      ", description='" + this.description + '\'' +
      '}';
  }
}