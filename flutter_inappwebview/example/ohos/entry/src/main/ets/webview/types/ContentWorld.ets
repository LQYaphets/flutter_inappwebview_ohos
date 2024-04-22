export default class ContentWorld {
  private name: string | null

  static PAGE: ContentWorld = new ContentWorld("page");

  public static DEFAULT_CLIENT: ContentWorld = new ContentWorld("defaultClient");

  constructor(name: string) { this.name = name; }

  public static world(name: string): ContentWorld { return new ContentWorld(name); }

  public static fromMap(map: Map<String, Object>): ContentWorld | null {
    if (map == null) {
    return null;
    }
    let name: string = map.get("name") as string;
    // assert this.name != null;
    return new ContentWorld(name);
  }

  public getName(): string {
    return this.name!;
  }

  public setName(name: string): void {
    this.name = name;
  }

  public equals(o: Object): boolean {
    if (this == o) return true;
    // if (o == null || getClass() != o.getClass()) return false;

    let that: ContentWorld = o as ContentWorld;

    return this.name!.indexOf(that.name!) != -1;
  }
}