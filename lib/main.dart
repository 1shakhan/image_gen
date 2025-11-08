import 'package:flutter/material.dart';
import 'package:image_gen/app.dart';
import 'package:image_gen/router/scope.dart';
import 'package:image_gen/state/app.state.dart';

void main() {
  runApp(Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return const RouterScope(child: AppState(child: App()));
  }
}
