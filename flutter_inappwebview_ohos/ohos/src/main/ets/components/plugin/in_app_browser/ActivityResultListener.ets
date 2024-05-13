export interface ActivityResultListener {
  onActivityResult(requestCode: number, resultCode: number, data: number): boolean
}