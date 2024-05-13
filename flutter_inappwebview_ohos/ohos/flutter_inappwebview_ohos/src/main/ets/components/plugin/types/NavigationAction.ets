import { Any } from '@ohos/flutter_ohos'
import URLRequest from './URLRequest'

export default class NavigationAction {
  request: URLRequest
  isForMainFrame: boolean
  hasGesture: boolean
  isRedirect: boolean

  constructor(request: URLRequest, isForMainFrame: boolean, hasGesture: boolean, isRedirect: boolean) {
    this.request = request
    this.isForMainFrame = isForMainFrame
    this.hasGesture = hasGesture
    this.isRedirect = isRedirect
  }

  public toMap(): Map<string, Any> {
    let navigationActionMap: Map<string, Any> = new Map<string, Any>();
    navigationActionMap.set("request", this.request.toMap());
    navigationActionMap.set("isForMainFrame", this.isForMainFrame);
    navigationActionMap.set("hasGesture", this.hasGesture);
    navigationActionMap.set("isRedirect", this.isRedirect);
    navigationActionMap.set("navigationType", null);
    navigationActionMap.set("sourceFrame", null);
    navigationActionMap.set("targetFrame", null);
    navigationActionMap.set("shouldPerformDownload", null);
    return navigationActionMap;
  }

  public getRequest(): URLRequest {
    return this.request;
  }

  public setRequest(request: URLRequest): void {
    this.request = request;
  }

  public getForMainFrame(): boolean {
    return this.isForMainFrame;
  }

  public setForMainFrame(forMainFrame: boolean): void {
    this.isForMainFrame = forMainFrame;
  }

  public isHasGesture(): boolean {
    return this.hasGesture;
  }

  public setHasGesture(hasGesture: boolean): void {
    this.hasGesture = hasGesture;
  }

  public getRedirect(): boolean {
    return this.isRedirect;
  }

  public setRedirect(redirect: boolean): void {
    this.isRedirect = redirect;
  }

  public equals(o: Any): boolean {
    if (this == o) return true;
    // if (o == null || getClass() != o.getClass()) return false;

    let that: NavigationAction = o as NavigationAction;

    if (this.isForMainFrame != that.isForMainFrame) return false;
    if (this.hasGesture != that.hasGesture) return false;
    if (this.isRedirect != that.isRedirect) return false;
    return this.request == that.request;
  }

  public toString(): string {
    return "NavigationAction{" +
      "request=" + this.request +
      ", isForMainFrame=" + this.isForMainFrame +
      ", hasGesture=" + this.hasGesture +
      ", isRedirect=" + this.isRedirect +
      '}';
  }
}