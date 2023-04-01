import 'package:huna_ksa/model/place.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class PlacesServices {
  ///Stream All Places
  Future<List<PlaceModel>> getPlaces() async{
    return await FirebaseFirestore.instance.collection('placeData').get().then(
        (event) =>
            event.docs.map((e) => PlaceModel.fromJson(e.data())).toList());
  }
}
