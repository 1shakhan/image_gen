import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gen/router/delegate.dart';
import 'package:image_gen/router/scope.dart';
import 'package:image_gen/router/translator.dart';

final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final pagesManager = RouterScope.managerOf(context, listen: true);

    return MaterialApp.router(
      routerDelegate: AppRouterDelegate(navigatorKey: _navigatorKey, manager: pagesManager),
      routeInformationParser: AppRouteInformationParser(),
      title: 'App for image generation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        appBarTheme: AppBarTheme(backgroundColor: Colors.white, centerTitle: true),
        scaffoldBackgroundColor: Colors.grey.shade50,
        textTheme: GoogleFonts.openSansTextTheme(),
      ),
    );
  }
}
