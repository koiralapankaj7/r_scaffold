// ignore_for_file: always_use_package_imports

import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../responsive_scaffold.dart';
import 'widgets.dart';

const _kDefaultHeight = 52.0;

///
typedef RMenuItemBuilder = Widget Function(
  BuildContext context,
  VoidCallback toogle,
);

//
// ==============================RMenuItem=================================
//

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
    EdgeInsetsGeometry margin,
    VoidCallback? onPressed,
    Widget? selectedIcon,
    bool selected,
    bool enabled,
    double height,
  }) = _DefaultMItem;

  ///
  const RMenuItem._({
    this.dividerAbove = false,
    this.dividerBelow = false,
    this.dividerAboveThemeData,
    this.dividerBelowThemeData,
    this.tooltip,
    this.margin,
  });

  ///
  const factory RMenuItem.dropdown({
    required List<RMenuItem> items,
    RMenuItemBuilder? builder,
    Widget? leading,
    Widget? title,
    Widget? trailing,
    bool dividerAbove,
    bool dividerBelow,
    DividerThemeData? dividerAboveThemeData,
    DividerThemeData? dividerBelowThemeData,
    EdgeInsetsGeometry margin,
    double height,
  }) = _DropdownMItem;

  ///
  const factory RMenuItem.custom({
    required WidgetBuilder builder,
    bool dividerAbove,
    bool dividerBelow,
    DividerThemeData? dividerAboveThemeData,
    DividerThemeData? dividerBelowThemeData,
  }) = _CustomMItem;

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

  ///
  final EdgeInsetsGeometry? margin;
}

