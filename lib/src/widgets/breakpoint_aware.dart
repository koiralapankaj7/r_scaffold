// ignore_for_file: always_use_package_imports

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

///
mixin BreakpointAware<T extends StatefulWidget, V extends Object> on State<T> {
  V? _currentType;
  Size? _prevSize;
  List<MapEntry<V, double>>? _sortedBreakpoints;

  ///
  // ignore: avoid_positional_boolean_parameters
  void onBreakpointChange(MapEntry<V, double>? breakpoint, int direction) {}

  ///
  void onBreakpointInit(MapEntry<V, double>? breakpoint) {}

  MapEntry<V, double>? _getSize(Size size) {
    MapEntry<V, double>? bp;
    for (var i = 0; i < _sortedBreakpoints!.length; i++) {
      final breakpoint = _sortedBreakpoints![i];
      if (size.width < breakpoint.value) {
        bp = breakpoint;
        break;
      }
    }
    return bp;
  }

  void _didSizeChanged(Size size) {
    if (_prevSize == size || breakpoints.isEmpty) return;
    _sortedBreakpoints ??=
        breakpoints.sorted((a, b) => a.value.compareTo(b.value));
    final bp = _getSize(size);
    if (_prevSize != null) {
      if (bp?.key != _currentType) {
        onBreakpointChange(bp, size.width > _prevSize!.width ? 1 : -1);
      }
    } else {
      onBreakpointInit(bp);
    }
    _currentType = bp?.key;
    _prevSize = size;
  }

  ///
  Iterable<MapEntry<V, double>> get breakpoints;

  @mustCallSuper
  @override
  Widget build(BuildContext context) {
    _didSizeChanged(MediaQuery.sizeOf(context));
    return const _NullWidget();
  }
}

class _NullWidget extends StatelessWidget {
  const _NullWidget();

  @override
  Widget build(BuildContext context) {
    throw FlutterError(
      'Widgets that mix BreakpointAware into their State must '
      'call super.build() but must ignore the return value of the superclass.',
    );
  }
}
