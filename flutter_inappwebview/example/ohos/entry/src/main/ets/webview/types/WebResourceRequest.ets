import { uri } from '@kit.ArkTS'

export default interface WebResourceRequest {
  getUrl(): uri.URI
  isForMainFrame(): boolean
  isRedirect(): boolean
  hasGesture(): boolean
  getMethod(): string
  getRequestHeaders(): Map<string, string>
}