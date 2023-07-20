// ignore_for_file: always_use_package_imports

import 'package:equatable/equatable.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'widgets/widgets.dart';

// The default width of the side menu when expanded to full menu.
const double _kMenuWidth = 296;

// The default width of the side menu when collapsed to a rail.
const double _kRailWidth = 68;

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

///
enum MenuState {
  ///
  closed,

  ///
  min,

  ///
  max
}

///
@immutable
class RMenu {
  ///
  const RMenu({
    required this.items,
    this.header,
    this.leading,
    this.trailing,
    RMenuTheme? theme,
    this.responsive = true,
    this.state,
    RSize? minSize,
    RSize? maxSize,
  })  : theme = theme ?? const RMenuTheme(),
        minSize = minSize ?? RSize.min,
        maxSize = maxSize ?? RSize.max;

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
  final RSize minSize;

  ///
  final RSize maxSize;

  ///
  final bool responsive;

  ///
  final MenuState? state;
}

//
// =============================ResponsiveScaffold==============================
//

/// Responsive Scaffold
class ResponsiveScaffold extends StatefulWidget {
  ///
  const ResponsiveScaffold({
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

  @override
  State<ResponsiveScaffold> createState() => _ResponsiveScaffoldState();
}

///
class _ResponsiveScaffoldState extends State<ResponsiveScaffold>
    with
        TickerProviderStateMixin,
        BreakpointAware<ResponsiveScaffold, MenuState> {
  late final AnimationController _sizeController;
  late final AnimationController _posController;

  final _key = GlobalKey<ScaffoldState>();
  int _direction = -1;
  late MenuState _currentState;
  MenuState? _breakpointState;

  @override
  void initState() {
    super.initState();
    _currentState = widget.menu.state ?? MenuState.closed;
    _sizeController = AnimationController(
      vsync: this,
      value: _currentState == MenuState.max ? 1 : 0,
      duration: kThemeAnimationDuration,
    );
    _posController = AnimationController(
      vsync: this,
      value: _currentState == MenuState.closed ? 0 : 1,
      duration: kThemeAnimationDuration,
    );
  }

  @override
  void didUpdateWidget(covariant ResponsiveScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.menu.state != widget.menu.state) {
      _updateState(
        oldWidget.menu.state ?? MenuState.closed,
        widget.menu.state ?? MenuState.closed,
      );
    }
  }

  @override
  void onBreakpointInit(MapEntry<MenuState, double>? breakpoint) {
    final next = breakpoint?.key ?? MenuState.max;
    _breakpointState = next;
    if (_currentState == next) return;
    _sizeController.value = next == MenuState.max ? 1 : 0;
    _posController.value = next == MenuState.closed ? 0 : 1;
    _currentState = next;
  }

  @override
  Iterable<MapEntry<MenuState, double>> get breakpoints =>
      widget.menu.breakpoints;

  @override
  Future<void> onBreakpointChange(
    MapEntry<MenuState, double>? breakpoint,
    int direction,
  ) async {
    _direction = direction;
    _breakpointState = breakpoint?.key;
    if (_key.currentState?.isDrawerOpen ?? false) {
      _key.currentState?.closeDrawer();
    }
    await null;
    _toggle();
  }

  ///
  void _toggle({List<MenuState>? states}) {
    final defaultStates = states ??
        [
          MenuState.closed,
          MenuState.min,
          MenuState.max,
        ];
    final cuttentIndex = defaultStates.indexOf(_currentState);
    if (cuttentIndex == 0 && _direction == -1) {
      _direction = 1;
    } else if (cuttentIndex == defaultStates.length - 1 && _direction == 1) {
      _direction = -1;
    }
    final next = defaultStates[cuttentIndex + _direction];
    _updateState(_currentState, next);
  }

  ///
  Future<void> _updateState(MenuState prev, MenuState next) async {
    if (prev == next) return;
    TickerFuture ticker;
    switch (next) {
      case MenuState.closed:
        if (prev == MenuState.min) {
          ticker = _posController.reverse();
        } else {
          ticker = await _sizeController
              .reverse()
              .then((value) => _posController.reverse());
        }
      case MenuState.min:
        if (prev == MenuState.closed) {
          ticker = _posController.forward();
        } else {
          ticker = _sizeController.reverse();
        }
      case MenuState.max:
        if (prev == MenuState.closed) {
          ticker = await _posController
              .forward()
              .then((value) => _sizeController.forward());
        } else {
          ticker = _sizeController.forward();
        }
    }

    await ticker.then((value) {
      setState(() {
        _currentState = next;
      });
    });
  }

  @override
  void dispose() {
    _sizeController.dispose();
    _posController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final menuData = RMenuData(
      minWidth:
          widget.menu.minSize.width, // + widget.menu.itemMargin.horizontal,
      maxWidth: widget.menu.maxSize.width,
      theme: widget.menu.theme,
      state: _currentState,
      sizeAnimation: _sizeController.view,
      positionAnimation: _posController.view,
    );

    final responsiveMenu = ResponsiveMenu(
      items: widget.menu.items,
      header: widget.menu.header,
      leading: widget.menu.leading,
      trailing: widget.menu.trailing,
      theme: widget.menu.theme,
      onTap:
          _currentState == MenuState.closed ? Navigator.of(context).pop : null,
    );

    return RMenuQuery(
      data: menuData,
      child: Scaffold(
        key: _key,
        appBar: (widget.appBar ?? AppBar()).copyWith(
          leading: IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.menu),
            onPressed: () {
              if (_currentState == MenuState.closed &&
                  _breakpointState == MenuState.closed) {
                _key.currentState?.openDrawer();
                return;
              }
              _toggle(
                states: [MenuState.min, MenuState.max],
              );
            },
          ),
        ),
        drawer: ConstrainedBox(
          constraints: BoxConstraints.expand(width: menuData.maxWidth),
          child: Drawer(child: responsiveMenu),
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
        body: MultiListenableBuilder(
          listenables: [
            _sizeController,
            _posController,
          ],
          builder: (context, child) {
            return CustomMultiChildLayout(
              delegate: _BodyLayout(
                position: _posController.value,
                sizeFactor: _sizeController.value,
                maxWidth: menuData.maxWidth,
                minWidth: menuData.minWidth,
              ),
              children: [
                LayoutId(
                  id: _ScaffoldItem.body,
                  child: widget.body,
                ),
                LayoutId(
                  id: _ScaffoldItem.menu,
                  child: responsiveMenu,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

//
// ==============================_BodyLayout=================================
//

///
enum _ScaffoldItem { menu, body }

///
class _BodyLayout extends MultiChildLayoutDelegate {
  _BodyLayout({
    required this.position,
    required this.sizeFactor,
    required this.maxWidth,
    required this.minWidth,
  });

  final double position;
  final double sizeFactor;
  final double maxWidth;
  final double minWidth;

  @override
  void performLayout(Size size) {
    final looseConstraints = BoxConstraints.loose(size);

    late Size menuSize;
    // Menu
    if (hasChild(_ScaffoldItem.menu)) {
      menuSize = layoutChild(
        _ScaffoldItem.menu,
        looseConstraints.tighten(
          width: minWidth + (maxWidth - minWidth) * sizeFactor,
        ),
      );
      positionChild(_ScaffoldItem.menu, Offset(minWidth * (position - 1), 0));
    }

    // Body
    if (hasChild(_ScaffoldItem.body)) {
      layoutChild(
        _ScaffoldItem.body,
        looseConstraints.tighten(
          width: size.width - menuSize.width * position,
          height: size.height,
        ),
      );
      positionChild(
        _ScaffoldItem.body,
        Offset(menuSize.width * position, 0),
      );
    }
  }

  @override
  bool shouldRelayout(_BodyLayout oldDelegate) =>
      oldDelegate.position != position || oldDelegate.sizeFactor != sizeFactor;
}

//
// ==============================Extensions=================================
//

extension on RMenu {
  Iterable<MapEntry<MenuState, double>> get breakpoints {
    return [
      MapEntry(MenuState.closed, minSize.breakpoint),
      MapEntry(MenuState.min, maxSize.breakpoint),
    ];
  }
}

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
