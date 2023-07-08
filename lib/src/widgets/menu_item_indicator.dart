// ignore_for_file: always_use_package_imports

import 'package:flutter/material.dart';

import '../entities/entities.dart';

///
class MenuItemIndicator extends StatelessWidget {
  ///
  const MenuItemIndicator({
    required this.addIndicator,
    required this.menuTheme,
    required this.indicatorAnimation,
    required this.child,
    super.key,
  });

  ///
  final RMenuTheme menuTheme;

  ///
  final bool addIndicator;

  ///
  final Animation<double> indicatorAnimation;

  ///
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!addIndicator) {
      return child;
    }

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Positioned.fill(
          child: NavigationIndicator(
            animation: indicatorAnimation,
            borderRadius: menuTheme.resolveRadius(Directionality.of(context)),
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
