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
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  //foucs of the map
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  double lat = 0.0;
  double lng = 0.0;
  Set<Marker> _marker = {};

  bool showData = false;

  @override
  void initState() {

    LocationHelper().determinePosition().then((value) {
      lat = value.latitude;
      lng = value.longitude;
      setState(() {});

      PlacesServices().getPlaces().then((value) { //function for provide list
        value.map((e) {
          _marker.add(Marker( //markers of each place in the map
              markerId: MarkerId(e.name.toString()),
              infoWindow: InfoWindow(title: e.name.toString()),
              position: LatLng(
                double.parse(e.lat.toString()),
                double.parse(e.lng.toString()),
              )));
        }).toList();
        showData = true;
        setState(() {});
      });
    });

    super.initState();
  }

  @override

}
