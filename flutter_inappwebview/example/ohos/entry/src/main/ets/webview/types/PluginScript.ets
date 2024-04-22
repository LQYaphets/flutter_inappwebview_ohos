import { ContentWorld } from './ContentWorld';
import UserScript from './UserScript';
import { UserScriptInjectionTime } from './UserScriptInjectionTime';

export default class PluginScript extends UserScript {
  private requiredInAllContentWorlds: boolean;

  constructor(groupName: string, source: string, injectionTime: UserScriptInjectionTime,
              contentWorld: ContentWorld | null, requiredInAllContentWorlds: boolean, allowedOriginRules: Set<string> | null) {
    super(groupName, source, injectionTime, contentWorld, allowedOriginRules);
    this.requiredInAllContentWorlds = requiredInAllContentWorlds;
  }

  public isRequiredInAllContentWorlds(): boolean { return this.requiredInAllContentWorlds }

  public setRequiredInAllContentWorlds(requiredInAllContentWorlds: boolean): void {
    this.requiredInAllContentWorlds = requiredInAllContentWorlds;
  }

  public equals(o: ESObject): boolean {
    if (this == o) return true;
    // if (o == null || getClass() != o.getClass()) return false;
    if (!super.equals(o)) return false;

    let that: PluginScript = o as PluginScript;

    return this.requiredInAllContentWorlds == that.requiredInAllContentWorlds;
  }

  public hashCode(): number {
    // let result: number = super.hashCode();
    // result = 31 * result + (this.requiredInAllContentWorlds ? 1 : 0);
    // return result;
    return 0;
  }

  public toString() {
    return "PluginScript{" +
      "requiredInContentWorld=" + this.requiredInAllContentWorlds +
      "} " + super.toString();
  }
}