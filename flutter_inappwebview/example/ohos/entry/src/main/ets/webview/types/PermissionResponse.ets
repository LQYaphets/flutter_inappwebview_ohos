import { List } from '@kit.ArkTS'

export default class PermissionResponse{
  private resources: List<string>
  private action: number

  constructor(resources: List<string>, action: number) {
    this.resources = resources
    this.action = action
  }

  public static fromMap(map: Map<string, ESObject>): PermissionResponse | null {
    if (map == null) {
      return null;
    }
    let resources: List<string> = map.get("resources") as List<string>;
    let action: number = map.get("action") as number;
    return new PermissionResponse(resources, action);
  }

  public getResources(): List<string> {
    return this.resources;
  }

  public setResources(resources: List<string>): void {
    this.resources = resources;
  }

  public getAction(): number {
    return this.action;
  }

  public setAction(action: number): void {
    this.action = action;
  }

  public toString(): string {
    return "PermissionResponse{" +
      "resources=" + this.resources +
      ", action=" + this.action +
      '}';
  }
}