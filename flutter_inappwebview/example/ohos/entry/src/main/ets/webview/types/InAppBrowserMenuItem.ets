import Util from '../Util'
import AndroidResource from './OhosResource'

export default class InAppBrowserMenuItem {

  private id: number
  private title: string
  private order: number | null
  private icon: ESObject
  private iconColor: string | null
  private showAsAction: boolean

  constructor(id: number, title: string, order: number | null, icon: ESObject, iconColor: string | null, showAsAction: boolean) {
    this.id = id
    this.title = title
    this.order = order
    this.icon = icon
    this.iconColor = iconColor
    this.showAsAction = showAsAction
  }

  public static fromMap(map: Map<string, ESObject>): InAppBrowserMenuItem | null {
    if (map == null) {
      return null;
    }
    let id: number = map.get("id") as number
    let title: string = map.get("title") as string
    let order: number = map.get("order") as number
    let icon: ESObject = map.get("icon")
    if (icon instanceof Map) {
      icon = AndroidResource.fromMap(map.get("icon") as Map<string, ESObject>);
    } else if (!(icon instanceof ArrayBuffer)) {
      icon = null;
    }
    let iconColor: string = map.get("iconColor") as string;
    let showAsAction: boolean = Util.getOrDefault( map, "showAsAction", false);
    return new InAppBrowserMenuItem(id, title, order, icon, iconColor, showAsAction);
  }

  public getId(): number {
    return this.id;
  }

  public setId(id: number): void {
    this.id = id;
  }

  public getTitle(): string {
    return this.title;
  }

  public setTitle(title: string): void {
    this.title = title;
  }

  public getOrder(): number {
    return this.order??0;
  }

  public setOrder(order: number): void {
    this.order = order;
  }

  public getIcon(): ESObject {
    return this.icon;
  }

  public setIcon(icon: ESObject): void {
    this.icon = icon;
  }

  public getIconColor(): string {
    return this.iconColor??'';
  }

  public setIconColor(iconColor: string): void {
    this.iconColor = iconColor;
  }

  public isShowAsAction(): boolean {
    return this.showAsAction;
  }

  public setShowAsAction(showAsAction: boolean): void {
    this.showAsAction = showAsAction;
  }

  public equals(o: ESObject): boolean {
    if (this == o) return true;
    // if (o == null || getClass() != o.getClass()) return false;

    let that: InAppBrowserMenuItem = o as InAppBrowserMenuItem;

    if (this.id != that.id) return false;
    if (this.showAsAction != that.showAsAction) return false;
    if (!this.title.includes(that.title)) return false;
    // if (!ESObject.equals(this.order, that.order)) return false;
    // if (!ESObject.equals(this.icon, that.icon)) return false;
    // return ESObject.equals(this.iconColor, that.iconColor);
    if(!(this.order == that.order)) return false
    if(!(this.icon == that.icon)) return false
    return this.iconColor == that.iconColor
  }

  public hashCode(): number {
    let result: number = this.id;
    // result = 31 * result + this.title.hashCode();
    // result = 31 * result + (this.order != null ? this.order.hashCode() : 0);
    // result = 31 * result + (this.icon != null ? this.icon.hashCode() : 0);
    // result = 31 * result + (this.iconColor != null ? this.iconColor.hashCode() : 0);
    // result = 31 * result + (this.showAsAction ? 1 : 0);
    return result;
  }

  public toString(): string {
    return "InAppBrowserMenuItem{" +
      "id=" + this.id +
      ", title='" + this.title + '\'' +
      ", order=" + this.order +
      ", icon=" + this.icon +
      ", iconColor='" + this.iconColor + '\'' +
      ", showAsAction=" + this.showAsAction +
      '}';
  }
}