///
interface class _DefaultMItem extends RMenuItem {
  ///
  const _DefaultMItem({
    required this.label,
    required this.icon,
    super.tooltip,
    super.dividerAbove,
    super.dividerBelow,
    super.dividerAboveThemeData,
    super.dividerBelowThemeData,
    super.margin,
    this.padding,
    this.onPressed,
    Widget? selectedIcon,
    this.selected = false,
    this.enabled = true,
    this.height = _kDefaultHeight,
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
interface class _DropdownMItem extends RMenuItem {
  ///
  const _DropdownMItem({
    required this.items,
    this.builder,
    this.leading,
    this.title,
    this.trailing,
    super.dividerAbove,
    super.dividerBelow,
    super.dividerAboveThemeData,
    super.dividerBelowThemeData,
    super.margin,
    this.height = _kDefaultHeight,
  }) : super._();

  ///
  final List<RMenuItem> items;

  ///
  final RMenuItemBuilder? builder;

  ///
  final Widget? leading;

  ///
  final Widget? title;

  ///
  final Widget? trailing;

  ///
  final double height;
}

///
interface class _CustomMItem extends RMenuItem {
  ///
  const _CustomMItem({
    required this.builder,
    super.dividerAbove,
    super.dividerBelow,
    super.dividerAboveThemeData,
    super.dividerBelowThemeData,
  }) : super._();

  ///
  final WidgetBuilder builder;
}

//
// ==============================RMenuTheme=================================
//

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

//
// ==============================ResponsiveMenu=================================
//

///
class ResponsiveMenu extends StatefulWidget {
  ///
  const ResponsiveMenu({
    required this.items,
    required this.header,
    required this.leading,
    required this.trailing,
    required this.theme,
    required this.onTap,
    super.key,
  });

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

  ///
  final VoidCallback? onTap;

  @override
  State<ResponsiveMenu> createState() => _ResponsiveMenuState();
}

class _ResponsiveMenuState extends State<ResponsiveMenu>
    with TickerProviderStateMixin {
  String? _selectedItem;
  final Map<String, AnimationController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  @override
  void didUpdateWidget(covariant ResponsiveMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newItems = widget.items.flatterned;
    // No animated segue if the length of the items list changes.
    if (newItems.length != oldWidget.items.flatterned.length) {
      _resetState();
      return;
    }
    final selected = newItems.firstWhereOrNull((e) => e.value.selected);
    if (selected != null && selected.key != _selectedItem) {
      _controllers[_selectedItem]?.reverse();
      _controllers[selected.key]?.forward();
      setState(() {
        _selectedItem = selected.key;
      });
    }
  }

  void _initControllers() {
    String? firstItem;
    for (final item in widget.items.flatterned) {
      firstItem ??= item.key;
      final controller = AnimationController(
        duration: kThemeAnimationDuration,
        vsync: this,
      )..addListener(_rebuild);
      _controllers[item.key] = controller;
      _selectedItem ??= item.value.selected ? item.key : null;
    }

    if (_selectedItem == null && firstItem != null) {
      _selectedItem = firstItem;
    }

    _controllers[_selectedItem]!.value = 1.0;
  }

  void _rebuild() {
    setState(() {
      // Rebuilding when any of the controllers tick, i.e. when the items are
      // animating.
    });
  }

  void _resetState() {
    _disposeControllers();
    _initControllers();
  }

  void _disposeControllers() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
  }

  void _onItemSelected(String id, _DefaultMItem item) {
    _controllers[_selectedItem]?.reverse();
    _controllers[id]?.forward();
    // _ItemSelectNotification(item).dispatch(context);
    setState(() {
      _selectedItem = id;
    });
    item.onPressed?.call();
    widget.onTap?.call();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final isRTLDirection = Directionality.of(context) == TextDirection.rtl;

    Widget child = Material(
      elevation: math.max(0, widget.theme.elevation ?? 0.0),
      color: widget.theme.backgroundColor,
      child: SafeArea(
        right: isRTLDirection,
        left: !isRTLDirection,
        child: Column(
          children: <Widget>[
            // Menu header
            if (widget.header != null) widget.header!,

            // Leading
            if (widget.leading != null) widget.leading!,

            // Content
            Expanded(
              child: ListView(
                physics: const ClampingScrollPhysics(),
                children: List.generate(widget.items.length, (i) {
                  final item = widget.items[i];
                  final sth = switch (item) {
                    _CustomMItem(:final builder) => MenuItemDivider(
                        item: item,
                        child: builder(context),
                      ),
                    _DropdownMItem(:final items) => _MenuItemDropdown(
                        item: item,
                        children: items.mapIndexed((index, item) {
                          final id = '$i:$index';
                          return _MenuItem(
                            id: id,
                            item: item as _DefaultMItem,

                            // _menuController.sizeAnimation,
                            selected: _selectedItem == id,
                            destinationAnimation: _controllers[id]!.view,
                            onTap: () => _onItemSelected(id, item),
                            indexLabel: localizations.tabLabel(
                              tabIndex: index + 1,
                              tabCount: widget.items.length,
                            ),
                          );
                        }),
                      ),
                    _DefaultMItem() => _MenuItem(
                        id: '$i',
                        item: item,
                        selected: _selectedItem == '$i',
                        destinationAnimation: _controllers['$i']!.view,
                        onTap: () => _onItemSelected('$i', item),
                        indexLabel: localizations.tabLabel(
                          tabIndex: i + 1,
                          tabCount: widget.items.length,
                        ),
                      ),
                    _ => const SizedBox(),
                  };

                  return sth;
                }),
              ),
            ),

            // Trailing
            if (widget.trailing != null) widget.trailing!,
          ],
        ),
      ),
    );

    if (widget.theme.decoration != null) {
      child = DecoratedBox(
        decoration: widget.theme.decoration!,
        child: child,
      );
    }

    return Semantics(
      explicitChildNodes: true,
      child: child,
    );
  }
}

//
// ================================MenuItem===================================
//

///
class _MenuItem extends StatefulWidget {
  ///
  const _MenuItem({
    required this.id,
    required this.item,
    required this.destinationAnimation,
    required this.selected,
    required this.onTap,
    required this.indexLabel,
  });

  ///
  final String id;

  ///
  final _DefaultMItem item;

  ///
  final Animation<double> destinationAnimation;

  ///
  final bool selected;

  ///
  final VoidCallback onTap;

  ///
  final String indexLabel;

  @override
  State<_MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<_MenuItem> {
  @override
  void didUpdateWidget(covariant _MenuItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.item.selected != oldWidget.item.selected) {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    final menuTheme = RMenuQuery.themeOf(context);
    // final maxSize = RMenuQuery.maxWidthOf(context);
    // final minSize = RMenuQuery.minWidthOf(context);

    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final iconColor = isLight
        ? Color.alphaBlend(
            theme.colorScheme.primary.withAlpha(0x99),
            theme.colorScheme.onSurface,
          )
        : Color.alphaBlend(
            theme.colorScheme.primary.withAlpha(0x7F),
            theme.colorScheme.onSurface,
          );

    final colors = Theme.of(context).colorScheme;

    final unselectedLabelTextStyle = menuTheme.unselectedLabelTextStyle ??
        theme.textTheme.bodyLarge!.copyWith(color: theme.hintColor);

    final selectedLabelTextStyle = menuTheme.selectedLabelTextStyle ??
        theme.textTheme.bodyLarge!.copyWith(
          color: theme.colorScheme.onSurface.withAlpha(0xCC),
        );

    final disabledLabelTextStyle = menuTheme.disabledLabelTextStyle ??
        theme.textTheme.bodyLarge!.copyWith(color: theme.disabledColor);

    final unselectedIconTheme = menuTheme.unselectedIconTheme ??
        theme.iconTheme.copyWith(color: theme.hintColor);

    final disabledIconTheme = menuTheme.disabledIconTheme ??
        theme.iconTheme.copyWith(
          color: theme.disabledColor,
        );

    final selectedIconTheme = menuTheme.selectedIconTheme ??
        theme.iconTheme.copyWith(color: iconColor);

    final borderRadius = RMenuQuery.borderRadiusOf(
      context,
      direction: Directionality.of(context),
    );

    final child = RMenuItemLayout(
      height: widget.item.height,
      margin: widget.item.margin ??
          const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 2,
          ),
      builder: (child) {
        return Semantics(
          container: true,
          selected: widget.selected,
          child: Stack(
            children: <Widget>[
              MenuItemIndicator(
                indicatorAnimation: widget.destinationAnimation,
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: widget.item.enabled ? () => widget.onTap() : null,
                    borderRadius: borderRadius,
                    customBorder: menuTheme.indicatorShape,
                    splashColor: colors.primary.withOpacity(0.12),
                    hoverColor: colors.primary.withOpacity(0.06),
                    child: Padding(
                      padding: widget.item.padding ?? EdgeInsets.zero,
                      child: child,
                    ),
                  ),
                ),
              ),
              Semantics(label: widget.indexLabel),
            ],
          ),
        );
      },
      icon: IconTheme(
        data: !widget.item.enabled
            ? disabledIconTheme
            : widget.selected
                ? selectedIconTheme
                : unselectedIconTheme,
        child: widget.selected ? widget.item.selectedIcon : widget.item.icon,
      ),
      child: DefaultTextStyle(
        style: !widget.item.enabled
            ? disabledLabelTextStyle
            : widget.selected
                ? selectedLabelTextStyle
                : unselectedLabelTextStyle,
        maxLines: 1,
        child: widget.item.label,
      ),
    );

    if (widget.item.dividerAbove || widget.item.dividerBelow) {
      return MenuItemDivider(item: widget.item, child: child);
    }

    return child;
  }
}

