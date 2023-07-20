// ignore_for_file: always_use_package_imports

import 'package:flutter/material.dart';

import 'widgets.dart';

/// Example of a leading item for the entire menu.
class ResponsiveMenuHeader extends StatelessWidget {
  ///
  const ResponsiveMenuHeader({
    this.avatar,
    this.title,
    this.subtitle,
    this.avatarLabel,
    this.trailing,
    this.padding,
    this.titleSpacing,
    this.onPressed,
    super.key,
  });

  ///
  final Widget? avatar;

  /// A label for the avatar for the leading menu item.
  final String? avatarLabel;

  ///
  final Widget? title;

  /// A subtitle for leading menu item.
  final Widget? subtitle;

  ///
  final Widget? trailing;

  ///
  final EdgeInsetsGeometry? padding;

  ///
  final double? titleSpacing;

  ///
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryTextTheme = theme.primaryTextTheme;
    // final menuTheme = RMenuQuery.themeOf(context);
    // final labelFadeAnimation = RMenuQuery.sizeAnimationOf(context).drive(
    //   CurveTween(curve: const Interval(0.20, 1)),
    // );

    final pad = padding ??
        const EdgeInsets.symmetric(
          // horizontal: menuTheme.itemMargin.horizontal * 0.5,
          vertical: 16,
        );

    final child = Padding(
      padding: pad,
      child: IntrinsicHeight(
        child: ClipRRect(
          child: OverflowBox(
            alignment: Alignment.centerLeft,
            // maxWidth: menuTheme.maxSize.width - pad.horizontal,
            maxWidth: 380 - pad.horizontal,
            child: Row(
              children: [
                // Avatar
                SizedBox(
                  // width: menuTheme.minSize.width,
                  width: 52,
                  child: avatar ??
                      CircleAvatar(
                        backgroundColor: theme.colorScheme.primary,
                        child: Text(
                          avatarLabel ?? '',
                          style: primaryTextTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                ),

                // Body
                Expanded(
                  child: FadeTransition(
                    opacity: RMenuQuery.fadeAnimationOf(context),
                    child: Row(
                      children: [
                        // Title spacing
                        if (titleSpacing != null) SizedBox(width: titleSpacing),

                        // Body
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              if (title != null)
                                DefaultTextStyle(
                                  style: theme.textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  child: title!,
                                ),

                              // Subtitle
                              if (subtitle != null) ...[
                                const SizedBox(height: 2),
                                DefaultTextStyle(
                                  style: theme.textTheme.bodyMedium!.copyWith(
                                    color: theme.hintColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  child: subtitle!,
                                ),
                              ],
                            ],
                          ),
                        ),

                        // Trailing
                        if (trailing != null) trailing!,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (onPressed != null) {
      return InkWell(onTap: onPressed, child: child);
    }

    return child;
  }
}
