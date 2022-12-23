import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/layout/canteen/cubit/states.dart';

class CanteenCubit extends Cubit<CanteenStates> {
  CanteenCubit() : super(CanteenInitState());
  static CanteenCubit get(context) => BlocProvider.of(context);
}
