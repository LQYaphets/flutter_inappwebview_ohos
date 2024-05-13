import { Any } from '@ohos/flutter_ohos'
import URLProtectionSpace from './URLProtectionSpace'

export default class URLAuthenticationChallenge {
  private protectionSpace: URLProtectionSpace

  constructor(protectionSpace: URLProtectionSpace) {
    this.protectionSpace = protectionSpace
  }

  public toMap(): Map<string, Any> {
    let challengeMap: Map<string, Any> = new Map<string, Any>();
    challengeMap.set("protectionSpace", this.protectionSpace.toMap());
    return challengeMap;
  }

  public getProtectionSpace(): URLProtectionSpace {
    return this.protectionSpace;
  }

  public setProtectionSpace(protectionSpace: URLProtectionSpace): void {
    this.protectionSpace = protectionSpace;
  }

  public toString(): string {
    return "URLAuthenticationChallenge{" +
      "protectionSpace=" + this.protectionSpace +
      '}';
  }
}