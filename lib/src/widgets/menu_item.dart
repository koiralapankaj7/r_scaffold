// ignore_for_file: always_use_package_imports

import 'package:flutter/material.dart';

import '../entities/entities.dart';
import 'widgets.dart';

///
class MenuItem extends StatefulWidget {
  ///
  const MenuItem({
    required this.id,
    required this.item,
    required this.destinationAnimation,
    required this.selected,
    required this.onTap,
    required this.indexLabel,
    super.key,
  });

  ///
  final String id;

  ///
  final DefaultMItem item;

  ///
  final Animation<double> destinationAnimation;

  ///
  final bool selected;

  ///
  final VoidCallback onTap;

  ///
  final String indexLabel;

  @override
  State<MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  @override
  void didUpdateWidget(covariant MenuItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.item.selected != oldWidget.item.selected) {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    final menuTheme = RMenuQuery.themeOf(context);
    // final maxSize = RMenuQuery.maxWidthOf(context);
    // final minSize = RMenuQuery.minWidthOf(context);

    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final iconColor = isLight
        ? Color.alphaBlend(
            theme.colorScheme.primary.withAlpha(0x99),
            theme.colorScheme.onSurface,
          )
        : Color.alphaBlend(
            theme.colorScheme.primary.withAlpha(0x7F),
            theme.colorScheme.onSurface,
          );

    final colors = Theme.of(context).colorScheme;

    final unselectedLabelTextStyle = menuTheme.unselectedLabelTextStyle ??
        theme.textTheme.bodyLarge!.copyWith(color: theme.hintColor);

    final selectedLabelTextStyle = menuTheme.selectedLabelTextStyle ??
        theme.textTheme.bodyLarge!.copyWith(
          color: theme.colorScheme.onSurface.withAlpha(0xCC),
        );

    final disabledLabelTextStyle = menuTheme.disabledLabelTextStyle ??
        theme.textTheme.bodyLarge!.copyWith(color: theme.disabledColor);

    final unselectedIconTheme = menuTheme.unselectedIconTheme ??
        theme.iconTheme.copyWith(color: theme.hintColor);

    final disabledIconTheme = menuTheme.disabledIconTheme ??
        theme.iconTheme.copyWith(
          color: theme.disabledColor,
        );

    final selectedIconTheme = menuTheme.selectedIconTheme ??
        theme.iconTheme.copyWith(color: iconColor);

    final borderRadius = menuTheme.resolveRadius(Directionality.of(context));

    final child = SizedBox(
      height: widget.item.height,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Semantics(
          container: true,
          selected: widget.selected,
          child: Stack(
            children: <Widget>[
              MenuItemIndicator(
                addIndicator: menuTheme.useIndicator,
                menuTheme: menuTheme,
                indicatorAnimation: widget.destinationAnimation,
                child: OverflowBox(
                  alignment: Alignment.centerLeft,
                  maxWidth: RMenuQuery.maxWidthOf(context),
                  child: Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      onTap: widget.item.enabled ? () => widget.onTap() : null,
                      borderRadius: borderRadius,
                      customBorder: menuTheme.indicatorShape,
                      splashColor: colors.primary.withOpacity(0.12),
                      hoverColor: colors.primary.withOpacity(0.06),
                      child: Padding(
                        padding: widget.item.padding ?? EdgeInsets.zero,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: RMenuQuery.minWidthOf(context),
                                child: IconTheme(
                                  data: !widget.item.enabled
                                      ? disabledIconTheme
                                      : widget.selected
                                          ? selectedIconTheme
                                          : unselectedIconTheme,
                                  child: widget.selected
                                      ? widget.item.selectedIcon
                                      : widget.item.icon,
                                ),
                              ),
                              Expanded(
                                child: FadeTransition(
                                  alwaysIncludeSemantics: true,
                                  opacity: RMenuQuery.fadeAnimationOf(context),
                                  child: DefaultTextStyle(
                                    style: !widget.item.enabled
                                        ? disabledLabelTextStyle
                                        : widget.selected
                                            ? selectedLabelTextStyle
                                            : unselectedLabelTextStyle,
                                    maxLines: 1,
                                    child: widget.item.label,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Semantics(label: widget.indexLabel),
            ],
          ),
        ),
      ),
    );

    if (widget.item.dividerAbove || widget.item.dividerBelow) {
      return MenuItemDivider(item: widget.item, child: child);
    }

    return child;
  }
}
