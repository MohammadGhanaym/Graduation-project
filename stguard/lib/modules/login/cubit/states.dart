abstract class LoginStates {}

class LoginInitState extends LoginStates {}

class RadioButtonSelected extends LoginStates {}

class ChangePasswordVisibilityState extends LoginStates {}

class ChangeReadOnlyState extends LoginStates {}

class LoginSuccessState extends LoginStates {
  String userID;
  String? userRole;
  LoginSuccessState(this.userID, this.userRole);
}

class LoginLoadingState extends LoginStates {}

class LoginErrorState extends LoginStates {
  String error;
  LoginErrorState(this.error);
}

class EmailVerificationSendSuccess extends LoginStates {}

class EmailVerificationSendError extends LoginStates {}

class SendPasswordResetEmailSuccessState extends LoginStates {}

class SendPasswordResetEmailErrorState extends LoginStates {
  String error;
  SendPasswordResetEmailErrorState(this.error);
}

class ChangeLoadingState extends LoginStates {}
