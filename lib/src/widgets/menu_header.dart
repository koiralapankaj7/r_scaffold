// ignore_for_file: always_use_package_imports

import 'package:flutter/material.dart';
import 'package:playground/src/extensions.dart';

import '../entities/entities.dart';

/// Example of a leading item for the entire menu.
class MenuHeader extends StatefulWidget {
  ///
  const MenuHeader({
    required this.menu,
    required this.extendedAnimation,
    super.key,
  });

  ///
  final RMenu menu;

  ///
  final Animation<double> extendedAnimation;

  @override
  State<MenuHeader> createState() => _MenuHeaderState();
}

class _MenuHeaderState extends State<MenuHeader> {
  // final bool _collapsed = true;
  late final FocusNode _focusNode = FocusNode();
  late final FocusNode _buttonFocusNode =
      FocusNode(debugLabel: 'Header Menu Button');

  @override
  void dispose() {
    _focusNode.dispose();
    _buttonFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labelFadeAnimation = widget.extendedAnimation.drive(
      CurveTween(curve: const Interval(0.20, 1)),
    );

    final theme = Theme.of(context);
    final primaryTextTheme = theme.primaryTextTheme;
    final header = widget.menu.header!;

    final Widget child = InkWell(
      onTap: header.onPressed,
      // onTap: () {
      //   // _focusNode.requestFocus();
      //   if (header.popupDropdown) {
      //     //
      //   } else {
      //     setState(() {
      //       _collapsed = !_collapsed;
      //     });
      //   }
      // },
      child: Row(
        children: [
          // Avatar
          SizedBox.fromSize(
            size: Size.square(widget.menu.theme.minWidth),
            child: Padding(
              padding:
                  EdgeInsets.all(widget.menu.theme.itemMargin.horizontal * 0.5),
              child: CircleAvatar(
                backgroundColor: theme.colorScheme.primary,
                child: Text(
                  header.avatarLabel ?? '',
                  style: primaryTextTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          // Body
          Expanded(
            child: IntrinsicHeight(
              child: ClipRect(
                child: OverflowBox(
                  alignment: Alignment.centerLeft,
                  maxWidth: widget.menu.theme.railMaxWidth -
                      widget.menu.theme.minWidth,
                  child: FadeTransition(
                    opacity: labelFadeAnimation,
                    child: Row(
                      children: [
                        // Title and subtitle
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title
                                if (header.title != null)
                                  DefaultTextStyle(
                                    style: theme.textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    child: header.title!,
                                  ),

                                // Subtitle
                                if (header.subtitle != null) ...[
                                  const SizedBox(height: 2),
                                  DefaultTextStyle(
                                    style: theme.textTheme.bodyMedium!.copyWith(
                                      color: theme.hintColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    child: header.subtitle!,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),

                        // Expanded icon
                        // if (header.dropdownItems.isNotEmpty &&
                        //     !header.popupDropdown)
                        //   ExpandIcon(
                        //     isExpanded: !_collapsed,
                        //     padding: EdgeInsets.zero,
                        //     onPressed: (_) {
                        //       if (header.popupDropdown) {
                        //         //
                        //       } else {
                        //         _focusNode.requestFocus();
                        //         setState(() {
                        //           _collapsed = !_collapsed;
                        //         });
                        //       }
                        //     },
                        //   ),

                        // Dropdown menu
                        if (header.dropdownItems.isNotEmpty)
                          MenuAnchor(
                            // childFocusNode: _buttonFocusNode,
                            menuChildren: header.dropdownItems,
                            builder: (context, controller, child) {
                              return IconButton(
                                onPressed: () {
                                  if (controller.isOpen) {
                                    controller.close();
                                  } else {
                                    controller.open();
                                  }
                                },
                                icon: const Icon(Icons.arrow_drop_down),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    //
    // if (header.dropdownItems.isNotEmpty && !header.popupDropdown) {
    //   child = Column(
    //     children: <Widget>[
    //       // Content
    //       child,

    //       // Dropdown items
    //       AnimatedSwitcher(
    //         duration: const Duration(milliseconds: 200),
    //         transitionBuilder: (Widget child, Animation<double> animation) {
    //           return SizeTransition(
    //             sizeFactor: animation,
    //             child: child,
    //           );
    //         },
    //         child: _collapsed || widget.extendedAnimation.value != 1
    //             ? const SizedBox.shrink()
    //             : IntrinsicHeight(
    //                 child: OverflowBox(
    //                   alignment: Alignment.centerLeft,
    //                   maxWidth: widget.menu.theme.maxWidth,
    //                   child: Padding(
    //                     padding: const EdgeInsets.only(bottom: 8),
    //                     child: Row(
    //                       children: [
    //                         const Spacer(),
    //                         Column(
    //                           children: header.dropdownItems.map((e) {
    //                             return MenuItemButton(
    //                               onPressed: e.onPressed,
    //                               shortcut: e.shortcut,
    //                               child: child,
    //                             );
    //                           }).toList(),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //       ),
    //     ],
    //   );
    // }

    return child;

    // return Focus(
    //   focusNode: _focusNode,
    //   child: child,
    // );
  }
}
