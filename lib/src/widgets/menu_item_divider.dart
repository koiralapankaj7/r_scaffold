// ignore_for_file: always_use_package_imports

import 'package:flutter/material.dart';

import '../entities/entities.dart';

///
class MenuItemDivider extends StatelessWidget {
  ///
  const MenuItemDivider({
    required this.item,
    required this.child,
    super.key,
  });

  ///
  final RMenuItem item;

  ///
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (item.dividerAbove || item.dividerBelow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.dividerAbove) const Divider(thickness: 1, height: 1),
          child,
          if (item.dividerBelow) const Divider(thickness: 1, height: 1),
        ],
      );
    }
    return child;
  }
}
