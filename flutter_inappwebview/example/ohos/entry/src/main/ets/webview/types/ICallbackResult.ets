import { MethodResult } from '@ohos/flutter_ohos/src/main/ets/plugin/common/MethodChannel';

export default interface ICallbackResult<T> extends MethodResult {
  nonNullSuccess(result: T): boolean;
  nullSuccess(): boolean;
  defaultBehaviour( result: T | null): void;
  decodeResult(obj: ESObject) : T | null;
}
