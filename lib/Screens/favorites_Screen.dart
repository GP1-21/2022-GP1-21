import 'package:flutter/material.dart';
import 'package:huna_ksa/Components/constants.dart';
import 'package:huna_ksa/Components/session.dart' as session;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huna_ksa/Screens/placeDetail_Screen.dart';
import 'package:huna_ksa/Widgets/favourite_Card.dart';

import '../Components/common_Functions.dart';
final _firestore = FirebaseFirestore.instance;


class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  deleteFavourite(String place) async {
    showAlertDialog(context, () async {
      await _firestore
          .collection('favouritePlace')
          .doc(session.email+place).delete().then((value) {
        setState(() {
          session.favourite.remove(place);
          print(session.favourite);
        });
Navigator.pop(context);
      });
    }, "Delete", "Are you sure you want to delete place?");


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body:  StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('favouritePlace')
              .where("email",isEqualTo: session.email)
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


            return ListView.builder(
              itemCount: placeData?.length,
                padding: EdgeInsets.all(20),
                itemBuilder: (BuildContext context,int index){

                  return GestureDetector(onTap:() {
                    push(context, PlaceDetailScreen(place: placeData?.elementAt(index).get("place"), imageURL: placeData?.elementAt(index).get(
                        "image")));
                  },
                      child: FavouriteCard(imagePath:placeData?.elementAt(
                    index).get("image"),placeName: placeData?.elementAt(index).get("place"),delete:deleteFavourite,));
                }


            );
          }

      ),

    );
  }
}
