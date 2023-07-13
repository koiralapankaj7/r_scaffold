// ignore_for_file: always_use_package_imports

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'entities/entities.dart';

///
extension RAppBarX on AppBar {
  ///
  AppBar copyWith({
    Key? key,
    Widget? leading,
    bool? automaticallyImplyLeading,
    Widget? title,
    List<Widget>? actions,
    Widget? flexibleSpace,
    PreferredSizeWidget? bottom,
    double? elevation,
    double? scrolledUnderElevation,
    Color? shadowColor,
    Color? surfaceTintColor,
    Color? backgroundColor,
    Color? foregroundColor,
    IconThemeData? iconTheme,
    IconThemeData? actionsIconTheme,
    bool? primary,
    bool? centerTitle,
    bool? excludeHeaderSemantics,
    double? titleSpacing,
    ShapeBorder? shape,
    double? toolbarHeight,
    double? leadingWidth,
    TextStyle? toolbarTextStyle,
    TextStyle? titleTextStyle,
    SystemUiOverlayStyle? systemOverlayStyle,
    bool? forceMaterialTransparency,
    Clip? clipBehavior,
    double? toolbarOpacity,
    double? bottomOpacity,
    ScrollNotificationPredicate? notificationPredicate,
  }) {
    return AppBar(
      key: key ?? this.key,
      title: title ?? this.title,
      bottom: bottom ?? this.bottom,
      elevation: elevation ?? this.elevation,
      scrolledUnderElevation:
          scrolledUnderElevation ?? this.scrolledUnderElevation,
      shadowColor: shadowColor ?? this.shadowColor,
      surfaceTintColor: surfaceTintColor ?? this.surfaceTintColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      iconTheme: iconTheme ?? this.iconTheme,
      actionsIconTheme: actionsIconTheme ?? this.actionsIconTheme,
      primary: primary ?? this.primary,
      centerTitle: centerTitle ?? this.centerTitle,
      excludeHeaderSemantics:
          excludeHeaderSemantics ?? this.excludeHeaderSemantics,
      titleSpacing: titleSpacing ?? this.titleSpacing,
      shape: shape ?? this.shape,
      toolbarOpacity: toolbarOpacity ?? this.toolbarOpacity,
      bottomOpacity: bottomOpacity ?? this.bottomOpacity,
      toolbarHeight: toolbarHeight ?? this.toolbarHeight,
      leadingWidth: leadingWidth ?? this.leadingWidth,
      toolbarTextStyle: toolbarTextStyle ?? this.toolbarTextStyle,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      systemOverlayStyle: systemOverlayStyle ?? this.systemOverlayStyle,
      forceMaterialTransparency:
          forceMaterialTransparency ?? this.forceMaterialTransparency,
      actions: actions ?? this.actions,
      automaticallyImplyLeading:
          automaticallyImplyLeading ?? this.automaticallyImplyLeading,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      flexibleSpace: flexibleSpace ?? this.flexibleSpace,
      leading: leading ?? this.leading,
      notificationPredicate:
          notificationPredicate ?? this.notificationPredicate,
    );
  }
}

// ///
// extension ResponsiveMenuTypeX on RMenuType {
//   ///
//   bool get isDrawer => this == RMenuType.drawer;

//   ///
//   bool get isRail => this == RMenuType.rail;

//   ///
//   bool get isExtended => this == RMenuType.extended;

//   ///
//   bool operator >(RMenuType other) => value > other.value;

//   ///
//   bool operator <(RMenuType other) => value < other.value;
// }

// RMenuType.rail > RMenuType.drawer => true;

///
extension RIterableX on Iterable<RMenuItem> {
  ///
  Iterable<MapEntry<String, DefaultMItem>> get flatterned {
    final items = <MapEntry<String, DefaultMItem>>[];
    for (var i = 0; i < length; i++) {
      final item = elementAt(i);
      final res = switch (item) {
        DefaultMItem() => [MapEntry('$i', item)],
        DropdownMItem(:final items) => items.mapIndexed(
            (j, e) => MapEntry('$i:$j', e as DefaultMItem),
          ),
        _ => <MapEntry<String, DefaultMItem>>[],
      };
      items.addAll(res);
    }
    return items;
  }
}
