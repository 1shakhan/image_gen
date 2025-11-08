import 'package:flutter_bloc/flutter_bloc.dart';

class ImageListState extends Cubit<List<ImageLoadProcResult>> {
  ImageListState() : super([]);

  clear() {
    emit([]);
  }

  add(String? link, String prompt) {
    if (state.lastOrNull?.error == true && link != null) return changeLast(link);
    final newList = [
      ...state,
      ImageLoadProcResult(link: link, error: link == null, time: DateTime.now(), prompt: prompt),
    ];
    emit(newList);
  }

  changeLast(String link) {
    final list = [...state];
    final last = state.lastOrNull;
    list[list.length - 1] = ImageLoadProcResult(link: link, time: DateTime.now(), prompt: last?.prompt);
    emit(list);
  }
}

class ImageLoadProcResult {
  final bool error;
  final String? link;
  final DateTime time;
  final String? prompt;

  ImageLoadProcResult({this.error = false, this.link, required this.time, this.prompt});
}
