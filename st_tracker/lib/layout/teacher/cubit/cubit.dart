import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/layout/teacher/cubit/states.dart';

class TeacherCubit extends Cubit<TeacherStates> {
  TeacherCubit() : super(TeacherInitState());
  static TeacherCubit get(context) => BlocProvider.of(context);
}
