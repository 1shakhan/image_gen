import 'package:image_gen/router/route.enum.dart';
import 'package:image_gen/router/stack.dart';

class PageConfiguration {
  late final AppPage page;

  final Object? argument;

  static final Map<String, AppPage> _pagePathsMap = {
    AppPage.unknown.pathName: AppPage.unknown,
    AppPage.result.pathName: AppPage.result,
    AppPage.prompt.pathName: AppPage.prompt,
  };

  PageConfiguration({required this.page, this.argument});

  PageConfiguration.fromPath({required String pathName, this.argument}) {
    page = _resolvePage(pathName);
  }

  @override
  int get hashCode => Object.hash(page, argument);

  @override
  bool operator ==(Object other) {
    return other is PageConfiguration &&
        runtimeType == other.runtimeType &&
        page == other.page &&
        argument == other.argument;
  }

  static AppPage _resolvePage(String? path) {
    return _pagePathsMap[path] ?? AppPage.unknown;
  }
}

class AppPagesConfig extends RouterPagesStack<PageConfiguration> {
  AppPagesConfig(super.stack);
}
