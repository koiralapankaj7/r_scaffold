// ignore_for_file: always_use_package_imports

import 'package:flutter/material.dart';

import '../entities/entities.dart';

///
mixin BreakpointAware<T extends StatefulWidget> on State<T> {
  String _currentType = 'N';
  Size? _prevSize;

  ///
  // ignore: avoid_positional_boolean_parameters
  void onBreakpointChange(String screen, bool forward) {}

  ///
  void onBreakpointInit(String screen) {}

  String _getSize(Size size) {
    if (size.width < breakpoint.drawer) return 'S';
    if (size.width >= breakpoint.drawer && size.width < breakpoint.rail) {
      return 'M';
    }
    return 'L';
  }

  void _didSizeChanged(Size size) {
    if (_prevSize == size) return;

    if (_prevSize != null) {
      if (size.width < breakpoint.drawer) {
        if (_currentType != 'S') {
          onBreakpointChange('S', size.width > _prevSize!.width);
          _currentType = 'S';
        }
      } else if (size.width >= breakpoint.drawer &&
          size.width < breakpoint.rail) {
        if (_currentType != 'M') {
          onBreakpointChange('M', size.width > _prevSize!.width);
          _currentType = 'M';
        }
      } else if (_currentType != 'L') {
        onBreakpointChange('L', size.width > _prevSize!.width);
        _currentType = 'L';
      }
    } else {
      onBreakpointInit(_getSize(size));
    }
    _prevSize = size;
  }

  ///
  RBreakPoint get breakpoint;

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
      'Widgets that mix AutomaticKeepAliveClientMixin into their State must '
      'call super.build() but must ignore the return value of the superclass.',
    );
  }
}
