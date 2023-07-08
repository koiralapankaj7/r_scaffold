// ignore_for_file: always_use_package_imports

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

///
mixin BreakpointAware<T extends StatefulWidget> on State<T> {
  String _currentType = '';
  Size? _prevSize;
  List<MapEntry<String, double>>? _sortedBreakpoints;

  ///
  // ignore: avoid_positional_boolean_parameters
  void onBreakpointChange(MapEntry<String, double> breakpoint, bool forward) {}

  ///
  void onBreakpointInit(MapEntry<String, double> breakpoint) {}

  MapEntry<String, double> _getSize(Size size) {
    var bp = MapEntry('unknown', size.width);
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
      if (bp.key != _currentType) {
        onBreakpointChange(bp, size.width > _prevSize!.width);
      }
    } else {
      onBreakpointInit(bp);
    }
    _currentType = bp.key;
    _prevSize = size;
  }

  ///
  Iterable<MapEntry<String, double>> get breakpoints;

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
