import 'package:flutter/material.dart';
import 'package:huna_ksa/Components/common_Functions.dart';
import 'package:huna_ksa/Components/constants.dart';
import 'package:huna_ksa/Components/session.dart' as session;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huna_ksa/Screens/placeDetail_Screen.dart';

import '../Widgets/search_Card.dart';
final _firestore = FirebaseFirestore.instance;
class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Column(
    children: [

    Center(
    child: Padding(
    padding: const EdgeInsets.only(right: 12,left: 12),
    child: Container(
    height: 60,
    width: MediaQuery.of(context).size.width,
    margin: const EdgeInsets.only(left: 5.0, right: 5.0,top: 10),
    child: TextField(
    onChanged: (value)
    {
    setState(() {
    });
    },
    controller: searchController,
    style: TextStyle(color: Theme.of(context).iconTheme.color),
    decoration: kTextFieldDecoration.copyWith(hintText: "Search", prefixIcon: const Icon(Icons.search,), fillColor: Theme.of(context).canvasColor),
    ),
    ),
    ),
    ),
    Expanded(
    child: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('placeData').where("city",isEqualTo: session.city).orderBy("name", descending: false).snapshots(),
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
            //scrollDirection: Axis.horizontal,

              padding: const EdgeInsets.only(left: 16, right:16),
              itemCount: placeData?.length,
              itemBuilder: (BuildContext listContext, int index) {

    if(placeData?.elementAt(index).get("name").contains(RegExp(searchController.text, caseSensitive: false))) {
      return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: GestureDetector(
            onTap: (){
              push(context, PlaceDetailScreen(place: placeData?.elementAt(index).get("name"), imageURL: placeData?.elementAt(index).get(
                  "images")[0]));
            },
            child: SearchCard(
              imagePath: placeData?.elementAt(index).get(
                  "images"),
              placeName: placeData?.elementAt(index).get("name"),
            ),
          ));
    }
    else{
      return Container();
    }
                }

    );
              }

    )
  ),


    ],
    ),
    );
  }
}
