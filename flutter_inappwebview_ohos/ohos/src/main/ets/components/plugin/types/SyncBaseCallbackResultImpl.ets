import { Any } from '@ohos/flutter_ohos';
import BaseCallbackResultImpl from './BaseCallbackResultImpl';

export default class SyncBaseCallbackResultImpl<T> extends BaseCallbackResultImpl<T> {
  public result: T | null = null;
  public responsed: boolean = false

  defaultBehaviour(result: T | null): void {
    this.responsed = true
  }

  success(obj: Any): void {
    let result = this.decodeResult(obj);
    this.result = result;
    let shouldRunDefaultBehaviour: boolean = false;
    if (result == null) {
      shouldRunDefaultBehaviour = this.nullSuccess();
    } else {
      shouldRunDefaultBehaviour = this.nonNullSuccess(result);
    }
    if (shouldRunDefaultBehaviour) {
      this.defaultBehaviour(result);
    } else {
      this.responsed = true
    }
  }

  waitResponse(): Promise<void> {
    return new Promise((resolve, reject) => {
      try {
        let intervalId = setInterval(() => {
          if (this.responsed) {
            clearInterval(intervalId)
            resolve()
          }
        }, 20)
      } catch (err) {
        reject()
      }
    })
  }

  error(errorCode: string, errorMessage: string, errorDetails: Any) {
    this.responsed = true
  }

  notImplemented(): void {
    this.defaultBehaviour(null);
  }
}