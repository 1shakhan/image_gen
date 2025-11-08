import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gen/state/image.list.state.dart';
import 'package:image_gen/state/image.loading.state.dart';
import 'package:image_gen/state/image.proc.state.dart';
import 'package:image_gen/state/image.prompt.state.dart';

class AppState extends StatelessWidget {
  const AppState({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ImageListState()),
        BlocProvider(create: (context) => ImageLoadingState()),
        BlocProvider(create: (context) => ImageProcState()),
        BlocProvider(create: (context)=> ImagePromptState()),
      ],
      child: child,
    );
  }
}
