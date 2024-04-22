import WebMessagePortCompatExt from './WebMessagePortCompatExt'
import { List } from '@kit.ArkTS'

export default class WebMessageCompatExt {
  private data: ESObject

  /// 缺少androidx.webkit.WebMessageCompat 中 public @interface Type 类似接口
  private type: number

  private ports: List<WebMessagePortCompatExt> | null

  constructor(data: ESObject, type: number, ports: List<WebMessagePortCompatExt> | null) {
    this.data = data;
    this.type = type;
    this.ports = ports;
  }


  /// 未实现，未寻找androidx.webkit.WebMessageCompat对应类型和方法
  // public static fromMapWebMessageCompat(message: WebMessageCompat): WebMessageCompatExt {
  //  Object data;
  //   if (WebViewFeature.isFeatureSupported(WebViewFeature.WEB_MESSAGE_ARRAY_BUFFER) && message.getType() == WebMessageCompat.TYPE_ARRAY_BUFFER) {
  //     data = message.getArrayBuffer();
  //   } else {
  //     data = message.getData();
  //   }
  //   return new WebMessageCompatExt(data, message.getType(), null);
  // }

  public static fromMap(map: Map<string, ESObject> | null): WebMessageCompatExt | null {
    if (map == null) {
      return null;
    }
    let data: ESObject = map.get("data")
    let type: number = map.get("type") as number
    let portMapList: List<Map<string, ESObject>> = map.get("ports") as List<Map<string, ESObject>>
    let ports: List<WebMessagePortCompatExt> | null = null;
    if (portMapList != null && !portMapList.isEmpty()) {
      ports = new List<WebMessagePortCompatExt>();
      for (let i = 0; i < portMapList.length; i++) {
        ports.add(WebMessagePortCompatExt.fromMap(portMapList[i]));
      }
    }
    return new WebMessageCompatExt(data, type, ports);
  }

  public toMap(): Map<string, ESObject> {
    let proxyRuleMap: Map<string, ESObject> = new Map<string, ESObject>()
    proxyRuleMap.set("data", this.data);
    proxyRuleMap.set("type", this.type);
    return proxyRuleMap;
  }

  public getData(): ESObject {
    return this.data;
  }

  public setData(data: ESObject): void {
    this.data = data;
  }

  public getType(): number {
    return this.type;
  }

  public setType(type: number): void {
    this.type = type;
  }

  public getPorts(): List<WebMessagePortCompatExt> {
    return this.ports!;
  }

  public setPorts(ports: List<WebMessagePortCompatExt>): void {
    this.ports = ports;
  }

  public equals(o: ESObject): boolean {
    if (this == o) return true;
    // if (o == null || getClass() != o.getClass()) return false;

    let that: WebMessageCompatExt = o as WebMessageCompatExt;

    if (this.type != that.type) return false;
    // if (!this.Objects.equals(this.data, that.data)) return false;
    // return Objects.equals(ports, that.ports);
    return true
  }

  public toString(): string {
    return "WebMessageCompatExt{" +
      "data=" + this.data +
      ", type=" + this.type +
      ", ports=" + this.ports +
      '}';
  }
}