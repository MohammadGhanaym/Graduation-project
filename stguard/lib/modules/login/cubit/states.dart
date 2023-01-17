abstract class LoginStates {}

class LoginInitState extends LoginStates {}

class RadioButtonSelected extends LoginStates {}

class ChangePasswordVisibilityState extends LoginStates {}

class LoginSuccessState extends LoginStates {
  String userID;
  LoginSuccessState(this.userID);
}

class LoginLoadingState extends LoginStates {}

class LoginErrorState extends LoginStates {
  String error;
  LoginErrorState(this.error);
}

class EmailVerificationSendSuccess extends LoginStates {}

class EmailVerificationSendError extends LoginStates {}
