// ignore_for_file: always_use_package_imports

import 'package:flutter/material.dart';
import 'package:playground/src/widgets/widgets.dart';

import '../entities/entities.dart';

///
class MenuItemDropdown extends StatefulWidget {
  ///
  const MenuItemDropdown({
    required this.item,
    required this.children,
    super.key,
  });

  ///
  final DropdownMItem item;

  ///
  final Iterable<Widget> children;

  @override
  State<MenuItemDropdown> createState() => _MenuItemDropdownState();
}

class _MenuItemDropdownState extends State<MenuItemDropdown> {
  bool _collapsed = true;

  void _toogle() {
    setState(() {
      _collapsed = !_collapsed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final menuTheme = RMenuTheme.of(context);

    final header = widget.item.builder?.call(context, _toogle) ??
        Row(
          children: [
            // Leading
            if (widget.item.leading != null)
              SizedBox(
                width: menuTheme.minSize.width,
                child: widget.item.leading,
              ),

            // const SizedBox(width: 16),
            if (widget.item.title != null)
              Expanded(
                child: Row(
                  children: [
                    // Title
                    Expanded(
                      child: FadeTransition(
                        alwaysIncludeSemantics: true,
                        opacity: RMenuController.of(context).fadeAnimation,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: DefaultTextStyle(
                            style: Theme.of(context).textTheme.titleMedium!,
                            maxLines: 1,
                            child: widget.item.title!,
                          ),
                        ),
                      ),
                    ),

                    // Expanded icon
                    ExpandIcon(
                      isExpanded: !_collapsed,
                      padding: EdgeInsets.zero,
                      onPressed: (_) => _toogle(),
                    ),
                  ],
                ),
              ),
          ],
        );

    final pad = menuTheme.itemMargin;
    return Column(
      children: [
        // Header
        MenuItemDivider(
          item: widget.item,
          child: InkWell(
            onTap: () {
              setState(() {
                _collapsed = !_collapsed;
              });
            },
            child: SizedBox(
              height: widget.item.height,
              child: Padding(
                padding: pad,
                child: ClipRect(
                  child: OverflowBox(
                    alignment: Alignment.centerLeft,
                    maxWidth: menuTheme.maxSize.width - pad.horizontal,
                    child: header,
                  ),
                ),
              ),
            ),
          ),
        ),

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
