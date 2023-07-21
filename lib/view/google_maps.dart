import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../controller/firestore_helper.dart';
import '../globale.dart';
import '../controller/conversation.dart';
import '../model/user_data.dart';

class GoogleMaps extends StatefulWidget {
  dynamic location;

  GoogleMaps({super.key, required this.location});

  @override
  State<GoogleMaps> createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  Set<Marker> _markers = {};
  List<dynamic> locations = [];
  Completer<GoogleMapController> completer = Completer();
  late CameraPosition camera;
  List<QueryDocumentSnapshot> userList = [];
  String userId = userData.id;
  String myPositionIconPath = "assets/position.png";

  Future<void> getUsersData() async {
    QuerySnapshot snapshot = await FirestoreHelper().cloudUsers.get();

    var newMarkers = Set<Marker>();

    for (var user in snapshot.docs) {
      var dataMap = user.data();

      if (dataMap is Map<String, dynamic>) {
        UserData data = UserData.fromMap(dataMap);

        var position = data.POSITION;
        var avatarURL = data.AVATAR ?? defaultImage;
        BitmapDescriptor markerIcon;

        if (userId == user.id) {
          markerIcon = await getMarkerIcon(avatarURL, "asset");
        } else {
          markerIcon = await getMarkerIcon(avatarURL, "url");
        }

        newMarkers.add(
          Marker(
            markerId: MarkerId(user.id),
            position: LatLng(position.latitude, position.longitude),
            icon: markerIcon,
            onTap: () async {
              if (user.id != userData.id) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Conversation(otherUser: data, otherUserId: user.id)),
                );
              }
            },
          ),
        );
      }

      setState(() {
        userList = snapshot.docs;
        _markers = newMarkers;
      });
    }
  }

  Future<Uint8List> getResizedImageByteData(String url,
      {int targetWidth = 100, int targetHeight = 100}) async {
    var networkImage = NetworkImage(url);
    var configuration = ImageConfiguration();

    ImageStream stream = networkImage.resolve(configuration);
    Completer<ImageInfo> completer = Completer();

    late ImageStreamListener listener;
    listener = ImageStreamListener((ImageInfo info, bool synchronousCall) {
      if (!completer.isCompleted) {
        completer.complete(info);
      }
      stream.removeListener(listener);
    });

    stream.addListener(listener);
    ImageInfo image = await completer.future;

    ByteData? byteData =
        await image.image.toByteData(format: ImageByteFormat.png);
    var resizedImageData = await FlutterImageCompress.compressWithList(
      byteData!.buffer.asUint8List(),
      minWidth: targetWidth,
      minHeight: targetHeight,
    );

    return resizedImageData;
  }

  Future<Uint8List> getResizedImageByteDataFromAsset(
      {int targetWidth = 110, int targetHeight = 110}) async {
    final byteData = await rootBundle.load(myPositionIconPath);
    final uint8list = byteData.buffer.asUint8List();

    var resizedImageData = await FlutterImageCompress.compressWithList(
      uint8list,
      minWidth: targetWidth,
      minHeight: targetHeight,
    );

    return resizedImageData;
  }

  Future<BitmapDescriptor> getMarkerIcon(String url, String typeOfImage) async {
    Completer<BitmapDescriptor> markerIcon = Completer();

    Uint8List resizedImageData;
    if (typeOfImage == "asset") {
      resizedImageData = await getResizedImageByteDataFromAsset();
    } else {
      resizedImageData = await getResizedImageByteData(url);
    }

    BitmapDescriptor bitmapDescriptor =
        BitmapDescriptor.fromBytes(resizedImageData);
    markerIcon.complete(bitmapDescriptor);

    return await markerIcon.future;
  }

  void initState() {
    super.initState();

    camera = CameraPosition(
        target: LatLng(widget.location.latitude, widget.location.longitude),
        zoom: 14);

    getUsersData();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return GoogleMap(
          initialCameraPosition: camera,
          myLocationButtonEnabled: true,
          mapToolbarEnabled: true,
          markers: _markers,
          onMapCreated: (control) async {
            String newStyle = await DefaultAssetBundle.of(context)
                .loadString('lib/mapStyle.json');
            control.setMapStyle(newStyle);
            completer.complete(control);
          },
        );
      },
    );
  }
}
