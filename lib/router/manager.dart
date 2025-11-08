import 'package:flutter/foundation.dart';
import 'package:image_gen/router/configuration.dart';
import 'package:image_gen/router/route.enum.dart';

abstract class RouterPagesManagerAbstract implements Listenable {
  List<PageConfiguration> get pages;

  AppPagesConfig get configuration;

  bool get canPop;

  void pop();

  void push(AppPage page, {Object? argument});

  void setNewRoutePath(AppPagesConfig configuration);
}

class RouterPagesManager extends ChangeNotifier implements RouterPagesManagerAbstract {
  late AppPagesConfig _pagesConfig = AppPagesConfig([PageConfiguration(page: AppPage.prompt)]);

  @override
  List<PageConfiguration> get pages => _pagesConfig.pages;

  @override
  AppPagesConfig get configuration => _pagesConfig;

  @override
  bool get canPop => _pagesConfig.length > 1;

  @override
  void pop() {
    if (!canPop) return;

    _pagesConfig.pop();
    notifyListeners();
  }

  @override
  void push(AppPage page, {Object? argument}) {
    if (page == _pagesConfig.last.page) return;

    _pagesConfig.push(PageConfiguration(page: page, argument: argument));
    notifyListeners();
  }

  @override
  void setNewRoutePath(AppPagesConfig configuration) {
    _pagesConfig = configuration;
    notifyListeners();
  }
}
