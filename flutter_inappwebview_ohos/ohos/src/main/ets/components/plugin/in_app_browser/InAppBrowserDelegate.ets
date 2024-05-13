import { List } from '@kit.ArkTS'
import { ActivityResultListener } from './ActivityResultListener'

export interface InAppBrowserDelegate {

  /// android.app.Activity缺少
  // getActivity(): Activity

  getActivityResultListeners(): List<ActivityResultListener>

  didChangeTitle(title: string): void

  didStartNavigation(url: string): void

  didUpdateVisitedHistory(url: string): void

  didFinishNavigation(url: string): void

  didFailNavigation(url: string, errorCode: number, description: string): void

  didChangeProgress(progress: number): void
}