import 'package:flutter/material.dart';
import 'package:image_gen/router/configuration.dart';
import 'package:image_gen/router/route.enum.dart';

class AppRouteInformationParser extends RouteInformationParser<AppPagesConfig> {
  @override
  Future<AppPagesConfig> parseRouteInformation(RouteInformation routeInformation) async {
    if (routeInformation.uri.pathSegments.isEmpty) {
      return AppPagesConfig([PageConfiguration.fromPath(pathName: AppPage.prompt.name)]);
    }
    final pathName = routeInformation.uri.pathSegments.first;
    return AppPagesConfig([PageConfiguration.fromPath(pathName: pathName)]);
  }

  @override
  RouteInformation? restoreRouteInformation(AppPagesConfig configuration) {
    if (configuration.pages.isEmpty) {
      return null;
    }
    return RouteInformation(uri: Uri.parse(configuration.last.page.location));
  }
}
