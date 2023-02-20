abstract class CanteenStates {}

class CanteenInitState extends CanteenStates {}

class GetUserInfoLoading extends CanteenStates {}

class GetUserInfoSuccess extends CanteenStates {}

class GetUserInfoError extends CanteenStates {}

class GetCanteenPathLoadingState extends CanteenStates {}

class GetCanteenPathErrorState extends CanteenStates {}

class GetCanteenPathSuccessState extends CanteenStates {}

class NeedtoJoinCommunityState extends CanteenStates {}

class ResetIDSuccessState extends CanteenStates {}

class ResetIDErrorState extends CanteenStates {}

class AddCanteenLoadingState extends CanteenStates {}

class AddCanteenSucessState extends CanteenStates {}

class AddCanteenErrorState extends CanteenStates {
  String error;
  AddCanteenErrorState(this.error);
}

class GetCountriesLoadingState extends CanteenStates {}

class GetCountriesSucessState extends CanteenStates {}

class GetCountriesErrorState extends CanteenStates {
  String error;
  GetCountriesErrorState(this.error);
}

class PickCountryState extends CanteenStates {}

class GetSchoolsLoadingState extends CanteenStates {}

class GetSchoolsSucessState extends CanteenStates {}

class GetSchoolsErrorState extends CanteenStates {
  String error;
  GetSchoolsErrorState(this.error);
}

class PickSchoolState extends CanteenStates {}

class SwitchScreenState extends CanteenStates {}

class GetCategoriesLoadingState extends CanteenStates {}

class GetCategoriesSuccessState extends CanteenStates {}

class GetCategoriesErrorState extends CanteenStates {}

class GetProductsLoadingState extends CanteenStates {}

class GetProductsSuccessState extends CanteenStates {}

class GetProductsErrorState extends CanteenStates {}
class GetAllProductsSuccessState extends CanteenStates{}
class SelectProductState extends CanteenStates{}

class CartHaveProductsState extends CanteenStates{}
class CartEmptyState extends CanteenStates{}
class ShowBottomSheetState extends CanteenStates{}

