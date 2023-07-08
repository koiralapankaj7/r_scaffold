// ignore_for_file: always_use_package_imports

import 'package:flutter/material.dart';

import 'r_menu_header.dart';
import 'r_menu_item.dart';
import 'r_menu_theme.dart';

///
@immutable
class RMenu {
  ///
  const RMenu({
    required this.items,
    this.type,
    this.header,
    this.leading,
    this.trailing,
    this.theme = const RMenuTheme(),
  });

  ///
  final RMenuType? type;

  ///
  final List<RMenuItem> items;

  ///
  final RMenuHeader? header;

  ///
  final Widget? leading;

  ///
  final Widget? trailing;

  ///
  final RMenuTheme theme;

  // ///
  // static ResponsiveMenu of(BuildContext context) => maybeOf(context)!;

  // ///
  // static ResponsiveMenu? maybeOf(BuildContext context) {
  //   return context
  //       .dependOnInheritedWidgetOfExactType<_ResponsiveMenuWrapper>()
  //       ?.menu;
  // }
}
