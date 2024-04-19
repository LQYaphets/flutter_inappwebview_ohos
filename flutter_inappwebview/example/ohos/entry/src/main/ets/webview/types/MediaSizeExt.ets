export class MediaSizeExt {
  private id: string | null = null
  private label: string | null = null
  private widthMils: number | null = null
  private heightMils: number | null = null

  constructor(id: string | null = null, label: string | null = null, widthMils: number, heightMils: number) {
    this.id = id
    this.label = label
    this.widthMils= widthMils
    this.heightMils = heightMils
  }

  /// 缺少android.print.PrintAttributes
  // public static fromMediaSize(mediaSize: PrintAttributes.MediaSize): MediaSizeExt | null {
  //   if (mediaSize == null) {
  //     return null;
  //   }
  //   return new MediaSizeExt(
  //     mediaSize.getId(),
  //     null,
  //     mediaSize.getHeightMils(),
  //     mediaSize.getWidthMils()
  //   );
  // }

  public static fromMap(map: Map<String, Object>): MediaSizeExt | null{
    if (map == null) {
      return null;
    }
    let id: string = map.get("id") as string
    let label: string = map.get("label") as string
    let widthMils: number = map.get("widthMils") as number
    let heightMils: number = map.get("heightMils") as number
    return new MediaSizeExt(id, label, widthMils, heightMils)
  }

  // public toMediaSize(): PrintAttributes.MediaSize {
  //   return new PrintAttributes.MediaSize(id, "Custom", widthMils, heightMils);
  // }

  public toMap(): Map<String, Object> {
    let obj: Map<String, Object> = new Map<String, Object>()
    obj.set("id", this.id!)
    obj.set("label", this.label!)
    obj.set("heightMils", this.heightMils!)
    obj.set("widthMils", this.widthMils!)
    return obj
  }

  public getId(): string { return this.id! }

  public setId(id: string): void { this.id = id }

  public getLabel(): string { return this.label! }

  public setLabel(label: string): void { this.label = label }

  public getWidthMils(): number { return this.widthMils! }

  public setWidthMils(widthMils: number): void { this.widthMils = widthMils }

  public getHeightMils(): number { return this.heightMils! }

  public setHeightMils(heightMils: number) { this.heightMils = heightMils }

  public equals(o: Object): boolean {
    if (this == o) return true
    // if (o == null || getClass() != 0.getClass()) return false

    let that: MediaSizeExt = o as MediaSizeExt

    if (this.widthMils != that.widthMils) return false;
    if (this.heightMils != that.heightMils) return false;
    if (this.id?.indexOf(that.id!) == -1) return false;
    return this.label != null ? this.label?.indexOf(that.label!) == -1 : that.label == null
  }

  public hashCode(): number {
    // let result: number = this.id?.hashCode();
    // result = 31 * result + (this.label != null ? this.label.hashCode() : 0)
    // result = 31 * result + this.widthMils!
    // result = 31 * result + this.heightMils!
    // return result
    return 0
  }

  public toString(): string {
    return "MediaSizeExt{" +
      "id='" + this.id + '\'' +
      ", label='" + this.label + '\'' +
      ", widthMils=" + this.widthMils +
      ", heightMils=" + this.heightMils +
      '}';
  }
}