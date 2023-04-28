abstract class RegisterStates {}

class RegisterInitState extends RegisterStates {}

class RadioButtonSelected extends RegisterStates {}

class ChangePasswordVisibilityState extends RegisterStates {}

class RegisterSuccessState extends RegisterStates {
  String userID;
  RegisterSuccessState(this.userID);
}

class RegisterLoadingState extends RegisterStates {}

class RegisterErrorState extends RegisterStates {
  String error;
  RegisterErrorState(this.error);
}

class EmailVerificationSendSuccess extends RegisterStates {}

class EmailVerificationSendError extends RegisterStates {}
