abstract class TeacherStates {}

class TeacherInitState extends TeacherStates {}

class GetTeacherPathSuccessState extends TeacherStates {}

class GetTeacherPathLoadingState extends TeacherStates {}

class GetTeacherPathErrorState extends TeacherStates {}
class ResetIDSuccessState extends TeacherStates{}
class ResetIDErrorState extends TeacherStates{}

class GetCountriesLoadingState extends TeacherStates {}

class GetCountriesSucessState extends TeacherStates {}

class GetCountriesErrorState extends TeacherStates {
  String error;
  GetCountriesErrorState(this.error);
}

class PickCountryState extends TeacherStates {}

class GetSchoolsLoadingState extends TeacherStates {}

class GetSchoolsErrorState extends TeacherStates {
  String error;
  GetSchoolsErrorState(this.error);
}
class SelectGradeSuccess extends TeacherStates {}

class GetGradesSuccessState extends TeacherStates {}

class GetGradesLoadingState extends TeacherStates {}
class GetSchoolsSucessState extends TeacherStates {}

class AddTeacherLoadingState extends TeacherStates {}

class AddTeacherErrorState extends TeacherStates {
  String error;
  AddTeacherErrorState(this.error);
}

class AddTeacherSucessState extends TeacherStates {}
class NeedtoJoinCommunityState extends TeacherStates {}

class PickSchoolState extends TeacherStates {}

class GetUserInfoLoading extends TeacherStates {}

class GetUserInfoSuccess extends TeacherStates {}

class GetUserInfoError extends TeacherStates {}

class GetGradesErrorState extends TeacherStates {}

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
class GetLessonsLoadingState extends TeacherStates {}

class GetLessonsErrorState extends TeacherStates {}

class GetLessonAttendanceSuccessState extends TeacherStates {}

class GetLessonAttendanceErrorState extends TeacherStates {}

class GetLessonAttendanceLoadingState extends TeacherStates {}

class DeleteLessonAttendanceSuccessState extends TeacherStates {}
class DeleteLessonAttendanceErrorState extends TeacherStates {}

class SavetoExcelSuccessState extends TeacherStates {}

class SavetoExcelErrorState extends TeacherStates {}

class SaveToThisLocationSuccess extends TeacherStates {}
