import ISettings from '../ISettings';
import { PullToRefreshLayout } from './PullToRefreshLayout';

export class PullToRefreshSettings implements ISettings<PullToRefreshLayout> {
  static LOG_TAG: string = "PullToRefreshSettings";

  enabled: boolean = true;
  color: string | null = null;

  backgroundColor: string | null = null;
  distanceToTriggerSync: number | null = null;

  slingshotDistance: number | null = null;
  size: number | null = null;

  public parse(settings: Map<string, ESObject>): PullToRefreshSettings {
    let keys = settings.keys();
    for(let key of keys) {
      if(key == null) {
        continue;
      }
      
      switch (key) {
        case "enabled":
          this.enabled = settings[key] as boolean;
          break;
        case "color":
          this.color = settings[key] as string;
          break;
        case "backgroundColor":
          this.backgroundColor = settings[key] as string;
          break;
        case "distanceToTriggerSync":
          this.distanceToTriggerSync = settings[key] as number;
          break;
        case "slingshotDistance":
          this.slingshotDistance = settings[key] as number;
          break;
        case "size":
          this.size = settings[key] as number;
          break;
      }
    }
    return this;
  }

  public toMap() {
    let settings: Map<string, ESObject> = new Map<string, Object>();
    settings.set("enabled", this.enabled);
    settings.set("color", this.color!);
    settings.set("backgroundColor", this.backgroundColor!);
    settings.set("distanceToTriggerSync", this.distanceToTriggerSync!);
    settings.set("slingshotDistance", this.slingshotDistance!);
    settings.set("size", this.size!);
    return settings;
  }

  public getRealSettings(pullToRefreshLayout: PullToRefreshLayout) {
    let realSettings: Map<string, ESObject> = this.toMap();
    return realSettings;
  }
}