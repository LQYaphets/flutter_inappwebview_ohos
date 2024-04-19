export default interface ISettings<T> {
  parse(settings: Map<string, ESObject>): ISettings<T>

  toMap(): Map<string, ESObject>;

  getRealSettings(obj: T): Map<string, ESObject>;
}