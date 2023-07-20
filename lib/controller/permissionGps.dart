import 'package:geolocator/geolocator.dart';

class PermissionGps {
  Future<Position>init() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Error localisation not enabled");
    } else {
      LocationPermission permission = await Geolocator.checkPermission();
      return checkPermission(permission);
    }
  }

  Future<Position> checkPermission(LocationPermission permission) async {
    switch(permission) {
      case LocationPermission.denied:
        permission = await Geolocator.requestPermission();
        return checkPermission(permission);
      case LocationPermission.deniedForever:
        return Future.error("Error localisation not enabled");
      case LocationPermission.unableToDetermine:
        return await Geolocator.requestPermission().then((value) => checkPermission(value));
      case LocationPermission.whileInUse:
        return await Geolocator.getCurrentPosition();
      case LocationPermission.always:
        return await Geolocator.getCurrentPosition();
      default:
        return await Geolocator.getCurrentPosition();
    }
  }
}