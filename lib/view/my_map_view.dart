import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ipssisqy2023/view/google_maps.dart';
import '../controller/permissionGps.dart';

class MyMapView extends StatefulWidget {
  const MyMapView({super.key});

  @override
  State<MyMapView> createState() => _MyMapViewState();
}

class _MyMapViewState extends State<MyMapView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Position>(
        future: PermissionGps().init(),
        builder: (context, snap){
          if(snap.data == null){
            return const Center(child: Text("Aucune donnée"));
          } else {
            Position location = snap.data!;
            return GoogleMaps(location :location);
          }
        }
    );
  }
}
