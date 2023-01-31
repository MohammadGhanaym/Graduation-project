abstract class TeacherStates {}

class TeacherInitState extends TeacherStates {}

class SelectGradeSuccess extends TeacherStates {}

class GetGradesSuccessState extends TeacherStates {}

class GetGradesErrorState extends TeacherStates {}

class BottomSheetShownState extends TeacherStates {}

class BottomSheetHiddenState extends TeacherStates {}

class SwitchScreenState extends TeacherStates {}

class GetStudentNamesSuccess extends TeacherStates {}

class SetLessonNameState extends TeacherStates {}

class GetStudentNamesError extends TeacherStates {}

class GetStudentNamesLoading extends TeacherStates {}

class AddStudenttoAttendanceState extends TeacherStates {}

class AddNewAttendanceSuccessState extends TeacherStates {}

class AddNewAttendanceErrorState extends TeacherStates {
  var error;
  AddNewAttendanceErrorState(this.error);
}

class GetLessonsSuccessState extends TeacherStates {}

class GetLessonsErrorState extends TeacherStates {}
