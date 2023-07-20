// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  const RMenuTheme({
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
  });

  // ///
  // static RMenuTheme of(BuildContext context) => maybeOf(context)!;

  // ///
  // static RMenuTheme? maybeOf(BuildContext context) {
  //   return context
  //       .dependOnInheritedWidgetOfExactType<ResponsiveMenuTheme>()
  //       ?.theme;
  // }

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
  BorderRadius resolveRadius(TextDirection? direction) {
    if (radius != null) return radius!;
    // return switch (indicatorShape) {
    //   RoundedRectangleBorder(:final borderRadius) =>
    //     borderRadius.resolve(direction),
    //   _ => BorderRadius.circular(minSize.width * 0.5),
    // };
    return BorderRadius.circular(8);
  }

  ///
  RMenuTheme copyWith({
    Color? backgroundColor,
    double? elevation,
    TextStyle? unselectedLabelTextStyle,
    TextStyle? selectedLabelTextStyle,
    TextStyle? disabledLabelTextStyle,
    IconThemeData? unselectedIconTheme,
    IconThemeData? selectedIconTheme,
    IconThemeData? disabledIconTheme,
    bool? useIndicator,
    Color? indicatorColor,
    ShapeBorder? indicatorShape,
    BorderRadius? radius,
    DividerThemeData? dividerAboveThemeData,
    DividerThemeData? dividerBelowThemeData,
    BoxDecoration? decoration,
    bool? responsive,
    bool? closable,
    RSize? minSize,
    RSize? maxSize,
  }) {
    return RMenuTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      elevation: elevation ?? this.elevation,
      unselectedLabelTextStyle:
          unselectedLabelTextStyle ?? this.unselectedLabelTextStyle,
      selectedLabelTextStyle:
          selectedLabelTextStyle ?? this.selectedLabelTextStyle,
      disabledLabelTextStyle:
          disabledLabelTextStyle ?? this.disabledLabelTextStyle,
      unselectedIconTheme: unselectedIconTheme ?? this.unselectedIconTheme,
      selectedIconTheme: selectedIconTheme ?? this.selectedIconTheme,
      disabledIconTheme: disabledIconTheme ?? this.disabledIconTheme,
      useIndicator: useIndicator ?? this.useIndicator,
      indicatorColor: indicatorColor ?? this.indicatorColor,
      indicatorShape: indicatorShape ?? this.indicatorShape,
      radius: radius ?? this.radius,
      dividerAboveThemeData:
          dividerAboveThemeData ?? this.dividerAboveThemeData,
      dividerBelowThemeData:
          dividerBelowThemeData ?? this.dividerBelowThemeData,
      decoration: decoration ?? this.decoration,
    );
  }
}

///
class RSize extends Equatable {
  ///
  const RSize({
    required this.width,
    required this.breakpoint,
    this.duration,
    this.reverseDuration,
    this.curve,
    this.reverseCurve,
  });

  /// Default min point
  static const RSize min = RSize(
    width: _kRailWidth,
    breakpoint: _kSmallWidthBreakpoint,
  );

  /// Defauult max point
  static const RSize max = RSize(
    width: _kMenuWidth,
    breakpoint: _kMediumWidthBreakpoint,
  );

  /// Width of the menu
  final double width;

  /// Screen breakpoint to trigger this size
  final double breakpoint;

  /// Forward animation duration
  final Duration? duration;

  /// Reverse animation duration
  final Duration? reverseDuration;

  /// Forward animation curve
  final Curve? curve;

  /// Reverse animation curve
  final Curve? reverseCurve;

  /// Helper function to copy object
  RSize copyWith({
    double? width,
    double? breakpoint,
    Duration? duration,
    Duration? reverseDuration,
    Curve? curve,
    Curve? reverseCurve,
  }) {
    return RSize(
      width: width ?? this.width,
      breakpoint: breakpoint ?? this.breakpoint,
      duration: duration ?? this.duration,
      reverseDuration: reverseDuration ?? this.reverseDuration,
      curve: curve ?? this.curve,
      reverseCurve: reverseCurve ?? this.reverseCurve,
    );
  }

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

enum MenuState { closed, min, max }

///
extension RSizeX on RSize {
  ///
  bool operator >(RSize other) => width > other.width;

  ///
  bool operator >=(RSize other) => width >= other.width;

  ///
  bool operator <(RSize other) => width < other.width;

  ///
  bool operator <=(RSize other) => width <= other.width;

  ///
  double operator +(RSize other) => width + other.width;

  ///
  double operator -(RSize other) => width - other.width;
}

// ///
// extension MenuStateX on MenuState {
//   ///
//   bool operator >(MenuState other) => value > other.value;

//   ///
//   bool operator <(MenuState other) => value < other.value;
// }

///
// extension RMenuThemeX on RMenuTheme {
  // ///
  // double get minWidth => minSize.width + itemMargin.horizontal;

  // ///
  // double get railPercent => minWidth / maxSize.width;

  ///
  // MenuState get minState => MenuState.min(value: railPercent, point: minSize);

  // ///
  // MenuState get maxState => MenuState.max(point: maxSize);

  // ///
  // MenuState get closedState => const MenuState.closed();

  // ///
  // Iterable<MapEntry<MenuState, double>> get breakpoints => responsive
  //     ? [
  //         MapEntry(MenuState.closed, minSize.breakpoint),
  //         MapEntry(MenuState.min, maxSize.breakpoint),
  //       ]
  //     : [];
// }
