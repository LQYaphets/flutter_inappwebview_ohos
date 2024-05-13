import { Any } from '@ohos/flutter_ohos'

export default class URLCredential {
  private id: number | null
  private username: string | null
  private password: string | null
  private protectionSpaceId: number | null

  constructor(id: number | null, username: string | null, password: string | null, protectionSpaceId: number | null) {
    this.id = id
    this.username = username
    this.password = password
    this.protectionSpaceId = protectionSpaceId
  }

  public toMap(): Map<string, Any> {
    let urlCredentialMap: Map<string, Any> = new Map<string, Any>();
    urlCredentialMap.set("username", this.username);
    urlCredentialMap.set("password", this.password);
    urlCredentialMap.set("certificates", null);
    urlCredentialMap.set("persistence", null);
    return urlCredentialMap;
  }

  public getId(): number | null {
    return this.id;
  }

  public setId(id: number | null): void {
    this.id = id;
  }

  public getUsername(): string | null {
    return this.username;
  }

  public setUsername(username: string | null) {
    this.username = username;
  }

  public getPassword(): string | null {
    return this.password;
  }

  public setPassword(password: string | null): void {
    this.password = password;
  }

  public getProtectionSpaceId(): number | null {
    return this.protectionSpaceId;
  }

  public setProtectionSpaceId(protectionSpaceId: number | null): void {
    this.protectionSpaceId = protectionSpaceId;
  }

  public toString(): string {
    return "URLCredential{" +
      "username='" + this.username + '\'' +
      ", password='" + this.password + '\'' +
      '}';
  }
}