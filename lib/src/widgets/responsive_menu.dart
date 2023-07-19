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
    this.header,
    this.leading,
    this.trailing,
    RMenuTheme? theme,
    this.controller,
    this.onTap,
    super.key,
  }) : theme = theme ?? const RMenuTheme();

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

  ///
  final RMenuController? controller;

  @override
  State<ResponsiveMenu> createState() => _ResponsiveMenuState();
}

class _ResponsiveMenuState extends State<ResponsiveMenu>
    with TickerProviderStateMixin, BreakpointAware<ResponsiveMenu, MenuState> {
  String? _selectedItem;
  final Map<String, AnimationController> _controllers = {};
  late RMenuController _menuController;

  @override
  void initState() {
    super.initState();
    _menuController = (widget.controller ?? RMenuController())
      .._init(
        vsync: this,
        menuTheme: widget.theme,
      );
    _initControllers();
  }

  @override
  Iterable<MapEntry<MenuState, double>> get breakpoints =>
      widget.theme.breakpoints;

  @override
  void onBreakpointInit(MapEntry<MenuState, double>? breakpoint) =>
      _menuController._onBreakpointInit(breakpoint);

  @override
  void onBreakpointChange(
    MapEntry<MenuState, double>? breakpoint,
    bool forward,
  ) =>
      _menuController._onBreakpointChange(breakpoint, forward);

  @override
  void didUpdateWidget(covariant ResponsiveMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.theme != oldWidget.theme) {
      _menuController._update(widget.theme);
    }
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
    if (widget.controller == null) {
      _menuController.dispose();
    }
    print('R Menu Disposed ====>>>> ');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    assert(
      widget.theme.elevation == null || widget.theme.elevation! >= 0,
      'Elevation cannot be less than 0',
    );
    assert(
      widget.theme.maxSize >= widget.theme.minSize,
      'Max width must be greater than min width',
    );

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
                            menuTheme: widget.theme,
                            item: item as DefaultMItem,
                            extendedTransitionAnimation:
                                _menuController.sizeAnimation,
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
                        menuTheme: widget.theme,
                        item: item,
                        extendedTransitionAnimation:
                            _menuController.sizeAnimation,
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

    return AnimatedBuilder(
      animation: _menuController.animation,
      builder: (context, child) {
        final minWidth = _menuController.minWidth;
        final maxWidth = _menuController.maxWidth;

        final dx = -minWidth * (1 - _menuController._positionAnimation.value);
        final width = (minWidth * _menuController._positionAnimation.value) +
            (maxWidth - minWidth) * _menuController._sizeAnimation.value;

        print(
          '${_menuController.positionAnimation.value} : ${_menuController.sizeAnimation.value}',
        );
        return Transform.translate(
          offset: Offset(dx, 0),
          child: SizedBox(
            width: width,
            child: child,
          ),
        );
      },
      child: ResponsiveMenuTheme(
        theme: widget.theme,
        child: _ExtendedNavigationRailAnimation(
          controller: _menuController,
          child: Semantics(
            explicitChildNodes: true,
            child: child,
          ),
        ),
      ),
    );
  }
}

///
class RMenuController extends Listenable with ChangeNotifier {
  ///
  static RMenuController of(BuildContext context) => maybeOf(context)!;

