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
  RMenu({
    required this.items,
    this.header,
    this.leading,
    this.trailing,
    RMenuTheme? theme,
  }) : theme = theme ?? RMenuTheme();

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

  @override
  State<RScaffold> createState() => _RScaffoldState();
}

///
class _RScaffoldState extends State<RScaffold> {
  final _key = GlobalKey<ScaffoldState>();
  late final RMenuController _menuController;

  @override
  void initState() {
    super.initState();
    _menuController = RMenuController();
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
            // _menuController.toggle();
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
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: _appBar(),
      // The menu content when used in the Drawer.
      // drawer: ConstrainedBox(
      //   constraints: BoxConstraints.expand(
      //     width: menuTheme.railMaxWidth,
      //   ),
      //   child: Drawer(
      //     child: ResponsiveMenu(
      //       menu: widget.menu,
      //       extendedAnimation: Tween<double>(begin: 1, end: 1)
      //           .animate(_menuController.sizeAnimation),
      //       onTap: (item) {
      //         item.onPressed?.call();
      //         Navigator.of(context).pop();
      //       },
      //     ),
      //   ),
      // ),
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
            child: ResponsiveMenu(
              items: widget.menu.items,
              header: widget.menu.header,
              leading: widget.menu.leading,
              trailing: widget.menu.trailing,
              theme: widget.menu.theme,
              // type: widget.menu.type,
              onTap: (item) {
                item.onPressed?.call();
              },
              controller: _menuController,
            ),
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
