abstract class ParentStates {}

class ParentInitState extends ParentStates {}

class AddFamilyMemberSuccess extends ParentStates {}

class FamilyMemberAlreadyExisted extends ParentStates {
  String? message;
  FamilyMemberAlreadyExisted(this.message);
}

class IDNotFound extends ParentStates {
  String? message;
  IDNotFound(this.message);
}

class AddFamilyMemberLoading extends ParentStates {}

class AddFamilyMemberError extends ParentStates {}

class GetStudentDataSuccess extends ParentStates {}

class GetStudentDataLoading extends ParentStates {}

class GetStudentDataError extends ParentStates {}

class GetBalanceSuccess extends ParentStates {}

class GetBalanceLoading extends ParentStates {}

class GetBalanceError extends ParentStates {}

class ParentCreateDatabaseState extends ParentStates {}

class ParentInsertActivityTableSuccessState extends ParentStates {}

class ParentInsertTransactionsDatabaseSuccessState extends ParentStates {}

class ParentGetDataBaseLoadingState extends ParentStates {}

class ParentGeStudentActivitySuccessState extends ParentStates {}

class ParentGeStudentActivityErrorState extends ParentStates {}

class ParentGeSchoolTransactionsSuccessState extends ParentStates {}

class ParentAddNewTranscationSuccessState extends ParentStates {}

class ParentAddNewTranscationLoadingState extends ParentStates {}

class TransactionDeleteSuccess extends ParentStates {}

class ClearDatabaseSuccess extends ParentStates {}

class AttendanceHistoryLoading extends ParentStates {}

class AttendanceHistorySuccess extends ParentStates {}

class DeactivateDigitalIDSuccess extends ParentStates {}

class ShowSettingsState extends ParentStates {}
