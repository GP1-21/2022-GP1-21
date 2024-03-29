import 'package:flutter/material.dart';
import 'package:huna_ksa_admin/Screens/delete_Screen.dart';
import 'package:huna_ksa_admin/Screens/edit_Screen.dart';
import 'package:huna_ksa_admin/Widgets//city_Card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huna_ksa_admin/Components/common_Functions.dart';
import 'package:huna_ksa_admin/Components/constants.dart';
import 'package:huna_ksa_admin/Components/session.dart' as session;

import '../Widgets/place_Card.dart';
import 'add_Screen.dart';

//https://medium.com/enappd/connecting-cloud-firestore-database-to-flutter-voting-app-2da5d8631662
final _firestore = FirebaseFirestore.instance;

//https://api.flutter.dev/flutter/widgets/StatefulWidget/createState.html
class SelectPlaceScreen extends StatefulWidget {
  SelectPlaceScreen({required this.city, required this.fromScreen});
  final String city, fromScreen;

  @override
  State<SelectPlaceScreen> createState() => _SelectPlaceScreenState();
}
//Selecting place to Delete or Edit
class _SelectPlaceScreenState extends State<SelectPlaceScreen> {
  
 //https://api.flutter.dev/flutter/widgets/StatelessWidget/build.html 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 40,
            color: kPrimaryColor,
          ),
        ),
      ),
      backgroundColor: kBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Text(
              "SELECT PLACE:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Expanded(
            //returning places from firebase
            child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('placeData')
                    .where("city", isEqualTo: widget.city)
                    .orderBy("name", descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: kProgressIndicatorColor,
                        color: kProgressIndicatorColor,
                      ),
                    );
                  }
                  final placeData = snapshot.data?.docs;

                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 30, left: 16, right: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: kPrimaryColor,
                      ),
                      //Array of places
                      child: ListView.builder(

                          //select a place to edit 
                          itemCount: placeData?.length,
                          itemBuilder: (BuildContext listContext, int index) {
                            return GestureDetector(
                                onTap: () {
                                  if (widget.fromScreen == "edit") {
                                    push(
                                      context,
                                      EditScreen(  //Return the place fields to Editscreen
                                        city: widget.city,
                                        category: placeData
                                            ?.elementAt(index)
                                            .get("category"),
                                        type: placeData
                                            ?.elementAt(index)
                                            .get("type"),
                                        name: placeData
                                            ?.elementAt(index)
                                            .get("name"),
                                        price: placeData
                                            ?.elementAt(index)
                                            .get("price"),
                                        description: placeData
                                            ?.elementAt(index)
                                            .get("description"),
                                        location: placeData
                                            ?.elementAt(index)
                                            .get("location"),
                                        from: placeData
                                            ?.elementAt(index)
                                            .get("from"),
                                        to: placeData
                                            ?.elementAt(index)
                                            .get("to"),
                                        time: placeData
                                                    ?.elementAt(index)
                                                    .get("time") ==
                                                "1"
                                            ? true
                                            : false,
                                        priceCheck: placeData
                                                    ?.elementAt(index)
                                                    .get("free") ==
                                                "1"
                                            ? true
                                            : false,
                                        imageUrls: placeData
                                            ?.elementAt(index)
                                            .get("images"),
                                      ),
                                    );
                                  }
    else if(widget.fromScreen=="comment")
    { //Delete comment page
    push(context, DeleteCommentScreen(place: placeData?.elementAt(index).get("name")));
    }
    },
    child: PlaceCard(placeData?.elementAt(index).get("name"), context));

    }
                    ),
                  ),
                  );
                }
          ),
          ), ],
      ),
    );
  }
}