  ///
  static RMenuController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_ExtendedNavigationRailAnimation>()
        ?.controller;
  }

  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  late Animation<double> _positionAnimation;
  late RMenuTheme _menuTheme;
  MenuState _currentState = const MenuState.closed();
  VoidCallback? _animationListener;

  // Animation<double>? _maxWidth;
  // Animation<double>? _minWidth;

  int _direction = -1;

  ///
  void _init({
    required TickerProvider vsync,
    required RMenuTheme menuTheme,
  }) {
    _menuTheme = menuTheme;
    _currentState = menuTheme.maxState;
    _controller = AnimationController(
      duration: kThemeAnimationDuration,
      value: _currentState.value,
      vsync: vsync,
    );
    _initAnimations();
    notifyListeners();
  }

  ///
  void _initAnimations() {
    _positionAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0,
          _menuTheme.railPercent,
          curve: Curves.easeIn,
        ),
      ),
    );
    _sizeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          _menuTheme.railPercent,
          1,
          curve: Curves.easeIn,
        ),
      ),
    );
    print('Test... ${_positionAnimation.value} : ${_sizeAnimation.value}');
  }

  ///
  void _update(RMenuTheme menuTheme) {
    if (_menuTheme.maxSize.width != menuTheme.maxSize.width &&
        _currentState == _menuTheme.maxState) {
      // _onMaxWidthChange(menuTheme);
      _initAnimations();
    } else if ((_menuTheme.minSize.width != menuTheme.minSize.width ||
            _menuTheme.itemMargin.horizontal !=
                menuTheme.itemMargin.horizontal) &&
        _currentState == _menuTheme.minState) {
      // _onMinWidthChange(menuTheme);
      _initAnimations();
    }
    _menuTheme = menuTheme;
    notifyListeners();
  }

  // ///
  // void _holdAnimations() {
  //   // Hold size animation
  //   _sizeAnimation = Tween<double>(
  //     begin: _sizeAnimation.value,
  //     end: _sizeAnimation.value,
  //   ).animate(_controller);

  //   // Hold position animation
  //   _positionAnimation = Tween<double>(
  //     begin: _positionAnimation.value,
  //     end: _positionAnimation.value,
  //   ).animate(_controller);
  // }

  // ///
  // void _holdSizes({bool max = true, bool min = true}) {
  //   // Hold max width
  //   if (_maxWidth != null && max) {
  //     _maxWidth = Tween<double>(
  //       begin: _maxWidth!.value,
  //       end: _maxWidth!.value,
  //     ).animate(_controller);
  //   }

  //   // Hold min width
  //   if (_minWidth != null && min) {
  //     _minWidth = Tween<double>(
  //       begin: _minWidth!.value,
  //       end: _minWidth!.value,
  //     ).animate(_controller);
  //   }
  // }

  // ///
  // void _onMaxWidthChange(RMenuTheme menuTheme) {
  //   _maxWidth = Tween<double>(
  //     begin: _menuTheme.maxSize.width,
  //     end: menuTheme.maxSize.width,
  //   ).animate(
  //     CurvedAnimation(
  //       parent: _controller,
  //       curve: Curves.easeIn,
  //     ),
  //   );
  //   _holdSizes(max: false);
  //   _holdAnimations();
  //   _controller
  //     ..reset()
  //     ..forward();
  // }

  // ///
  // void _onMinWidthChange(RMenuTheme menuTheme) {
  //   _minWidth = Tween<double>(
  //     begin: _menuTheme.minWidth,
  //     end: menuTheme.minWidth,
  //   ).animate(
  //     CurvedAnimation(
  //       parent: _controller,
  //       curve: Curves.easeIn,
  //     ),
  //   );
  //   _holdSizes(min: false);
  //   _holdAnimations();
  //   _controller
  //     ..reset()
  //     ..forward();
  // }

  ///
  void _onBreakpointInit(MapEntry<MenuState, double>? breakpoint) {
    final stateBasedOnSize = breakpoint?.key ?? _menuTheme.maxState;
    if (stateBasedOnSize == _currentState) return;
    _currentState = stateBasedOnSize;
    _direction = _currentState == _menuTheme.maxState ? -1 : 1;
    _initAnimations();
    _controller.value = _currentState.value;
    notifyListeners();
  }

  ///
  void _onBreakpointChange(
    MapEntry<MenuState, double>? breakpoint,
    bool forward,
  ) {
    _direction = forward ? 1 : -1;
    _updateState(breakpoint?.key ?? _menuTheme.maxState);
  }

  ///
  void _updateState(MenuState state) {
    if (_controller.isAnimating || _currentState == state) return;
    TickerFuture ticker;

    if (_direction.isNegative) {
      ticker = _controller.animateBack(
        state.value,
        duration: state.point?.reverseDuration ?? kThemeAnimationDuration,
        curve: state.point?.reverseCurve ?? Curves.easeOut,
      );
    } else {
      ticker = _controller.animateTo(
        state.value,
        duration: state.point?.duration ?? kThemeAnimationDuration,
        curve: state.point?.curve ?? Curves.easeIn,
      );
    }
    ticker.then((_) {
      _currentState = state;
      notifyListeners();
    });
  }

  //  ============================== PUBLIC API's ==============================

  ///
  Animation<double> get animation => _controller.view;

  ///
  Animation<double> get sizeAnimation => _sizeAnimation;

  ///
  Animation<double> get positionAnimation => _positionAnimation;

  ///
  Animation<double> get fadeAnimation => _sizeAnimation.drive(
        CurveTween(curve: const Interval(0.20, 1)),
      );

  ///
  MenuState get currentState => _currentState;

  ///
  double get minWidth => _menuTheme.minWidth;

  ///
  double get maxWidth => _menuTheme.maxSize.width;

  ///
  void addAnimationListener(VoidCallback listener) {
    _controller.addListener(listener);
    _animationListener = listener;
  }

  /// Toggle between the [states]
  /// Default states goes from min-max
  void toggle({List<MenuState>? states}) {
    final defaultStates = states ??
        [
          if (_menuTheme.closable) _menuTheme.closedState,
          _menuTheme.minState,
          _menuTheme.maxState,
        ];
    final cuttentIndex = defaultStates.indexOf(_currentState);
    if (cuttentIndex == 0 && _direction == -1) {
      _direction = 1;
    } else if (cuttentIndex == defaultStates.length - 1 && _direction == 1) {
      _direction = -1;
    }
    // _holdSizes();
    // _initAnimations();
    _updateState(defaultStates[cuttentIndex + _direction]);
  }

  @override
  void dispose() {
    if (_animationListener != null) {
      _controller.removeListener(_animationListener!);
    }
    _controller.dispose();
    super.dispose();
  }
}

class _ExtendedNavigationRailAnimation extends InheritedWidget {
  const _ExtendedNavigationRailAnimation({
    required this.controller,
    required super.child,
  });

  final RMenuController controller;

  @override
  bool updateShouldNotify(_ExtendedNavigationRailAnimation old) =>
      controller != old.controller;
}
