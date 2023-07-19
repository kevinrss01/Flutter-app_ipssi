import 'package:permission_handler/permission_handler.dart';

class MyPermissionPhoto{

  init() async {
    PermissionStatus status = await Permission.photos.status;
    return checkPermission(status);
  }

  Future<PermissionStatus>checkPermission(PermissionStatus status){
    switch(status){
      case PermissionStatus.permanentlyDenied : return Future.error("Always denied");
      case PermissionStatus.denied : return Permission.photos.request().then((value) => checkPermission(value));
      case PermissionStatus.provisional: return Permission.photos.request().then((value) => checkPermission(value));
      case PermissionStatus.limited : return Permission.photos.request().then((value) => checkPermission(value));
      case PermissionStatus.restricted : return Permission.photos.request().then((value) => checkPermission(value));
      case PermissionStatus.granted : return Permission.photos.request().then((value) => checkPermission(value));
    }
  }


}