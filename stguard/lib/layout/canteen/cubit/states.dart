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

class GetAllProductsSuccessState extends CanteenStates {}

class SelectProductState extends CanteenStates {}

class CalculateTotalPriceState extends CanteenStates {}

class CancelSelectedProductState extends CanteenStates {}

class CartHaveProductsState extends CanteenStates {}

class CartEmptyState extends CanteenStates {}

class ShowBottomSheetState extends CanteenStates {}

class GetInventorySearchResultssSuccessState extends CanteenStates {}

class GetInventorySearchResultssLoadingState extends CanteenStates {}

class AddIngredientSuccessState extends CanteenStates {}

class RemoveIngredientSuccessState extends CanteenStates {}

class ItemImagePickedSucessState extends CanteenStates {}

class ItemImagePickedErrorState extends CanteenStates {}

class UploadItemImageLoadingState extends CanteenStates {}

class UploadItemImageSuccessState extends CanteenStates {}

class UploadItemImageErrorState extends CanteenStates {}

class UploadItemDataLoadingState extends CanteenStates {}

class UploadItemDataSuccessState extends CanteenStates {}

class UploadItemDataErrorState extends CanteenStates {}

class GetAllergiesLoadingState extends CanteenStates {}

class GetAllergiesSuccessState extends CanteenStates {}

class GetAllergiesErrorState extends CanteenStates {}

class StartListeningBuyerDataState extends CanteenStates {}

class PaymentLoadingState extends CanteenStates {}

class PaymentSuccessState extends CanteenStates {}

class PaymentErrorState extends CanteenStates {}

class GetCanteenDetailsLoadingState extends CanteenStates {}

class GetCanteenDetailsSuccessState extends CanteenStates {}

class GetCanteenDetailsErrorState extends CanteenStates {}

class UpdatePriceSuccessState extends CanteenStates {}

class UpdatePriceLoadingState extends CanteenStates {}

class UpdatePriceErrorState extends CanteenStates {}

class DeleteItemSuccessState extends CanteenStates {}

class DeleteItemLoadingState extends CanteenStates {}

class DeleteItemErrorState extends CanteenStates {}