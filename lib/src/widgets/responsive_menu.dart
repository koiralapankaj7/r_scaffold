// ignore_for_file: always_use_package_imports

import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:playground/src/extensions.dart';

import '../entities/entities.dart';
import 'widgets.dart';

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
  final ResponsiveMenuHeader? header;

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

  void _onItemSelected(String id, DefaultMItem item) {
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
                    CustomMItem(:final builder) => MenuItemDivider(
                        item: item,
                        child: builder(context),
                      ),
                    DropdownMItem(:final items) => MenuItemDropdown(
                        item: item,
                        children: items.mapIndexed((index, item) {
                          final id = '$i:$index';
                          return MenuItem(
                            id: id,
                            item: item as DefaultMItem,

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
                    DefaultMItem() => MenuItem(
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
