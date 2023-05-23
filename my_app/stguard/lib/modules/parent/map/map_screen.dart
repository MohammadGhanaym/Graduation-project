import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stguard/layout/parent/cubit/cubit.dart';
import 'package:stguard/layout/parent/cubit/states.dart';

class MapScreen extends StatelessWidget {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ParentCubit, ParentStates>(
      listener: (context, state) {
        if (state is GetStudentLocationSuccessState) {}
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (ParentCubit.get(context).locationListener != null) {
                    ParentCubit.get(context).locationListener!.cancel();
                  }
                },
                icon: const Icon(Icons.arrow_back)),
                actions: [IconButton(onPressed:() {
                  ParentCubit.get(context).openMap(
                                                lat: ParentCubit.get(context)
                                                    .location!
                                                    .lat,
                                                long: ParentCubit.get(context)
                                                    .location!
                                                    .long);
                }, icon: const ImageIcon(AssetImage('assets/images/map.png'), color: Colors.white,))],
          ),
          body: GoogleMap(
            zoomControlsEnabled:false,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(ParentCubit.get(context).location!.lat,
                  ParentCubit.get(context).location!.long),
              zoom: 14.4746,
            ),
            
            markers: {
              Marker(
                  markerId: const MarkerId('source'),
                  position: LatLng(ParentCubit.get(context).location!.lat,
                      ParentCubit.get(context).location!.long))
            },
            onMapCreated: (GoogleMapController controller) async {
              _controller.complete(controller);
           
              ParentCubit.get(context).setMapController(await _controller.future);
             
            },
          ),
        );
      },
    );
  }
}
