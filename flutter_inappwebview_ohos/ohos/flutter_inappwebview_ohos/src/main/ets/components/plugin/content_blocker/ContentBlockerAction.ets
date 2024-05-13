import { Any } from '@ohos/flutter_ohos';
import { ContentBlockerActionType } from './ContentBlockerActionType';

export default class ContentBlockerAction {
  private type: ContentBlockerActionType;
  private selector: string;

  constructor(type: ContentBlockerActionType, selector: string) {
    this.type = type;
    this.selector = selector;
  }

  static fromMap(map: Map<string, Any>): ContentBlockerAction {
    let type: ContentBlockerActionType = map.get("type");
    let selector: string = map.get("selector");
    return new ContentBlockerAction(type, selector);
  }
}