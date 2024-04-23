export default class AndroidResource {

  private name: string
  private defType: string | null
  private defPackage: string | null

  constructor(name: string, defType: string | null, defPackage: string | null) {
    this.name = name
    this.defType = defType
    this.defPackage = defPackage
  }

  public static fromMap(map: Map<string, ESObject>): AndroidResource | null {
    if (map == null) {
      return null;
    }
    let name: string = map.get("name") as string;
    let defType: string = map.get("defType") as string;
    let defPackage: string = map.get("defPackage") as string;
    return new AndroidResource(name, defType, defPackage);
  }

  public toMap(): Map<string, ESObject> {
    let urlRequestMap: Map<string, ESObject> = new Map<string, ESObject>();
    urlRequestMap.set("name", this.name);
    urlRequestMap.set("defType", this.defType);
    urlRequestMap.set("defPackage", this.defPackage);
    return urlRequestMap;
  }

  public getName(): string {
    return this.name;
  }

  public setName(name: string): void {
    this.name = name;
  }

  public getDefType(): String {
    return this.defType??'';
  }

  public setDefType(defType: null): void {
    this.defType = defType;
  }

  public getDefPackage(): string {
    return this.defPackage??'';
  }

  public setDefPackage(defPackage: string): void {
    this.defPackage = defPackage;
  }

  public getIdentifier(ctx: Context): number {
    // return ctx.getResources().getIdentifier(name, defType, defPackage);
    return 0
  }

  public equals(o: ESObject): boolean {
    if (this == o) return true;
    // if (o == null || getClass() != o.getClass()) return false;

    let that: AndroidResource = o as AndroidResource;

    if (!this.name.includes(that.name)) return false;
    if (this.defType != null ? !this.defType.includes(that.defType??'') : that.defType != null) return false;
    return this.defPackage != null ? this.defPackage.includes(that.defPackage??'') : that.defPackage == null;
  }

  public hashCode(): number {
    // let result: number = this.name.hashCode();
    // result = 31 * result + (this.defType != null ? this.defType.hashCode() : 0);
    // result = 31 * result + (this.defPackage != null ? this.defPackage.hashCode() : 0);
    // return result;
    return 0
  }

  public toString(): string {
    return "AndroidResource{" +
      "name='" + this.name + '\'' +
      ", type='" + this.defType + '\'' +
      ", defPackage='" + this.defPackage + '\'' +
      '}';
  }
}