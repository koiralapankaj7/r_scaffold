// ignore_for_file: lines_longer_than_80_chars

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:playground/src/responsive_scaffold.dart';
import 'package:playground/src/widgets/responsive_menu.dart';

enum _RMenuQueryAspect {
  minWidth,
  maxWidth,
  theme,
  sizeAnimation,
  positionAnimation,
  fadeAnimation,
  state,
  borderRadius,
}

///
class RMenuData extends Equatable {
  ///
  const RMenuData({
    required this.minWidth,
    required this.maxWidth,
    required this.theme,
    required this.state,
    required this.sizeAnimation,
    required this.positionAnimation,
  });

  ///
  final double minWidth;

  ///
  final double maxWidth;

  ///
  final RMenuTheme theme;

  ///
  final MenuState state;

  ///
  final Animation<double> sizeAnimation;

  ///
  final Animation<double> positionAnimation;

  ///
  Animation<double> get fadeAnimation => state == MenuState.closed
      ? sizeAnimation.drive(Tween<double>(begin: 1, end: 1))
      : sizeAnimation.drive(
          CurveTween(curve: const Interval(0.20, 1)),
        );

  ///
  BorderRadius resolveRadius({TextDirection? direction}) {
    if (theme.radius != null) return theme.radius!;
    return switch (theme.indicatorShape) {
      RoundedRectangleBorder(:final borderRadius) =>
        borderRadius.resolve(direction),
      _ => BorderRadius.circular(minWidth * 0.5),
    };
  }

  @override
  List<Object?> get props => [
        minWidth,
        maxWidth,
        theme,
        state,
        sizeAnimation,
        positionAnimation,
      ];
}

///
class RMenuQuery extends InheritedModel<_RMenuQueryAspect> {
  ///
  const RMenuQuery({
    required this.data,
    required super.child,
    super.key,
  });

  ///
  final RMenuData data;

  /// The data from the closest instance of this class that encloses the given
  /// context.
  static RMenuData of(BuildContext context) => _of(context);

  static RMenuData _of(BuildContext context, [_RMenuQueryAspect? aspect]) {
    assert(_debugCheckHasRMenuQuery(context), '');
    return InheritedModel.inheritFrom<RMenuQuery>(context, aspect: aspect)!
        .data;
  }

  /// The data from the closest instance of this class that encloses the given
  /// context, if any.
  static RMenuData? maybeOf(BuildContext context) => _maybeOf(context);

  static RMenuData? _maybeOf(
    BuildContext context, [
    _RMenuQueryAspect? aspect,
  ]) {
    return InheritedModel.inheritFrom<RMenuQuery>(context, aspect: aspect)
        ?.data;
  }

  /// Returns size for the nearest MediaQuery ancestor or
  /// throws an exception, if no such ancestor exists.
  ///
  /// Use of this method will cause the given [context] to rebuild any time that
  /// the [MediaQueryData.size] property of the ancestor [MediaQuery] changes.
  static double minWidthOf(BuildContext context) =>
      _of(context, _RMenuQueryAspect.minWidth).minWidth;

  ///
  static double maxWidthOf(BuildContext context) =>
      _of(context, _RMenuQueryAspect.maxWidth).maxWidth;

  ///
  static RMenuTheme themeOf(BuildContext context) =>
      _of(context, _RMenuQueryAspect.theme).theme;

  ///
  static Animation<double> sizeAnimationOf(BuildContext context) =>
      _of(context, _RMenuQueryAspect.sizeAnimation).sizeAnimation;

  ///
  static Animation<double> positionAnimationOf(BuildContext context) =>
      _of(context, _RMenuQueryAspect.positionAnimation).positionAnimation;

  ///
  static Animation<double> fadeAnimationOf(BuildContext context) =>
      _of(context, _RMenuQueryAspect.fadeAnimation).fadeAnimation;

  ///
  static BorderRadius borderRadiusOf(
    BuildContext context, {
    TextDirection? direction,
  }) =>
      _of(context, _RMenuQueryAspect.borderRadius)
          .resolveRadius(direction: direction);

  @override
  bool updateShouldNotify(RMenuQuery oldWidget) => oldWidget.data != data;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<RMenuData>('data', data, showName: false));
  }

  @override
  bool updateShouldNotifyDependent(
    RMenuQuery oldWidget,
    Set<Object> dependencies,
  ) {
    for (final dependency in dependencies) {
      if (dependency is _RMenuQueryAspect) {
        return switch (dependency) {
          _RMenuQueryAspect.minWidth =>
            oldWidget.data.minWidth != data.minWidth,
          _RMenuQueryAspect.maxWidth =>
            oldWidget.data.maxWidth != data.maxWidth,
          _RMenuQueryAspect.theme => oldWidget.data.theme != data.theme,
          _RMenuQueryAspect.state => oldWidget.data.state != data.state,
          _RMenuQueryAspect.sizeAnimation =>
            oldWidget.data.sizeAnimation != data.sizeAnimation,
          _RMenuQueryAspect.positionAnimation =>
            oldWidget.data.positionAnimation != data.positionAnimation,
          _RMenuQueryAspect.fadeAnimation =>
            oldWidget.data.fadeAnimation != data.fadeAnimation,
          _RMenuQueryAspect.borderRadius => oldWidget.data.theme.radius !=
                  data.theme.radius ||
              oldWidget.data.theme.indicatorShape != data.theme.indicatorShape,
        };
      }
    }
    return false;
  }
}

///
bool _debugCheckHasRMenuQuery(BuildContext context) {
  assert(
    () {
      if (context.widget is! RMenuQuery &&
          context.getElementForInheritedWidgetOfExactType<RMenuQuery>() ==
              null) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('No RMenuQuery widget ancestor found.'),
          ErrorDescription(
            '${context.widget.runtimeType} widgets require a RMenuQuery widget ancestor.',
          ),
          context.describeWidget(
            'The specific widget that could not find a RMenuQuery ancestor was',
          ),
          context.describeOwnershipChain(
            'The ownership chain for the affected widget is',
          ),
          ErrorHint(
              'No RMenuQuery ancestor could be found starting from the context '
              'that was passed to RMenuQuery.of(). This can happen because the '
              'context used is not a descendant of a View widget, which introduces '
              'a RMenuQuery.'),
        ]);
      }
      return true;
    }(),
    '',
  );
  return true;
}
