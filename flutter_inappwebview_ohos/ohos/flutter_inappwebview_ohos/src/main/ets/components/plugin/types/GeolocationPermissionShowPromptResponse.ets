import { Any } from '@ohos/flutter_ohos'

export default class GeolocationPermissionShowPromptResponse {
  private origin: string
  allow: boolean
  retain: boolean

  constructor(origin: string, allow: boolean, retain: boolean) {
    this.origin = origin
    this.allow = allow
    this.retain = retain
  }

  public static fromMap(map: Map<string, Any>): GeolocationPermissionShowPromptResponse | null {
    if (map == null) {
      return null;
    }
    let origin: string = map.get("origin") as string;
    let allow: boolean = map.get("allow") as boolean;
    let retain: boolean = map.get("retain") as boolean;
    return new GeolocationPermissionShowPromptResponse(origin, allow, retain);
  }

  public getOrigin(): string {
    return this.origin;
  }

  public setOrigin(origin: string): void {
    this.origin = origin;
  }

  public isAllow(): boolean {
    return this.allow;
  }

  public setAllow(allow: boolean): void {
    this.allow = allow;
  }

  public isRetain(): boolean {
    return this.retain;
  }

  public setRetain(retain: boolean): void {
    this.retain = retain;
  }

  public toString(): string {
    return "GeolocationPermissionShowPromptResponse{" +
      "origin='" + this.origin + '\'' +
      ", allow=" + this.allow +
      ", retain=" + this.retain +
      '}';
  }
}