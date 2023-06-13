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
class SelectClassSuccess extends TeacherStates {}

class GetClassesSuccessState extends TeacherStates {}

class GetClassesLoadingState extends TeacherStates {}
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

class GetClassesErrorState extends TeacherStates {}


class GetStudentNamesSuccess extends TeacherStates {}

class SetLessonNameState extends TeacherStates {}

class GetStudentNamesError extends TeacherStates 
{
  String error;
  GetStudentNamesError(this.error);
}

class GetStudentNamesLoading extends TeacherStates {}

class AddStudenttoAttendanceState extends TeacherStates {}
class AddNewAttendanceLoadingState extends TeacherStates{}
class AddNewAttendanceSuccessState extends TeacherStates {}
class AttendanceNotTakenState extends TeacherStates {}

class AddNewAttendanceErrorState extends TeacherStates {
  String error;
  AddNewAttendanceErrorState(this.error);
}

class GetLessonsSuccessState extends TeacherStates {}
class GetLessonsLoadingState extends TeacherStates {}

class GetLessonsErrorState extends TeacherStates {}

class GetLessonAttendanceSuccessState extends TeacherStates {}

class GetLessonAttendanceErrorState extends TeacherStates {}

class GetLessonAttendanceLoadingState extends TeacherStates {}
class DeleteLessonAttendanceLoadingState extends TeacherStates {}

class DeleteLessonAttendanceSuccessState extends TeacherStates {}
class DeleteLessonAttendanceErrorState extends TeacherStates {}

class SavetoExcelSuccessState extends TeacherStates {}

class SavetoExcelErrorState extends TeacherStates {}

class SaveToThisLocationSuccess extends TeacherStates {}

class SelectFileSuccessState extends TeacherStates {}
class SelectStudentSuccessState extends TeacherStates {}
class SelectClassSuccessState extends TeacherStates {}
class SelectSubjectSuccessState extends TeacherStates {}

class ChangeSendToAllStateSuccessState extends TeacherStates {}

class NoteSendSuccessState extends TeacherStates {}
class NoteSendLoadingState extends TeacherStates {}
class NoteSendErrorState extends TeacherStates {}
class CancelFileUploadSuccessState extends TeacherStates {}
class CancelFileUploadErrorState extends TeacherStates {}
class UploadFileSuccessState extends TeacherStates{}
class UploadFileLoadingState extends TeacherStates{}
class UploadFileErrorState extends TeacherStates{}
class UploadProgressState extends TeacherStates{}
class DeleteUploadedFile extends TeacherStates{}

class UserSignOutSuccessState extends TeacherStates{}
class UserSignOutErrorState extends TeacherStates{}

class SelectStudentState extends TeacherStates{}

class SomethingWentWrong extends TeacherStates{}

class GetNotesByClassLoadingState extends TeacherStates{}
class GetNotesByClassSuccessState extends TeacherStates{}
class GetNotesByClassErrorState extends TeacherStates{}

class DeleteNotesByClassLoadingState extends TeacherStates{}
class DeleteNotesByClassSuccessState extends TeacherStates{}
class DeleteNotesByClassErrorState extends TeacherStates{}

class DeleteGradeFileSuccessState extends TeacherStates{}

class DownloadGradeTemplateLoadingState extends TeacherStates{}
class DownloadGradeTemplateSuccessState extends TeacherStates{}
class DownloadGradeTemplateErrorState extends TeacherStates{}

class ClassNotSelectedState extends TeacherStates{}

class GradeFileValidationSuccess extends TeacherStates{}

class GradeFileValidationError extends TeacherStates{}
class GradeFileNotSelectedState extends TeacherStates{}

class UploadGradesLoadingState extends TeacherStates{}
class UploadGradesSuccessState extends TeacherStates{}
class UploadGradesErrorState extends TeacherStates{}


class GetGradesLoadingState extends TeacherStates{}
class GetGradesSuccessState extends TeacherStates{}
class GetGradesErrorState extends TeacherStates{}

class DeleteExamResultsLoadingState extends TeacherStates{}
class DeleteExamResultsSuccessState extends TeacherStates{}
class DeleteExamResultsErrorState extends TeacherStates{}

class UpdateExamResultsLoadingState extends TeacherStates{}
class UpdateExamResultsSuccessState extends TeacherStates{}
class UpdateExamResultsErrorState extends TeacherStates{}

class CheckGradeTemplateFormatState extends TeacherStates{
  String error;
  CheckGradeTemplateFormatState(this.error);
}
class ModifyGradeSuccessState extends TeacherStates{}

class UpdateDateState extends TeacherStates{}
class ChangeAllTimeState extends TeacherStates{}