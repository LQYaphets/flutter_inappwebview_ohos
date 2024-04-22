export default class WebMessagePortCompatExt {
  private index: number | null = null

  private webMessageChannelId: string | null = null

  constructor(index: number, webMessageChannelId: string) {
    this.index = index
    this.webMessageChannelId = webMessageChannelId
  }

  public static fromMap(map: Map<string, ESObject>): WebMessagePortCompatExt | null {
    if (map == null) {
      return null;
    }
    let index: number = map.get("index") as number;
    let webMessageChannelId: string = map.get("webMessageChannelId") as string;
    return new WebMessagePortCompatExt(index, webMessageChannelId);
  }

  public toMap(): Map<string, ESObject> {
    let proxyRuleMap: Map<string, ESObject> = new Map<string, ESObject>()
    proxyRuleMap.set("index", this.index);
    proxyRuleMap.set("webMessageChannelId", this.webMessageChannelId);
    return proxyRuleMap;
  }

  public getIndex(): number { return this.index!; }

  public setIndex(index: number): void { this.index = index; }

  public getWebMessageChannelId(): string { return this.webMessageChannelId!; }

  public setWebMessageChannelId(webMessageChannelId: string): void {
    this.webMessageChannelId = webMessageChannelId;
  }

  public equals(o: ESObject): boolean {
    if (this == o) return true;
    // if (o == null || getClass() != o.getClass()) return false;

    let that: WebMessagePortCompatExt = o as WebMessagePortCompatExt;

    if (this.index != that.index) return false;
    return this.webMessageChannelId != that.webMessageChannelId;
  }

  public hashCode(): number {
    let result: number = this.index!;
    // result = 31 * result + this.webMessageChannelId!.hashCode();
    return result;
  }

  public toString(): string {
    return "WebMessagePortCompatExt{" +
      "index=" + this.index +
      ", webMessageChannelId='" + this.webMessageChannelId + '\'' +
      '}';
  }
}