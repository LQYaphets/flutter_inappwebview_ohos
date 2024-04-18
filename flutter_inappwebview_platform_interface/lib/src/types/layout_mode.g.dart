// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'layout_mode.dart';

// **************************************************************************
// ExchangeableEnumGenerator
// **************************************************************************

///设置Web布局模式。
class LayoutMode {
  final int _value;
  final int _nativeValue;
  const LayoutMode._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory LayoutMode._internalMultiPlatform(int value, Function nativeValue) =>
      LayoutMode._internal(value, nativeValue());

  ///Web基于页面大小的自适应网页布局。
  static const FIT_CONTENT = LayoutMode._internal(1, 1);

  ///Web布局跟随系统。
  static const NONE = LayoutMode._internal(0, 0);

  ///Set of all values of [LayoutMode].
  static final Set<LayoutMode> values = [
    LayoutMode.FIT_CONTENT,
    LayoutMode.NONE,
  ].toSet();

  ///Gets a possible [LayoutMode] instance from [int] value.
  static LayoutMode? fromValue(int? value) {
    if (value != null) {
      try {
        return LayoutMode.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  ///Gets a possible [LayoutMode] instance from a native value.
  static LayoutMode? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return LayoutMode.values
            .firstWhere((element) => element.toNativeValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  ///Gets [int] value.
  int toValue() => _value;

  ///Gets [int] native value.
  int toNativeValue() => _nativeValue;

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(value) => value == _value;

  @override
  String toString() {
    switch (_value) {
      case 1:
        return 'FIT_CONTENT';
      case 0:
        return 'NONE';
    }
    return _value.toString();
  }
}
