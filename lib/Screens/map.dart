import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:huna_ksa/Components/constants.dart';
import 'package:huna_ksa/Components/session.dart' as session;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huna_ksa/Screens/placeDetail_Screen.dart';
import 'package:huna_ksa/Widgets/favourite_Card.dart';
import 'package:huna_ksa/model/place.dart';
import 'package:huna_ksa/services/places.dart';
import '../Components/common_Functions.dart';
import 'package:provider/provider.dart';
import '../Components/location_helper.dart';

final _firestore = FirebaseFirestore.instance;

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  //producing future object to complete them later with value
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
//Creates a immutable representation of the GoogleMap camera based on lat and lng
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  //latitude and longitude
  double lat = 0.0;
  double lng = 0.0;
  //seting the markers to set on the map
  Set<Marker> _marker = {};
  bool showData = false;

  @override
  void initState() {
    //determining the postion based on value of latitude and longitude
    LocationHelper().determinePosition().then((value) {
      lat = value.latitude;
      lng = value.longitude;
      setState(() {});
      //function for provide list of markers
      PlacesServices().getPlaces().then((value) {
        value.map((e) {
          _marker.add(Marker(
              markerId: MarkerId(e.name.toString()),
              infoWindow: InfoWindow(title: e.name.toString()),
              position: LatLng(
                double.parse(e.lat.toString()),
                double.parse(e.lng.toString()),
              )));
        }).toList(); //puting the markers in list
        showData = true;
        setState(() {});
      });
    });

    super.initState();
  }

  @override
  //style of the map and markers
  Widget build(BuildContext context) {
    return showData != true
        ? Center(
            child: CircularProgressIndicator(),
          )
        : GoogleMap(
            compassEnabled: true,
            mapType: MapType.normal,
            markers: _marker,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
                target: LatLng(lat, lng), zoom: 14.151926040649414),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          );
  }
}
