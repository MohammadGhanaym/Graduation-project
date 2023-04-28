abstract class ParentStates {}

class ParentInitState extends ParentStates {}

class AddFamilyMemberSuccess extends ParentStates {}

class FamilyMemberAlreadyExisted extends ParentStates {
  String? message;
  FamilyMemberAlreadyExisted(this.message);
}

class FamilyMemberAlreadyHasParent extends ParentStates {
  String? message;
  FamilyMemberAlreadyHasParent(this.message);
}

class IDNotFound extends ParentStates {
  String? message;
  IDNotFound(this.message);
}

class AddFamilyMemberLoading extends ParentStates {}

class AddFamilyMemberError extends ParentStates {}

class GetStudentsPathsSuccess extends ParentStates {}

class GetStudentsPathsLoading extends ParentStates {}

class GetStudentsPathsError extends ParentStates {
  String error;
  GetStudentsPathsError(this.error);
}

class GetStudentDataSuccess extends ParentStates {}

class GetStudentDataLoading extends ParentStates {}

class GetStudentDataError extends ParentStates {}

class GetUserInfoSuccess extends ParentStates {}

class GetUserInfoLoading extends ParentStates {}

class GetUserInfoError extends ParentStates {}

class UpdateBalanceSuccess extends ParentStates {}

class UpdateBalanceLoading extends ParentStates {}

class UpdateBalanceError extends ParentStates {}

class ParentCreateDatabaseState extends ParentStates {}

class ParentInsertActivityTableSuccessState extends ParentStates {}

class ParentInsertTransactionsDatabaseSuccessState extends ParentStates {}

class ParentGetDataBaseLoadingState extends ParentStates {}

class ParentGeStudentActivitySuccessState extends ParentStates {}

class ParentGeStudentActivityErrorState extends ParentStates {}

class ParentGeSchoolTransactionsSuccessState extends ParentStates {}

class ParentAddNewAttendanceSuccessState extends ParentStates {}

class ParentAddNewTranscationLoadingState extends ParentStates {}

class ClearDatabaseSuccess extends ParentStates {}

class AttendanceHistoryLoading extends ParentStates {}

class AttendanceHistorySuccess extends ParentStates {}

class UnpairDigitalIDSuccess extends ParentStates {}

class UnpairDigitalIDError extends ParentStates {}

class DeactivateDigitalIDSuccess extends ParentStates {}

class DeactivateDigitalIDError extends ParentStates {}

class ActivateDigitalIDSuccess extends ParentStates {}

class ActivateDigitalIDError extends ParentStates {}

class ShowSettingsState extends ParentStates {}

class GetStudentLocationSuccessState extends ParentStates {}

class GetStudentLocationLoadingState extends ParentStates {}

class SetPocketMoneySuccessState extends ParentStates {}

class SetPocketMoneyLoadingState extends ParentStates {}

class SetPocketMoneyErrorState extends ParentStates {}

class GetPocketMoneySuccessState extends ParentStates {}

class GetPocketMoneyLoadingState extends ParentStates {}

class GetPocketMoneyErrorState extends ParentStates {}

class ChangeSliderState extends ParentStates {}

class ShowBottomSheetState extends ParentStates {}

class RechargeSuccessState extends ParentStates {
  var amount;
  RechargeSuccessState(this.amount);
}

class RechargeLoadingState extends ParentStates {}

class RechargeErrorState extends ParentStates {
  dynamic error;
  RechargeErrorState(this.error);
}

class GetAllergiesSucessState extends ParentStates {}

class GetAllergiesLoadingState extends ParentStates {}

class GetAllergiesErrorState extends ParentStates {
  dynamic error;
  GetAllergiesErrorState(this.error);
}

class AddAllergenState extends ParentStates {}

class RemoveAllergenState extends ParentStates {}

class UpdateAllergiesSuccessState extends ParentStates {}

class UpdateAllergiesLoadingState extends ParentStates {}

class UpdateAllergiesErrorState extends ParentStates {
  var error;
  UpdateAllergiesErrorState(this.error);
}

class GetDigitalIDStateLoading extends ParentStates {}

class GetDigitalIDStateSuccess extends ParentStates {}

class GetDigitalIDStateError extends ParentStates {
  var error;
  GetDigitalIDStateError(this.error);
}

class GetCountriesSucessState extends ParentStates {}

class GetCountriesLoadingState extends ParentStates {}

class GetCountriesErrorState extends ParentStates {
  dynamic error;
  GetCountriesErrorState(this.error);
}

class GetSchoolsSucessState extends ParentStates {}

class GetSchoolsLoadingState extends ParentStates {}

class GetSchoolsErrorState extends ParentStates {
  dynamic error;
  GetSchoolsErrorState(this.error);
}

class PickSchoolState extends ParentStates {}

class PickCountryState extends ParentStates {}

class CreditCardModelChangeState extends ParentStates {}

class SetCalorieState extends ParentStates {}

class GetCalorieSuccessState extends ParentStates {}

class GetCalorieLoadingState extends ParentStates {}

class GetCalorieErrorState extends ParentStates {}

class UpdateCalorieSuccessState extends ParentStates {}

class UpdateCalorieLoadingState extends ParentStates {}

class UpdateCalorieErrorState extends ParentStates {}

class GetNotesSuccessState extends ParentStates {}

class GetNotesLoadingState extends ParentStates {}

class GetNotesErrorState extends ParentStates {}

class FileDownloadSuccessState extends ParentStates{}
class FileDownloadLoadingState extends ParentStates{}

class FileDownloadErrorState extends ParentStates{}

class DownloadFileProgress extends ParentStates{}

class DeleteFileSuccessState extends ParentStates{}

class CancelDownloadState extends ParentStates{}

class UserSignOutSuccessState extends ParentStates{}
class UserSignOutErrorState extends ParentStates{}