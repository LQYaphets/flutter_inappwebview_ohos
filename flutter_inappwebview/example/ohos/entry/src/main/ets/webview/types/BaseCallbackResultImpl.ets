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

  success(obj: ESObject): void {
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

  decodeResult(obj: ESObject): T | null {
    return null;
  }


  error(errorCode: string, errorMessage: string, errorDetails: ESObject) {

  }

  notImplemented(): void {
    this.defaultBehaviour(null);
  }
}