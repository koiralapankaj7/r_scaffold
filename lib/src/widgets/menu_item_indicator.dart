// ignore_for_file: always_use_package_imports

import 'package:flutter/material.dart';

import 'widgets.dart';

///
class MenuItemIndicator extends StatelessWidget {
  ///
  const MenuItemIndicator({
    required this.indicatorAnimation,
    required this.child,
    super.key,
  });

  ///
  final Animation<double> indicatorAnimation;

  ///
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final menuTheme = RMenuQuery.themeOf(context);

    if (!menuTheme.useIndicator) {
      return child;
    }

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Positioned.fill(
          child: NavigationIndicator(
            animation: indicatorAnimation,
            borderRadius: RMenuQuery.borderRadiusOf(
              context,
              direction: Directionality.of(context),
            ),
            shape: menuTheme.indicatorShape,
            color: menuTheme.indicatorColor ??
                Theme.of(context).primaryColor.withOpacity(0.2),
          ),
        ),
        child,
      ],
    );
  }
}
