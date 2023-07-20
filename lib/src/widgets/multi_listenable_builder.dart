import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

///
class MultiListenableBuilder extends StatefulWidget {
  /// Creates a widget that rebuilds when the given listenable changes.
  ///
  /// The [listenables] argument is required.
  const MultiListenableBuilder({
    required this.listenables,
    required this.builder,
    this.child,
    super.key,
  });

  /// The list od [Listenable] to which this widget is listening.
  ///
  /// Commonly an [Animation] or a [ChangeNotifier].
  final List<Listenable> listenables;

  /// Called every time the [listenables] notifies about a change.
  ///
  /// The child given to the builder should typically be part of the returned
  /// widget tree.
  final TransitionBuilder builder;

  /// The child widget to pass to the [builder].
  ///
  /// {@macro flutter.widgets.transitions.ListenableBuilder.optimizations}
  final Widget? child;

  /// Subclasses typically do not override this method.
  @override
  State<MultiListenableBuilder> createState() => _AnimatedState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<List<Listenable>>('listenables', listenables),
    );
  }
}

class _AnimatedState extends State<MultiListenableBuilder> {
  @override
  void initState() {
    super.initState();
    _addListeners();
  }

  void _addListeners() {
    for (final listenable in widget.listenables) {
      listenable.addListener(_handleChange);
    }
  }

  @override
  void didUpdateWidget(MultiListenableBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(widget.listenables, oldWidget.listenables)) {
      _removeListeners(oldWidget);
      _addListeners();
    }
  }

  @override
  void dispose() {
    _removeListeners(widget);
    super.dispose();
  }

  void _removeListeners(MultiListenableBuilder origin) {
    for (final listenable in origin.listenables) {
      listenable.removeListener(_handleChange);
    }
  }

  void _handleChange() {
    setState(() {
      // The listenable's state is our build state, and it changed already.
    });
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, widget.child);
}
