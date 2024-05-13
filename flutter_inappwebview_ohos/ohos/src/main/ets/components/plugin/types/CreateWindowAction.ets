import { Any } from '@ohos/flutter_ohos';
import NavigationAction from './NavigationAction';
import URLRequest from './URLRequest';

export default class CreateWindowAction extends NavigationAction {
  windowId: number
  isDialog: boolean

  constructor(request: URLRequest, isForMainFrame: boolean, hasGesture: boolean, isRedirect: boolean, windowId: number, isDialog: boolean) {
    super(request, isForMainFrame, hasGesture, isRedirect)
    this.windowId = windowId
    this.isDialog = isDialog
  }

  public toMap(): Map<string, Any> {
    let createWindowActionMap: Map<string, Any> = super.toMap();
    createWindowActionMap.set("windowId", this.windowId);
    createWindowActionMap.set("isDialog", this.isDialog);
    createWindowActionMap.set("windowFeatures", null);
    return createWindowActionMap;
  }

  public getWindowId(): number {
    return this.windowId;
  }

  public setWindowId(windowId: number): void {
    this.windowId = windowId;
  }

  public getDialog(): boolean {
    return this.isDialog;
  }

  public setDialog(dialog: boolean): void {
    this.isDialog = dialog;
  }

  public toString(): string {
    return "CreateWindowAction{" +
      "windowId=" + this.windowId +
      ", isDialog=" + this.isDialog +
      ", request=" + this.request +
      ", isForMainFrame=" + this.isForMainFrame +
      ", hasGesture=" + this.hasGesture +
      ", isRedirect=" + this.isRedirect +
      '}';
  }
}