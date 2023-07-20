import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMaps extends StatefulWidget {
  Position location;
  GoogleMaps({super.key, required this.location});

  @override
  State<GoogleMaps> createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  Completer<GoogleMapController> completer = Completer();
  late CameraPosition camera;

  void initState() {
    camera = CameraPosition(target: LatLng(widget.location.latitude, widget.location.longitude), zoom: 15);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: camera,
      myLocationButtonEnabled: true,
      mapToolbarEnabled: true,
      onMapCreated: (control) async {
        String newStyle = await DefaultAssetBundle.of(context).loadString('lib/mapStyle.json');
        control.setMapStyle(newStyle);
        completer.complete(control);
      },
    );
  }
}
