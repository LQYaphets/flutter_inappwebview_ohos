import { Disposable } from '../types/Disposable';
import { FlutterWebView } from '../webview/in_app_webview/FlutterWebView';

export class HeadlessInAppWebView implements Disposable {
  public  flutterWebView: FlutterWebView | undefined = undefined;

  dispose(): void {
    throw new Error('Method not implemented.');
  }

  public disposeAndGetFlutterWebView(): FlutterWebView | undefined{
    let newFlutterWebView: FlutterWebView | undefined = this.flutterWebView;
    if (this.flutterWebView != null) {
      let view = this.flutterWebView.getView();
      if (view != null) {
        // restore WebView layout params and visibility
        // view.setLayoutParams(new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
        // view.setVisibility(View.VISIBLE);
        // // remove from parent
        // ViewGroup parent = (ViewGroup) view.getParent();
        // if (parent != null) {
        //   parent.removeView(view);
        // }
      }
      // set to null to avoid to be disposed before calling "dispose()"
      this.flutterWebView = undefined;
      this.dispose();
    }
    return newFlutterWebView;
  }
}