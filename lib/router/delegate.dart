import 'package:flutter/material.dart';
import 'package:image_gen/router/configuration.dart';
import 'package:image_gen/router/route.enum.dart';
import 'package:image_gen/router/manager.dart';
import 'package:image_gen/view/not.found.screen.dart';
import 'package:image_gen/view/prompt.screen.dart';
import 'package:image_gen/view/result.screen.dart';

typedef Config = AppPagesConfig;

class AppRouterDelegate extends RouterDelegate<Config> with ChangeNotifier, PopNavigatorRouterDelegateMixin<Config> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  final RouterPagesManager manager;

  AppRouterDelegate({required this.navigatorKey, required this.manager}) {
    manager.addListener(notifyListeners);
  }

  @override
  void dispose() {
    manager.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: _resolvePages(manager.pages).toList(growable: false),
      onPopPage: _onPopPage,
    );
  }

  @override
  Config get currentConfiguration => manager.configuration;

  Iterable<Page> _resolvePages(List<PageConfiguration> configs) sync* {
    for (final config in configs) {
      switch (config.page) {
        case AppPage.prompt:
          yield MaterialPage(child: const PromptScreen(), arguments: config.argument);
          break;
        case AppPage.result:
          yield MaterialPage(child: const ResultScreen(), arguments: config.argument);
          break;
        case AppPage.unknown:
          yield MaterialPage(child: const NotFoundScreen(), arguments: config.argument);
          break;
      }
    }
  }

  bool _onPopPage(Route<Object?> route, Object? result) {
    if (route.isFirst && route.isActive) return false;
    if (!route.didPop(result)) return false;

    manager.pop();
    return true;
  }

  @override
  Future<void> setNewRoutePath(AppPagesConfig configuration) async {
    manager.setNewRoutePath(configuration);
    notifyListeners();
  }
}
