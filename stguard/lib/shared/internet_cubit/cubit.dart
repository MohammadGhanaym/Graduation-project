import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ConnectionStatus { connected, disconnected }

class InternetCubit extends Cubit<ConnectionStatus> {
  final Connectivity connectivity;
  StreamSubscription? connectivitySubscription;
  static InternetCubit get(context) => BlocProvider.of(context);
  bool isInitialized = false;
  InternetCubit(this.connectivity) : super(ConnectionStatus.disconnected) {
    connectivitySubscription =
        connectivity.onConnectivityChanged.listen((connectivityResult) {
      if (connectivityResult == ConnectivityResult.none) {
        if(isInitialized)
        {
          emit(ConnectionStatus.disconnected);
        }
        
      } else {
        if(isInitialized)
      {
         emit(ConnectionStatus.connected);
      }
       
      }
      isInitialized = true;
    }, onError: (e) {
      // Handle any errors that may occur while listening for network changes.
      print(e.toString());
    });
  }

  @override
  Future<void> close() {
    if (connectivitySubscription != null) {
      connectivitySubscription!.cancel();
    }
    return super.close();
  }
}
