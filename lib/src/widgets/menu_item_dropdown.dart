// ignore_for_file: always_use_package_imports

import 'package:flutter/material.dart';

import '../entities/entities.dart';

///
class MenuItemDropdown extends StatefulWidget {
  ///
  const MenuItemDropdown({
    required this.item,
    required this.header,
    required this.children,
    super.key,
  });

  ///
  final DropdownMItem item;

  ///
  final Widget header;

  ///
  final Iterable<Widget> children;

  @override
  State<MenuItemDropdown> createState() => _MenuItemDropdownState();
}

class _MenuItemDropdownState extends State<MenuItemDropdown> {
  bool _collapsed = true;

  @override
  Widget build(BuildContext context) {
    // final animation = RScaffold.sizeAnimation(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.item.dividerAbove) const Divider(thickness: 1, height: 1),
        // Header
        InkWell(
          onTap: () {
            setState(() {
              _collapsed = !_collapsed;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Expanded(
                  child: DefaultTextStyle(
                    style: Theme.of(context).textTheme.titleMedium!,
                    child: widget.header,
                  ),
                ),

                //
                ExpandIcon(
                  isExpanded: !_collapsed,
                  padding: EdgeInsets.zero,
                  onPressed: (_) {
                    setState(() {
                      _collapsed = !_collapsed;
                    });
                  },
                ),
              ],
            ),
          ),
        ),

        if (widget.item.dividerBelow) const Divider(thickness: 1, height: 1),
        // Items
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return SizeTransition(
              sizeFactor: animation,
              child: child,
            );
          },
          child: _collapsed
              ? const SizedBox.shrink()
              : Column(children: widget.children.toList()),
        ),
      ],
    );
  }
}
