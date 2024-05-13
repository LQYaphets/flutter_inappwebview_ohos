import { List } from '@kit.ArkTS'
import WebMessagePort from './WebMessagePort'

export default  class WebMessage {
  public data: string | null

  public ports: List<WebMessagePort> | null

  constructor(data: string | null, ports: List<WebMessagePort> | null) {
    this.data = data
    this.ports = ports
  }

  public dispose(): void {
    if(this.ports != null){
      this.ports.clear()
    }
  }
}