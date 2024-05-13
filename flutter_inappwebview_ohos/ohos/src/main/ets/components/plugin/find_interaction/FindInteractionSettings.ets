import { Any } from '@ohos/flutter_ohos';

import ISettings from '../ISettings';
import { FindInteractionController } from './FindInteractionController';

const LOG_TAG = "FindInteractionSettings";

export class FindInteractionSettings implements ISettings<FindInteractionController> {
  parse(settings: Map<string, Any>): ISettings<FindInteractionController> {
    return this;
  }

  toMap(): Map<string, Any> {
    let settings: Map<string, Any> = new Map<string, Any>();
    return settings;
  }

  getRealSettings(obj: FindInteractionController): Map<string, Any> {
    let realSettings: Map<string, Any> = this.toMap();
    return realSettings;
  }
}