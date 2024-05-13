export interface ValueCallback<T> {
  /**
   * Invoked when the value is available.
   * @param value The value.
   */
  onReceiveValue: (value: T | null) => void;
}