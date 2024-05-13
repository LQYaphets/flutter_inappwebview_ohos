import { Any } from '@ohos/flutter_ohos';

export default interface ISettings<T> {
  parse(settings: Map<string, Any>): ISettings<T>

  toMap(): Map<string, Any>;

  getRealSettings(obj: T): Map<string, Any>;
}