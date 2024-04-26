import { Any } from '@ohos/flutter_ohos'

export default class Util {
  static LOG_TAG: string = "Util"

  constructor() {
  }

  /// android.text.TextUtils未找对应的，未完善
  public static replaceAll(s: string, oldString: string, newString: string): string {
    return s.replace(new RegExp(oldString, 'g'), newString)
  }

  public static getOrDefault(map: Map<string, Any>, key: string, defaultValue: Any): Any {
    let keys = map.keys()
    for (let keyValue of keys) {
      if (keyValue == key) {
        return map.get(key) as Any
      }
    }
    return defaultValue;
  }

  public static objEquals(a: Any, b: Any): boolean {
    // if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
    //   return Objects.equals(a, b);
    // }
    return (a == b) || (a != null && a.equals(b));
  }

  public static formatString(format: string, ...args: Any[]): string {
    return format.replace(/{(\d+)}/g, (match, index: number) => {
      const arg: Any = args[index];
      return arg !== undefined ? arg.toString() + "" : match;
    });
  }
}