import 'package:flutter/cupertino.dart';
import 'package:image_gen/router/manager.dart';

class RouterScope extends StatefulWidget {
  final Widget child;

  const RouterScope({required this.child, super.key});

  @override
  State<RouterScope> createState() => _RouterScopeState();

  static RouterPagesManager managerOf(BuildContext context, {bool listen = false}) {
    return _RouterScopeInherited.of(context, listen: listen);
  }
}

class _RouterScopeState extends State<RouterScope> {
  late final RouterPagesManager manager = RouterPagesManager();

  @override
  void dispose() {
    manager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _RouterScopeInherited(pagesManager: manager, child: widget.child);
  }
}

class _RouterScopeInherited extends InheritedWidget {
  final RouterPagesManager pagesManager;

  const _RouterScopeInherited({required this.pagesManager, required super.child});

  static RouterPagesManager of(BuildContext context, {bool listen = false}) {
    final manager = maybeOf(context);
    return ArgumentError.checkNotNull(manager);
  }

  static RouterPagesManager? maybeOf(BuildContext context, {bool listen = false}) {
    if (listen) {
      return context.dependOnInheritedWidgetOfExactType<_RouterScopeInherited>()?.pagesManager;
    } else {
      return (context.getElementForInheritedWidgetOfExactType<_RouterScopeInherited>()?.widget
              as _RouterScopeInherited?)
          ?.pagesManager;
    }
  }

  @override
  bool updateShouldNotify(_RouterScopeInherited oldWidget) {
    return oldWidget.pagesManager != pagesManager;
  }
}
