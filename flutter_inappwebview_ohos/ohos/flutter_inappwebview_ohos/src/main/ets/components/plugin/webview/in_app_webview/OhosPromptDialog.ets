import { Log } from '@ohos/flutter_ohos';

@Component
struct OhosPromptView {
  textValue: string | null = null
  message: string | null = null
  cancelButton: string | null = null
  confirmButton: string | null = null
  cancel: Function | null = null;
  confirm: Function | null = null;

  aboutToAppear(): void {
    Log.d("InAppWebViewChromeClient", "aboutToAppear")
  }

  build() {
    Column() {
      Text(this.message).fontSize(20).margin({ top: 10, bottom: 10 })
      TextInput({ placeholder: '', text: this.textValue }).height(60).width('90%')
        .onChange((value: string) => {
          this.textValue = value
        })
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button(this.cancelButton != null && this.cancelButton.length > 0 ? this.cancelButton : "取消")
          .onClick(() => {
            if (this.cancel) {
              this.cancel()
            }
          }).fontColor(Color.Black)
        Button(this.confirmButton != null && this.confirmButton.length > 0 ? this.confirmButton : "确定")
          .onClick(() => {
            if (this.confirm) {
              this.confirm(this.textValue)
            }
          })
      }.margin({ top: 10, bottom: 10 })
    }.borderRadius(10)
  }
}

@Builder
export function ohosPromptDialogBuilder(textValue: string | null,
                                        message: string | null,
                                        cancelButton: string | null,
                                        confirmButton: string | null,
                                        cancel: Function, confirm: Function) {
  OhosPromptView({
    textValue: textValue,
    message: message,
    cancelButton: cancelButton,
    confirmButton: confirmButton,
    cancel: cancel,
    confirm: confirm
  })
}
