export default class HitTestResult {
  private type: number
  private extra: string | null

  constructor(type: number, extra: string | null) {
    this.type = type
    this.extra = extra
  }

  // public static fromWebViewHitTestResult(hitTestResult: WebView.HitTestResult | null): HitTestResult | null {
  //   if (hitTestResult == null) {
  //     return null;
  //   }
  //
  //   return new HitTestResult(hitTestResult.getType(), hitTestResult.getExtra());
  // }

  public getType(): number {
    return this.type;
  }

  public setType(type: number): void {
    this.type = type;
  }

  public getExtra(): string | null {
    return this.extra;
  }

  public setExtra(extra: string | null): void {
    this.extra = extra;
  }

  public toMap(): Map<string, ESObject> {
    let hitTestResultMap: Map<string, ESObject> = new Map<string, ESObject>()
    hitTestResultMap.set("type", this.type);
    hitTestResultMap.set("extra", this.extra);
    return hitTestResultMap;
  }

  public equals(o: ESObject): boolean {
    if (this == o) return true;
    // if (o == null || getClass() != o.getClass()) return false;

    let that: HitTestResult = o as HitTestResult;

    if (this.type != that.type) return false;
    return this.extra != null ? this.extra.includes(that.extra??'') : that.extra == null;
  }

  public hashCode(): number {
    let result: number = this.type;
    // result = 31 * result + (this.extra != null ? this.extra.hashCode() : 0);
    return result;
  }

  public toString(): string {
    return "HitTestResultMap{" +
      "type=" + this.type +
      ", extra='" + this.extra + '\'' +
      '}';
  }
}