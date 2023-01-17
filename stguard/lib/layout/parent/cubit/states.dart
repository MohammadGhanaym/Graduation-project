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

class ParentAddNewTranscationSuccessState extends ParentStates {}

class ParentAddNewTranscationLoadingState extends ParentStates {}

class TransactionDeleteSuccess extends ParentStates {}

class ClearDatabaseSuccess extends ParentStates {}

class AttendanceHistoryLoading extends ParentStates {}

class AttendanceHistorySuccess extends ParentStates {}

class DeactivateDigitalIDSuccess extends ParentStates {}

class ShowSettingsState extends ParentStates {}

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
  late String error;
  RechargeErrorState(this.error);
}
