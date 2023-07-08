// ignore_for_file: always_use_package_imports

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:playground/src/extensions.dart';

import 'entities/entities.dart';
import 'widgets/widgets.dart';

/// Responsive Scaffold
class RScaffold extends StatefulWidget {
  ///
  const RScaffold({
    required this.menu,
    required this.body,
    super.key,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.onDrawerChanged,
    this.endDrawer,
    this.onEndDrawerChanged,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.primary = true,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
    this.restorationId,
  });

  ///
  final RMenu menu;

  //=============================
  ///
  final Widget body;

  ///
  final AppBar? appBar;

  ///
  final bool extendBodyBehindAppBar;

  ///
  final Widget? floatingActionButton;

  ///
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  ///
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;

  ///
  final List<Widget>? persistentFooterButtons;

  ///
  final DrawerCallback? onDrawerChanged;

  ///
  final Widget? endDrawer;

  ///
  final DrawerCallback? onEndDrawerChanged;

  ///
  final Color? drawerScrimColor;

  ///
  final Color? backgroundColor;

  ///
  final Widget? bottomNavigationBar;

  ///
  final Widget? bottomSheet;

  ///
  final bool? resizeToAvoidBottomInset;

  ///
  final DragStartBehavior drawerDragStartBehavior;

  ///
  final double? drawerEdgeDragWidth;

  ///
  final bool drawerEnableOpenDragGesture;

  ///
  final bool endDrawerEnableOpenDragGesture;

  ///
  final String? restorationId;

  ///
  final bool primary;

  ///
  final bool extendBody;

  ///
  static Animation<double> sizeAnimation(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_ExtendedNavigationRailAnimation>()!
        .sizeAnimation;
  }

  @override
  State<RScaffold> createState() => _RScaffoldState();
}

