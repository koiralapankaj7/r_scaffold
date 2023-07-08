import 'package:flutter/material.dart';

// The default width of the side menu when expanded to full menu.
const double _kMenuWidth = 280;

// The default width of the side menu when collapsed to a rail.
// We make it extra compact to not be so intrusive on phones. It looks a bit
// silly on desktop. But parent can vary it based on media size if so desired.
// The default example and example 5 do so.
const double _kRailWidth = 52;

// The minimum media size needed for desktop/large tablet menu view.
// Only at higher than this breakpoint will the menu open and be possible
// to toggle between menu and rail. Below this breakpoint it toggles between
// hidden in the Drawer and rail, also on phones. This is just the default
// value for the constructor and it can be set differently in the
// ResponsiveScaffold constructor.
const double _kMediumWidthBreakpoint = 900;

///
const double _kSmallWidthBreakpoint = 600;

///
@immutable
class RMenuTheme {
  ///
  const RMenuTheme({
    this.railMinWidth = _kRailWidth,
    this.railMaxWidth = _kMenuWidth,
    this.drawerWidth,
    this.itemMargin = const EdgeInsets.symmetric(
      horizontal: 8,
      vertical: 2,
    ),
    this.backgroundColor,
    this.elevation,
    this.unselectedLabelTextStyle,
    this.selectedLabelTextStyle,
    this.disabledLabelTextStyle,
    this.unselectedIconTheme,
    this.selectedIconTheme,
    this.disabledIconTheme,
    this.useIndicator = true,
    this.indicatorColor,
    this.indicatorShape,
    this.breakPoint = const RBreakPoint(),
    this.radius,
    this.dividerAboveThemeData,
    this.dividerBelowThemeData,
    this.decoration,
  })  : assert(
          elevation == null || elevation >= 0,
          'Elevation cannot be less than 0',
        ),
        assert(railMinWidth > 0, 'Rail width must be greater than 0'),
        assert(railMaxWidth > 0, 'Max width must be greater than 0'),
        assert(
          drawerWidth == null || drawerWidth > 0,
          'Drawer width cannot be less than 0',
        ),
        assert(
          railMaxWidth >= railMinWidth,
          'Max width must be greater than railWidth',
        );

  ///
  final double railMinWidth;

  ///
  final double railMaxWidth;

  ///
  final double? drawerWidth;

  ///
  final EdgeInsetsGeometry itemMargin;

  ///
  final Color? backgroundColor;

  ///
  final double? elevation;

  ///
  final TextStyle? unselectedLabelTextStyle;

  ///
  final TextStyle? selectedLabelTextStyle;

  ///
  final TextStyle? disabledLabelTextStyle;

  ///
  final IconThemeData? unselectedIconTheme;

  ///
  final IconThemeData? selectedIconTheme;

  ///
  final IconThemeData? disabledIconTheme;

  ///
  final bool useIndicator;

  ///
  final Color? indicatorColor;

  ///
  final ShapeBorder? indicatorShape;

  ///
  final BorderRadius? radius;

  ///
  final RBreakPoint breakPoint;

  ///
  final DividerThemeData? dividerAboveThemeData;

  ///
  final DividerThemeData? dividerBelowThemeData;

  ///
  final BoxDecoration? decoration;

  ///
  BorderRadius resolveRadius(TextDirection? direction) {
    if (radius != null) return radius!;
    return switch (indicatorShape) {
      RoundedRectangleBorder(:final borderRadius) =>
        borderRadius.resolve(direction),
      _ => BorderRadius.circular(railMinWidth * 0.5),
    };
  }
}

///
enum RMenuType {
  /// Menu will be displayed inside the drawer
  drawer(-1),

  /// Menu will be displayed as rail
  rail(0),

  /// Menu will be displayed as extended rail
  extended(1);

  const RMenuType(this.value);

  ///
  final int value;
}

///
@immutable
class RBreakPoint {
  ///
  const RBreakPoint({
    this.drawer = _kSmallWidthBreakpoint,
    this.rail = _kMediumWidthBreakpoint,
  });

  ///
  static const RBreakPoint none = RBreakPoint(drawer: 0, rail: 0);

  ///
  final double drawer;

  ///
  final double rail;
}
