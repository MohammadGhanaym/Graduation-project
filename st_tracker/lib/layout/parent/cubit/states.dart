abstract class ParentStates {}

class ParentInitState extends ParentStates {}

class GetStudentDataSuccess extends ParentStates {}

class GetStudentDataLoading extends ParentStates {}

class GetStudentDataError extends ParentStates {}

class ParentCreateDatabaseState extends ParentStates {}

class ParentInsertAttendanceDatabaseSuccessState extends ParentStates {}

class ParentInsertTransactionsDatabaseSuccessState extends ParentStates {}

class ParentGetDataBaseLoadingState extends ParentStates {}

class ParentGeSchoolAttendanceSuccessState extends ParentStates {}

class ParentGeSchoolTransactionsSuccessState extends ParentStates {}

class ParentAddNewTranscationSuccessState extends ParentStates {}

class ParentAddNewTranscationLoadingState extends ParentStates {}

class TransactionDeleteSuccess extends ParentStates {}

class ClearDatabaseSuccess extends ParentStates {}