import 'package:flutter_bloc/flutter_bloc.dart';

class ImagePromptState extends Cubit<String> {
  ImagePromptState() : super('');

  next(String val) {
    emit(val);
  }
}