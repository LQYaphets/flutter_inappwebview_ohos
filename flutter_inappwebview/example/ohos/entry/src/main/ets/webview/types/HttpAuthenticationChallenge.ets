import { Any } from '@ohos/flutter_ohos';
import URLAuthenticationChallenge from './URLAuthenticationChallenge';
import URLCredential from './URLCredential';
import URLProtectionSpace from './URLProtectionSpace';

export default class HttpAuthenticationChallenge extends URLAuthenticationChallenge {
  private previousFailureCount: number
  proposedCredential: URLCredential | null

  constructor(protectionSpace: URLProtectionSpace, previousFailureCount: number, proposedCredential: URLCredential) {
    super(protectionSpace)
    this.previousFailureCount = previousFailureCount
    this.proposedCredential = proposedCredential
  }

  public toMap(): Map<string, Any> {
    let challengeMap: Map<string, Any> = super.toMap();
    challengeMap.set("previousFailureCount", this.previousFailureCount);
    challengeMap.set("proposedCredential", (this.proposedCredential != null) ? this.proposedCredential.toMap() : null);
    challengeMap.set("failureResponse", null);
    challengeMap.set("error", null);
    return challengeMap;
  }

  public getPreviousFailureCount(): number {
    return this.previousFailureCount;
  }

  public setPreviousFailureCount(previousFailureCount: number): void {
    this.previousFailureCount = previousFailureCount;
  }

  public getProposedCredential(): URLCredential | null {
    return this.proposedCredential;
  }

  public setProposedCredential(proposedCredential: URLCredential | null): void {
    this.proposedCredential = proposedCredential;
  }

  public toString(): string {
    return "HttpAuthenticationChallenge{" +
      "previousFailureCount=" + this.previousFailureCount +
      ", proposedCredential=" + this.proposedCredential +
      "} " + super.toString();
  }
}