import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

class ImageLoadingState extends Cubit<int> {
  ImageLoadingState() : super(0);

  next() {
    emit(Random().nextInt(99));
  }
}
