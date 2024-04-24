import { Any } from '@ohos/flutter_ohos'

export default class Util {
  static LOG_TAG: string = "Util"

  constructor() {}

  /// android.text.TextUtils未找对应的，未完善
  public static replaceAll(s: string, oldString: string, newString: string): string {
    // return TextUtils.join(newString, s.split(Pattern.quote(oldString)));
    return ""
  }

  public static getOrDefault(map: Map<string, Any>, key: string, defaultValue: Any): Any {
    let keys = map.keys()
    for(let keyValue of keys) {
      if(keyValue == key) {
        return map.get(key) as Any
      }
    }
    return defaultValue;
  }

  public static objEquals(a: Any, b: Any) :boolean {
    // if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
    //   return Objects.equals(a, b);
    // }
    return (a == b) || (a != null && a.equals(b));
  }
}