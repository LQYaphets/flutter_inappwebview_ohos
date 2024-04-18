import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'layout_mode.g.dart';

///设置Web布局模式。
@ExchangeableEnum()
class LayoutMode_ {
  // ignore: unused_field
  final int _value;
  const LayoutMode_._internal(this._value);

  ///Web布局跟随系统。
  static const NONE = const LayoutMode_._internal(0);

  ///Web基于页面大小的自适应网页布局。
  static const FIT_CONTENT = const LayoutMode_._internal(1);
}