//
// =============================MenuItemDropdown================================
//

///
class _MenuItemDropdown extends StatefulWidget {
  ///
  const _MenuItemDropdown({
    required this.item,
    required this.children,
  });

  ///
  final _DropdownMItem item;

  ///
  final Iterable<Widget> children;

  @override
  State<_MenuItemDropdown> createState() => _MenuItemDropdownState();
}

class _MenuItemDropdownState extends State<_MenuItemDropdown> {
  bool _collapsed = true;

  void _toogle() {
    setState(() {
      _collapsed = !_collapsed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        MenuItemDivider(
          item: widget.item,
          child: RMenuItemLayout(
            height: widget.item.height,
            margin: widget.item.margin,
            builder: (child) {
              return InkWell(
                onTap: () {
                  setState(() {
                    _collapsed = !_collapsed;
                  });
                },
                child: child,
              );
            },
            icon: widget.item.leading,
            child: widget.item.builder?.call(context, _toogle) ??
                Row(
                  children: [
                    // Title
                    Expanded(
                      child: FadeTransition(
                        alwaysIncludeSemantics: true,
                        opacity: RMenuQuery.fadeAnimationOf(context),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: DefaultTextStyle(
                            style: Theme.of(context).textTheme.titleMedium!,
                            maxLines: 1,
                            child: widget.item.title ?? const SizedBox.shrink(),
                          ),
                        ),
                      ),
                    ),

                    // Expanded icon
                    ExpandIcon(
                      isExpanded: !_collapsed,
                      padding: EdgeInsets.zero,
                      onPressed: (_) => _toogle(),
                    ),
                  ],
                ),
          ),
        ),

        // Items
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return SizeTransition(
              sizeFactor: animation,
              child: child,
            );
          },
          child: _collapsed
              ? const SizedBox.shrink()
              : Column(children: widget.children.toList()),
        ),
      ],
    );
  }
}

//
// ===============================MenuItemLayout================================
//

///
class RMenuItemLayout extends StatelessWidget {
  ///
  const RMenuItemLayout({
    required this.builder,
    this.icon,
    this.child,
    this.height,
    this.margin,
    super.key,
  });

  ///
  final Widget Function(Widget child) builder;

  ///
  final Widget? icon;

  ///
  final Widget? child;

  ///
  final double? height;

  ///
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final marginSpace = margin?.horizontal ?? 0.0;

    Widget updatedChild = ClipRect(
      child: builder(
        OverflowBox(
          alignment: Alignment.centerLeft,
          maxWidth: RMenuQuery.maxWidthOf(context) - marginSpace,
          child: Row(
            children: [
              // Leading Icon
              if (icon != null)
                SizedBox(
                  width: RMenuQuery.minWidthOf(context) - marginSpace,
                  child: icon,
                ),

              // Remaining body
              Expanded(
                child: FadeTransition(
                  alwaysIncludeSemantics: true,
                  opacity: RMenuQuery.fadeAnimationOf(context),
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (height != null) {
      updatedChild = SizedBox(
        height: height,
        child: updatedChild,
      );
    } else {
      updatedChild = IntrinsicHeight(
        child: updatedChild,
      );
    }

    if (margin != null) {
      return Padding(
        padding: margin!,
        child: updatedChild,
      );
    }

    return updatedChild;
  }
}

//
// ===================================================================
//

///
extension on Iterable<RMenuItem> {
  ///
  Iterable<MapEntry<String, _DefaultMItem>> get flatterned {
    final items = <MapEntry<String, _DefaultMItem>>[];
    for (var i = 0; i < length; i++) {
      final item = elementAt(i);
      final res = switch (item) {
        _DefaultMItem() => [MapEntry('$i', item)],
        _DropdownMItem(:final items) => items.mapIndexed(
            (j, e) => MapEntry('$i:$j', e as _DefaultMItem),
          ),
        _ => <MapEntry<String, _DefaultMItem>>[],
      };
      items.addAll(res);
    }
    return items;
  }
}

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
