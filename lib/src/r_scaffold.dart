// ignore_for_file: always_use_package_imports

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:playground/src/extensions.dart';

import 'entities/entities.dart';
import 'widgets/widgets.dart';

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
}

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
class _ResponsiveScaffoldState extends State<ResponsiveScaffold> {
  final _key = GlobalKey<ScaffoldState>();
  late final RMenuController _menuController;

  @override
  void initState() {
    super.initState();
    _menuController = RMenuController()..addListener(_menuListener);
  }

  void _menuListener() {
    if (!_menuController.currentState.isClosed &&
        _key.currentState!.isDrawerOpen) {
      // _key.currentState!.closeDrawer();
    }
  }

  AppBar _appBar() => (widget.appBar ?? AppBar()).copyWith(
        leading: IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.menu),
          onPressed: () {
            if (_menuController.currentState is ClosedState) {
              _key.currentState?.openDrawer();
            } else {
              _menuController.toggle();
            }
          },
        ),
      );

  @override
  void dispose() {
    _menuController
      ..removeListener(_menuListener)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsiveMenu = ResponsiveMenu(
      items: widget.menu.items,
      header: widget.menu.header,
      leading: widget.menu.leading,
      trailing: widget.menu.trailing,
      theme: widget.menu.theme,
      // type: widget.menu.type,
      // onTap: _menuController.currentState.isClosed
      //     ? Navigator.of(context).pop
      //     : null,
      controller: _menuController,
    );

    return Scaffold(
      key: _key,
      appBar: _appBar(),
      drawer: ConstrainedBox(
        constraints: BoxConstraints.expand(
          width: widget.menu.theme.maxSize.width,
        ),
        child: Drawer(
          child: responsiveMenu,
          // child: ResponsiveMenu(
          //   items: widget.menu.items,
          //   header: widget.menu.header,
          //   leading: widget.menu.leading,
          //   trailing: widget.menu.trailing,
          //   theme: widget.menu.theme,
          //   // .copyWith(
          //   //   responsive: false,
          //   // ),
          //   onTap: Navigator.of(context).pop,
          // ),
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
        delegate: _BodyLayout(),
        children: [
          LayoutId(
            id: 'body',
            child: widget.body,
          ),
          LayoutId(
            id: 'menu',
            child: responsiveMenu,
            // child: ResponsiveMenu(
            //   items: widget.menu.items,
            //   header: widget.menu.header,
            //   leading: widget.menu.leading,
            //   trailing: widget.menu.trailing,
            //   theme: widget.menu.theme,
            //   // type: widget.menu.type,
            //   controller: _menuController,
            // ),
          ),
        ],
      ),
    );
  }
}

///
class _BodyLayout extends MultiChildLayoutDelegate {
  @override
  void performLayout(Size size) {
    final looseConstraints = BoxConstraints.loose(size);

    late Size menuSize;
    // Menu
    if (hasChild('menu')) {
      menuSize = layoutChild('menu', BoxConstraints.loose(size));
      positionChild('menu', Offset.zero);
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
      positionChild(
        'body',
        Offset(menuSize.width, 0),
      );
    }
  }

  @override
  bool shouldRelayout(_BodyLayout oldDelegate) => false;
}
