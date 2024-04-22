import ContentWorld from './ContentWorld';
import { UserScriptInjectionTime } from './UserScriptInjectionTime';

export default class UserScript {
  private groupName: string;
  private source: string;
  private injectionTime: UserScriptInjectionTime;
  private contentWorld: ContentWorld;
  private allowedOriginRules: Set<string>;

  constructor(groupName: string, source: string, injectionTime: UserScriptInjectionTime, contentWorld: ContentWorld | null, allowedOriginRules: Set<string> | null) {
    this.groupName = groupName;
    this.source = source;
    this.injectionTime = injectionTime;
    this.contentWorld = contentWorld == null ? ContentWorld.PAGE : contentWorld;
    if (allowedOriginRules == null) {
      let set = new Set<string>();
      set.add("*")
      this.allowedOriginRules = set;
    } else {
      this.allowedOriginRules = allowedOriginRules;
    }
  }

  public static fromMap(map: Map<string, ESObject>): UserScript | null {
    if (map == null) {
      return null;
    }
    let groupName = map.get("groupName") as string;
    let source = map.get("source") as string;
    let injectionTime = map.get("injectionTime") as number;
    let contentWorld = ContentWorld.fromMap(map.get("contentWorld"));
    let rules: Array<string> = map.get("allowedOriginRules") as Array<string>;
    let allowedOriginRules = new Set<string>();
    for (let rulesElement of rules) {
      allowedOriginRules.add(rulesElement)
    }
    return new UserScript(groupName, source, injectionTime, contentWorld, allowedOriginRules);
  }

  getGroupName(): string {
    return this.groupName;
  }

  setGroupName(groupName: string) {
    this.groupName = groupName;
  }

  getSource(): string {
    return this.source;
  }

  setSource(source: string) {
    this.source = source;
  }

  getInjectionTime(): UserScriptInjectionTime {
    return this.injectionTime;
  }

  setInjectionTime(injectionTime: UserScriptInjectionTime) {
    this.injectionTime = injectionTime;
  }

  getContentWorld(): ContentWorld {
    return this.contentWorld;
  }

  setContentWorld(contentWorld: ContentWorld) {
    this.contentWorld = contentWorld == null ? ContentWorld.PAGE : contentWorld;
  }

  getAllowedOriginRules(): Set<string> {
    return this.allowedOriginRules;
  }

  setAllowedOriginRules(allowedOriginRules: Set<string>) {
    this.allowedOriginRules = allowedOriginRules;
  }

  equals(o: ESObject): boolean {
    if (this == o) return true;

    let that = o as UserScript;

    if (this.groupName != null ? !(this.groupName == that.groupName) : that.groupName != null)
      return false;
    if (!(this.source == that.source)) return false;
    if (this.injectionTime != that.injectionTime) return false;
    if (!this.contentWorld.equals(that.contentWorld)) return false;
    return this.checkSetEquals(this.allowedOriginRules, that.allowedOriginRules);
  }

  private checkSetEquals(rules: Set<string>, rules2: Set<string>): boolean {
    let isEquals = true
    rules.forEach(item => {
      isEquals = isEquals && rules2.has(item)
    })
    return isEquals;
  }
}