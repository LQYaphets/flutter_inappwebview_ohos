export default class Util {
  static LOG_TAG: string = "Util"

  constructor() {}

  /// android.text.TextUtils未找对应的，未完善
  public static replaceAll(s: string, oldString: string, newString: string): string {
    // return TextUtils.join(newString, s.split(Pattern.quote(oldString)));
    return ""
  }
}