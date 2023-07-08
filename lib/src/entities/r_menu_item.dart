import 'package:flutter/material.dart';

///
typedef RMenuItemBuilder = Widget Function(
  BuildContext context,
  Animation<double> animation,
);

///
@immutable
abstract interface class RMenuItem {
  ///
  const factory RMenuItem({
    required Widget label,
    required Widget icon,
    String? tooltip,
    bool dividerAbove,
    bool dividerBelow,
    DividerThemeData? dividerAboveThemeData,
    DividerThemeData? dividerBelowThemeData,
    EdgeInsetsGeometry? padding,
    VoidCallback? onPressed,
    Widget? selectedIcon,
    bool selected,
    bool enabled,
    double height,
  }) = DefaultMItem;

  ///
  const RMenuItem._({
    this.dividerAbove = false,
    this.dividerBelow = false,
    this.dividerAboveThemeData,
    this.dividerBelowThemeData,
    this.tooltip,
  });

  ///
  const factory RMenuItem.dropdown({
    required RMenuItemBuilder builder,
    required List<RMenuItem> items,
    bool dividerAbove,
    bool dividerBelow,
    DividerThemeData? dividerAboveThemeData,
    DividerThemeData? dividerBelowThemeData,
  }) = DropdownMItem;

  ///
  const factory RMenuItem.custom({
    required RMenuItemBuilder builder,
    bool dividerAbove,
    bool dividerBelow,
    DividerThemeData? dividerAboveThemeData,
    DividerThemeData? dividerBelowThemeData,
  }) = CustomMItem;

  ///
  final bool dividerAbove;

  ///
  final bool dividerBelow;

  ///
  final DividerThemeData? dividerAboveThemeData;

  ///
  final DividerThemeData? dividerBelowThemeData;

  ///
  final String? tooltip;
}

///
interface class DefaultMItem extends RMenuItem {
  ///
  const DefaultMItem({
    required this.label,
    required this.icon,
    super.tooltip,
    super.dividerAbove,
    super.dividerBelow,
    super.dividerAboveThemeData,
    super.dividerBelowThemeData,
    this.padding,
    this.onPressed,
    Widget? selectedIcon,
    this.selected = false,
    this.enabled = true,
    this.height = 52.0,
  })  : selectedIcon = selectedIcon ?? icon,
        super._();

  ///
  final EdgeInsetsGeometry? padding;

  ///
  final VoidCallback? onPressed;

  ///
  final Widget selectedIcon;

  ///
  final Widget label;

  ///
  final Widget icon;

  ///
  final bool selected;

  ///
  final bool enabled;

  ///
  final double height;
}

///
interface class DropdownMItem extends RMenuItem {
  ///
  const DropdownMItem({
    required this.builder,
    required this.items,
    super.dividerAbove,
    super.dividerBelow,
    super.dividerAboveThemeData,
    super.dividerBelowThemeData,
  }) : super._();

  ///
  final RMenuItemBuilder builder;

  ///
  final List<RMenuItem> items;
}

///
interface class CustomMItem extends RMenuItem {
  ///
  const CustomMItem({
    required this.builder,
    super.dividerAbove,
    super.dividerBelow,
    super.dividerAboveThemeData,
    super.dividerBelowThemeData,
  }) : super._();

  ///
  final RMenuItemBuilder builder;
}
