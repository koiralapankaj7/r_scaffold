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
    required this.menu,
    required this.extendedAnimation,
    required this.onTap,
    super.key,
  });

  ///
  final RMenu menu;

  ///
  final Animation<double> extendedAnimation;

  ///
  final ValueChanged<DefaultMItem> onTap;

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
    final newItems = widget.menu.items.flatterned;
    // No animated segue if the length of the items list changes.
    if (newItems.length != oldWidget.menu.items.flatterned.length) {
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
    for (final item in widget.menu.items.flatterned) {
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

  void _onItemSelected(MenuItem item) {
    _controllers[_selectedItem]?.reverse();
    _controllers[item.id]?.forward();
    // _ItemSelectNotification(item).dispatch(context);
    setState(() {
      _selectedItem = item.id;
    });
    widget.onTap(item.item);
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

    final child = Semantics(
      explicitChildNodes: true,
      child: Material(
        elevation: math.max(0, widget.menu.theme.elevation ?? 0.0),
        color: widget.menu.theme.backgroundColor,
        child: SafeArea(
          right: isRTLDirection,
          left: !isRTLDirection,
          child: Column(
            children: <Widget>[
              if (widget.menu.header != null) ...[
                const SizedBox(height: 8),
                MenuHeader(
                  menu: widget.menu,
                  extendedAnimation: widget.extendedAnimation,
                ),
                const SizedBox(height: 12),
              ],

              // Leading
              if (widget.menu.leading != null) widget.menu.leading!,

              // Content
              Expanded(
                child: ListView(
                  children: List.generate(widget.menu.items.length, (i) {
                    final item = widget.menu.items[i];
                    final sth = switch (item) {
                      CustomMItem(:final builder) => MenuItemDivider(
                          item: item,
                          child: builder(context, widget.extendedAnimation),
                        ),
                      DropdownMItem(:final builder, :final items) =>
                        MenuItemDropdown(
                          item: item,
                          header: builder(context, widget.extendedAnimation),
                          children: items.mapIndexed((index, item) {
                            final id = '$i:$index';
                            return MenuItem(
                              id: id,
                              menu: widget.menu,
                              item: item as DefaultMItem,
                              extendedTransitionAnimation:
                                  widget.extendedAnimation,
                              selected: _selectedItem == id,
                              destinationAnimation: _controllers[id]!.view,
                              onTap: _onItemSelected,
                              indexLabel: localizations.tabLabel(
                                tabIndex: index + 1,
                                tabCount: widget.menu.items.length,
                              ),
                            );
                          }),
                        ),
                      DefaultMItem() => MenuItem(
                          id: '$i',
                          menu: widget.menu,
                          item: item,
                          extendedTransitionAnimation: widget.extendedAnimation,
                          selected: _selectedItem == '$i',
                          destinationAnimation: _controllers['$i']!.view,
                          onTap: _onItemSelected,
                          indexLabel: localizations.tabLabel(
                            tabIndex: i + 1,
                            tabCount: widget.menu.items.length,
                          ),
                        ),
                      _ => const SizedBox(),
                    };

                    return sth;
                  }),
                ),
              ),

              // Trailing
              if (widget.menu.trailing != null) widget.menu.trailing!,
            ],
          ),
        ),
      ),
    );

    if (widget.menu.theme.decoration != null) {
      return DecoratedBox(
        decoration: widget.menu.theme.decoration!,
        child: child,
      );
    }

    return child;
  }
}
