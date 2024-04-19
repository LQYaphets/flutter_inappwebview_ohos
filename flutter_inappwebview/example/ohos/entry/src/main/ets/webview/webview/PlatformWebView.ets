import { PlatformView } from '@ohos/flutter_ohos';

export default abstract class PlatformWebView extends PlatformView {
  abstract makeInitialLoad(params: Map<string, ESObject>): void;
}
