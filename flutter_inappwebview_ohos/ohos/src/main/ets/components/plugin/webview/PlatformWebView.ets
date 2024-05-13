import { Any, PlatformView } from '@ohos/flutter_ohos';

export default abstract class PlatformWebView extends PlatformView {
  abstract makeInitialLoad(params: Map<string, Any>): void;
}