///
class _RScaffoldState extends State<RScaffold>
    with SingleTickerProviderStateMixin, BreakpointAware {
  final _key = GlobalKey<ScaffoldState>();
  late final RMenuController _menuController;

  RMenuTheme get menuTheme => widget.menu.theme;

  @override
  void initState() {
    super.initState();
    _menuController = RMenuController()
      .._init(
        vsync: this,
        menu: widget.menu,
      )
      ..addListener(_rebuild);
  }

  void _rebuild() {
    setState(() {
      // Rebuilding when any of the controllers tick, i.e. when the items are
      // animating.
    });
  }

  @override
  void didUpdateWidget(RScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.menu.theme.railMaxWidth != oldWidget.menu.theme.railMaxWidth) {
      _didMaxWidthChange(oldWidget.menu.theme.railMaxWidth);
    }
    if (widget.menu.theme.minWidth != oldWidget.menu.theme.minWidth) {
      _didMinWidthChange(oldWidget.menu.theme.minWidth);
    }
    if (widget.menu.type != oldWidget.menu.type) {
      // _moveTo(_valueFor(widget.menu.type));
      // _menuController.switchType(widget.menu.type);
    }
  }

  void _didMaxWidthChange(double old) {
    // // If not in extended mode dont do anything
    // if (_controller.value != 1.0) return;
    // if (widget.menu.theme.maxWidth > old) {
    //   // increased
    //   final oldValue =
    //       (widget.menu.theme.maxWidth - old) / widget.menu.theme.maxWidth;
    //   _controller
    //     ..value = oldValue
    //     ..animateTo(
    //       1,
    //       duration: kThemeAnimationDuration,
    //       curve: Curves.easeIn,
    //     );
    // } else {
    //   // decreased
    // }
  }

  void _didMinWidthChange(double old) {
    if (widget.menu.theme.minWidth > old) {
      // increased
    } else {
      // decreased
    }
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   _shortcutsEntry?.dispose();
  //   // Collect the shortcuts from the different menu selections so that they can
  //   // be registered to apply to the entire app. Menus don't register their
  //   // shortcuts, they only display the shortcut hint text.
  //   final shortcuts = <ShortcutActivator, Intent>{
  //     for (final item in widget.menu.header!.dropdownItems)
  //       if (item.shortcut != null)
  //         item.shortcut!: VoidCallbackIntent(() => item.onPressed?.call()),
  //   };
  //   // Register the shortcuts with the ShortcutRegistry so that they are
  //   // available to the entire application.
  //   _shortcutsEntry = ShortcutRegistry.of(context).addAll(shortcuts);
  // }

  AppBar _appBar() => (widget.appBar ?? AppBar()).copyWith(
        // Some logic to show the implicit menu button on AppBar when
        // there is no rail or menu.
        // automaticallyImplyLeading:
        //     _current.isDrawer && !_extendedController.isAnimating,
        leading: IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.menu),
          onPressed: () {
            // if (_menuController.type.isDrawer) {
            //   _key.currentState?.openDrawer();
            // } else {
            //   _menuController.toggle();
            // }
            _menuController.toggle();
          },
        ),
      );

  @override
  void dispose() {
    _menuController.dispose();
    super.dispose();
  }

  @override
  Iterable<MapEntry<String, double>> get breakpoints => [
        MapEntry('S', menuTheme.breakPoint.drawer),
        MapEntry('M', menuTheme.breakPoint.rail),
      ];

  @override
  void onBreakpointInit(MapEntry<String, double> breakpoint) =>
      _menuController._onBreakpointInit(breakpoint);

  @override
  void onBreakpointChange(MapEntry<String, double> breakpoint, bool forward) =>
      _menuController._onBreakpointChange(breakpoint, forward);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _ExtendedNavigationRailAnimation(
      sizeAnimation: _menuController.sizeAnimation,
      child: Scaffold(
        key: _key,
        appBar: _appBar(),
        // The menu content when used in the Drawer.
        drawer: ConstrainedBox(
          constraints: BoxConstraints.expand(
            width: menuTheme.railMaxWidth,
          ),
          child: Drawer(
            child: ResponsiveMenu(
              menu: widget.menu,
              extendedAnimation: Tween<double>(begin: 1, end: 1)
                  .animate(_menuController.sizeAnimation),
              onTap: (item) {
                item.onPressed?.call();
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
        floatingActionButton: widget.floatingActionButton,
        floatingActionButtonLocation: widget.floatingActionButtonLocation,
        floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
        persistentFooterButtons: widget.persistentFooterButtons,
        onDrawerChanged: widget.onDrawerChanged,
        endDrawer: widget.endDrawer,
        onEndDrawerChanged: widget.onEndDrawerChanged,
        bottomNavigationBar: widget.bottomNavigationBar,
        bottomSheet: widget.bottomSheet,
        backgroundColor: widget.backgroundColor,
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        primary: widget.primary,
        drawerDragStartBehavior: widget.drawerDragStartBehavior,
        extendBody: widget.extendBody,
        extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
        drawerScrimColor: widget.drawerScrimColor,
        drawerEdgeDragWidth: widget.drawerEdgeDragWidth,
        // drawerEnableOpenDragGesture: !isDesktop && state == RailState.close,
        endDrawerEnableOpenDragGesture: widget.endDrawerEnableOpenDragGesture,
        restorationId: widget.restorationId,
        body: CustomMultiChildLayout(
          delegate: _ResponsiveBodyLayout(
            minWidth: menuTheme.minWidth,
            maxWidth: menuTheme.railMaxWidth,
            sizeFactor: _menuController.sizeAnimation.value,
            positionFactor: _menuController.positionAnimation.value,
          ),
          children: [
            LayoutId(
              id: 'body',
              child: widget.body,
            ),
            LayoutId(
              id: 'menu',
              child: ResponsiveMenu(
                menu: widget.menu,
                extendedAnimation: _menuController.sizeAnimation,
                onTap: (item) {
                  item.onPressed?.call();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///
class RMenuController extends Listenable with ChangeNotifier {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  late Animation<double> _positionAnimation;
  late RMenu _menu;
  late RMenuType _prevType;
  late RMenuType _currentType;
  // RMenuType? _usePreference;

  void _init({
    required TickerProvider vsync,
    required RMenu menu,
  }) {
    _menu = menu;
    _controller = AnimationController(
      duration: kThemeAnimationDuration,
      vsync: vsync,
    );
    _positionAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0,
          menu.theme.railPercent,
          curve: Curves.easeIn,
        ),
      ),
    );
    _sizeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          menu.theme.railPercent,
          1,
          curve: Curves.easeIn,
        ),
      ),
    );
  }

  ///
  double _valueFor(RMenuType type) => switch (type) {
        RMenuType.drawer => 0,
        RMenuType.rail => _menu.theme.railPercent,
        RMenuType.extended => 1,
      };

  RMenuType _typeFromString(String type) {
    return switch (type) {
      'S' => RMenuType.drawer,
      'M' => RMenuType.rail,
      'unknown' => RMenuType.extended,
      _ => throw UnsupportedError('Screen type not found!'),
    };
  }

  void _onBreakpointInit(MapEntry<String, double> breakpoint) {
    _currentType = _prevType = _menu.type ?? _typeFromString(breakpoint.key);
    _controller.value = _valueFor(_currentType);
  }

  void _onBreakpointChange(MapEntry<String, double> breakpoint, bool forward) {
    _move(_typeFromString(breakpoint.key), forward: forward);
  }

  void _move(RMenuType type, {bool? forward}) {
    if (_currentType == type) return;
    _moveTo(_valueFor(type), forward ?? type > _currentType);
  }

  void _moveTo(double target, bool forward) {
    if (_controller.isAnimating) return;
    (forward
            ? _controller.animateTo(target, duration: kThemeAnimationDuration)
            : _controller.animateBack(
                target,
                duration: kThemeAnimationDuration,
              ))
        .then((_) {
      _prevType = _currentType;
      _currentType = switch (target) {
        0.0 => RMenuType.drawer,
        1.0 => RMenuType.extended,
        _ => RMenuType.rail,
      };
      notifyListeners();
    });
  }

  ///
  Animation<double> get sizeAnimation => _sizeAnimation;

  ///
  Animation<double> get positionAnimation => _positionAnimation;

  ///
  RMenuType get type => _currentType;

  ///
  @override
  void addListener(VoidCallback listener) {
    _controller.addListener(listener);
  }

  /// Toggle between Extended and Rail
  /// Nothing happens in drawer mode
  void toggle() {
    if (_currentType.isDrawer) return;
    // _usePreference = true;
    if (_currentType.isExtended) {
      _moveTo(_menu.theme.railPercent, false);
      // _usePreference = RMenuType.rail;
    } else if (_currentType.isRail) {
      _moveTo(1, true);
      // _usePreference = RMenuType.extended;
    }
  }

  /// Keep toogle between state.
  /// Nothing happens in drawer mode
  void next() {
    // if (_currentType.isDrawer) return;
    final next = _currentType.isDrawer || _currentType.isExtended
        ? RMenuType.rail
        : _currentType > _prevType
            ? RMenuType.extended
            : RMenuType.drawer;
    // _usePreference = true;
    _move(next);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

///
class _ResponsiveBodyLayout extends MultiChildLayoutDelegate {
  _ResponsiveBodyLayout({
    required this.minWidth,
    required this.maxWidth,
    required this.positionFactor,
    required this.sizeFactor,
  });

  final double minWidth;
  final double maxWidth;
  final double sizeFactor;
  final double positionFactor;

  @override
  void performLayout(Size size) {
    final looseConstraints = BoxConstraints.loose(size);

    late Size menuSize;
    // Menu
    if (hasChild('menu')) {
      menuSize = layoutChild(
        'menu',
        BoxConstraints.tight(size).enforce(
          BoxConstraints(
            maxWidth: minWidth + (maxWidth - minWidth) * sizeFactor,
          ),
        ),
      );
      positionChild(
        'menu',
        Offset(-minWidth * (1 - positionFactor), 0),
      );
    }

    // Body
    if (hasChild('body')) {
      layoutChild(
        'body',
        looseConstraints.tighten(
          width: size.width - menuSize.width,
          height: size.height,
        ),
      );
      positionChild('body', Offset(menuSize.width * positionFactor, 0));
    }
  }

  @override
  bool shouldRelayout(_ResponsiveBodyLayout oldDelegate) =>
      oldDelegate.maxWidth != maxWidth ||
      oldDelegate.minWidth != minWidth ||
      oldDelegate.sizeFactor != sizeFactor ||
      oldDelegate.positionFactor != positionFactor;
}

// ==============================================================

class _ExtendedNavigationRailAnimation extends InheritedWidget {
  const _ExtendedNavigationRailAnimation({
    required this.sizeAnimation,
    required super.child,
  });

  final Animation<double> sizeAnimation;

  @override
  bool updateShouldNotify(_ExtendedNavigationRailAnimation old) =>
      sizeAnimation != old.sizeAnimation;
}

// class _ItemSelectNotification extends Notification {
//   _ItemSelectNotification(this.item);
//   final _ResponsiveMenuItem item;
// }
