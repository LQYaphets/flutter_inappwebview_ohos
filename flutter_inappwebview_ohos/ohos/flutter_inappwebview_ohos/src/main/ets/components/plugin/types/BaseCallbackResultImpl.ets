import { Any } from '@ohos/flutter_ohos';
import ICallbackResult from './ICallbackResult';

export default class BaseCallbackResultImpl<T> implements ICallbackResult<T> {
  nonNullSuccess(result: T): boolean {
    return true;
  }

  nullSuccess(): boolean {
    return true;
  }

  defaultBehaviour(result: T | null): void {

  }

  success(obj: Any): void {
    let result = this.decodeResult(obj);
    let shouldRunDefaultBehaviour: boolean = false;
    if (result == null) {
      shouldRunDefaultBehaviour = this.nullSuccess();
    } else {
      shouldRunDefaultBehaviour = this.nonNullSuccess(result);
    }
    if (shouldRunDefaultBehaviour) {
      this.defaultBehaviour(result);
    }
  }

  decodeResult(obj: Any): T | null {
    return null;
  }


  error(errorCode: string, errorMessage: string, errorDetails: Any): void {

  }

  notImplemented(): void {
    this.defaultBehaviour(null);
  }
}