import 'package:flutter_bloc/flutter_bloc.dart';

class ImageProcState extends Cubit<int?>{
  ImageProcState(): super(null);

  next(){
    emit(1);
  }

  clear(){
    emit(null);
  }
}