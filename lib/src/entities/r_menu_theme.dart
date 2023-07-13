import 'package:equatable/equatable.dart';
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
class RMenuTheme {
  ///
  RMenuTheme({
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
    this.radius,
    this.dividerAboveThemeData,
    this.dividerBelowThemeData,
    this.decoration,
    this.minPoint = const RPoint.min(),
    this.maxPoint = const RPoint.max(),
    this.closable = false,
    this.responsive = true,
  })  : assert(
          elevation == null || elevation >= 0,
          'Elevation cannot be less than 0',
        ),
        assert(
          maxPoint >= minPoint,
          'Max width must be greater than min width',
        );

  ///
  static RMenuTheme of(BuildContext context) => maybeOf(context)!;

  ///
  static RMenuTheme? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ResponsiveMenuTheme>()
        ?.theme;
  }

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
  final DividerThemeData? dividerAboveThemeData;

  ///
  final DividerThemeData? dividerBelowThemeData;

  ///
  final BoxDecoration? decoration;

  ///
  final EdgeInsetsGeometry itemMargin; //=>

  ///
  final RPoint minPoint; //=>

  ///
  final RPoint maxPoint; //=>

  /// default to false, if true menu will be hidden based on state
  final bool closable; //=>

  /// default to true, while resizing the screen menu state will be updated.
  final bool responsive;

  ///
  BorderRadius resolveRadius(TextDirection? direction) {
    if (radius != null) return radius!;
    return switch (indicatorShape) {
      RoundedRectangleBorder(:final borderRadius) =>
        borderRadius.resolve(direction),
      _ => BorderRadius.circular(minPoint.width * 0.5),
    };
  }
}

///
class RPoint extends Equatable {
  ///
  const RPoint.min({
    double? width,
    double? breakpoint,
    this.duration,
    this.reverseDuration,
    this.curve,
    this.reverseCurve,
  })  : width = width ?? _kRailWidth,
        breakpoint = breakpoint ?? _kSmallWidthBreakpoint,
        assert(
          width == null || width > 0,
          'Min width must be greater than 0',
        );

  ///
  const RPoint.max({
    double? width,
    double? breakpoint,
    this.duration,
    this.reverseDuration,
    this.curve,
    this.reverseCurve,
  })  : width = width ?? _kMenuWidth,
        breakpoint = breakpoint ?? _kMediumWidthBreakpoint,
        assert(
          width == null || width > 0,
          'Max width must be greater than 0',
        );

  /// Size
  final double width;

  ///
  final double breakpoint;

  /// Forward animation duration
  final Duration? duration;

  /// Reverse animation duration
  final Duration? reverseDuration;

  /// Forward animation curve
  final Curve? curve;

  /// Reverse animation curve
  final Curve? reverseCurve;

  @override
  List<Object?> get props => [
        width,
        breakpoint,
        duration,
        reverseDuration,
        curve,
        reverseCurve,
      ];
}

///
///
sealed class MenuState extends Equatable {
  const MenuState._({
    required this.value,
    this.point,
  });

  ///
  const factory MenuState.closed({RPoint? point}) = ClosedState;

  ///
  const factory MenuState.min({required double value, RPoint? point}) =
      MinState;

  ///
  const factory MenuState.max({RPoint? point}) = MaxState;

  ///
  final double value;

  ///
  final RPoint? point;
}

///
class ClosedState extends MenuState {
  ///
  const ClosedState({super.point}) : super._(value: 0);

  @override
  List<Object?> get props => ['closed'];
}

///
class MinState extends MenuState {
  ///
  const MinState({required super.value, super.point}) : super._();

  @override
  List<Object?> get props => ['min'];
}

///
class MaxState extends MenuState {
  ///
  const MaxState({super.point}) : super._(value: 1);

  @override
  List<Object?> get props => ['max'];
}

///
class ResponsiveMenuTheme extends InheritedWidget {
  ///
  const ResponsiveMenuTheme({
    required this.theme,
    required super.child,
    super.key,
  });

  ///
  final RMenuTheme theme;

  @override
  bool updateShouldNotify(covariant ResponsiveMenuTheme oldWidget) =>
      oldWidget.theme != theme;
}

///
extension RPointX on RPoint {
  ///
  bool operator >(RPoint other) => width > other.width;

  ///
  bool operator >=(RPoint other) => width >= other.width;

  ///
  bool operator <(RPoint other) => width < other.width;

  ///
  bool operator <=(RPoint other) => width <= other.width;

  ///
  double operator +(RPoint other) => width + other.width;

  ///
  double operator -(RPoint other) => width - other.width;
}

///
extension MenuStateX on MenuState {
  ///
  bool operator >(MenuState other) => value > other.value;

  ///
  bool operator <(MenuState other) => value < other.value;
}

///
extension RMenuThemeX on RMenuTheme {
  ///
  double get minWidth => minPoint.width + itemMargin.horizontal;

  ///
  double get railPercent => minWidth / maxPoint.width;

  ///
  MenuState get minState => MenuState.min(value: railPercent, point: minPoint);

  ///
  MenuState get maxState => MenuState.max(point: maxPoint);

  ///
  MenuState get closedState => const MenuState.closed();

  ///
  Iterable<MapEntry<MenuState, double>> get breakpoints => responsive
      ? [
          MapEntry(closedState, minPoint.breakpoint),
          MapEntry(minState, maxPoint.breakpoint),
        ]
      : [];
}
