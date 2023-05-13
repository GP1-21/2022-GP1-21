import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huna_ksa/Screens/city_Screen.dart';
import 'package:huna_ksa/Screens/favorites_Screen.dart';
import 'package:huna_ksa/Screens/map.dart';
import 'package:huna_ksa/Screens/placeDetail_Screen.dart';
import 'package:huna_ksa/Screens/profile_Screen.dart';
import 'package:huna_ksa/Screens/search_Screen.dart';
import 'package:huna_ksa/Widgets/place_Card.dart';
import 'package:huna_ksa/Components/session.dart' as session;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Components/constants.dart';
import '../components/common_Functions.dart';
import 'home_Screen.dart';

final _firestore = FirebaseFirestore.instance; // connection to firebase


enum _SelectedTab {
  Home,
  Search,
  Map,
  Favourites,
  Cities,
  More,
}

class ViewMoreScreenVersionOne extends StatefulWidget {
  final String categoryName;

  const ViewMoreScreenVersionOne({super.key, required this.categoryName});
  @override
  State<ViewMoreScreenVersionOne> createState() => _ViewMoreScreenVersionOneState();
}

class _ViewMoreScreenVersionOneState extends State<ViewMoreScreenVersionOne> {
  bool showSpinner = false;

  var _selectedTab = _SelectedTab.Home; // categories of places shown in the drawer (slide menu at the top of the page)
  List categories = [
    'Recreational Sites',
    'Historical Sites',
    'Malls',
    "Water Resorts",
    "Restaurants & Cafes",
    "Beach",
    "Spa",
    "Parks"
  ];


  List<String> interests = [];
  final _auth = FirebaseAuth.instance;
  List<Widget> children = [];
  @override
  void initState() {
    // TODO: implement initState
    children = <Widget>[

      const Scaffold( // menu at the bottom of the screen
        body: SearchScreen(),
      ),
      const Scaffold(
        body: MapView(),
      ),
      const Scaffold(
        body: FavoritesScreen(),
      ),
      Scaffold(
        body: CityScreen(),
      ),
      Scaffold(
        backgroundColor:Colors.grey[300],
        body: ViewMoreScreenVersionOne(categoryName: session.category),
      ),
    ];

    super.initState();
  }

  onClick(String name, String image) { // user is shown the place details page when they click on a place in the view more page
    push(
        context,
        PlaceDetailScreen(
          place: name,
          imageURL: image,
        ));
  }

  addToFavourite(String place, String imageurl) async { // when user likes a place it gets added to the favorites page
    await _firestore
        .collection('favouritePlace')
        .doc(session.email + place)
        .set(
      {'email': session.email, 'place': place, 'image': imageurl},
    ).then((value) {
      setState(() {
        if (session.favourite.contains(place)) {
        } else {
          session.favourite.add(place);
        }
      });
    });
  }




  interestClick(String newInterest) { // when an interest category is clicked, only the places that are in this category are shown
    if (interests.contains(newInterest)) {
      setState(() {
        interests.remove(newInterest);
      });
    } else {
      setState(() {
        interests.add(newInterest);
      });
    }
    print(interests);
  }

  void _handleIndexChanged(int i) {
    setState(() {
      _selectedTab = _SelectedTab.values[i];
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body:Scaffold(
        backgroundColor:Colors.grey[300],
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: SingleChildScrollView(
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 30,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        itemCount: categories.length,
                        itemBuilder: (BuildContext listContext, int index) {
                          return categoryCard(
                              categories[index],
                              interests.contains(categories[index])
                                  ? kPrimaryColor
                                  : Colors.white, //interests that are chosen
                              interests.contains(categories[index])
                                  ? kPrimaryColor
                                  : Colors.grey, //interests that are not chosen
                              140,
                              interestClick);
                        }),
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: interests.isEmpty // fetch places of each interest from firebase
                          ? _firestore
                          .collection('placeData')
                          .where("city", isEqualTo: session.city)
                          .where("category", isEqualTo: session.category)
                          .snapshots()
                          : _firestore
                          .collection('placeData')
                          .where("city", isEqualTo: session.city)
                          .where('type', whereIn: interests)
                          .where("category", isEqualTo: session.category)
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
                        final length = placeData!.length;

                        return placeData.isEmpty
                            ? Container()
                            : SizedBox(
                          height: 600,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 120),
                            child: GridView.count(
                              crossAxisCount: 3,
                              crossAxisSpacing: 15,
                              padding: EdgeInsets.all(10),
                              childAspectRatio: 6.5 / 9.0,
                              children:
                              List<Widget>.generate(length, (index) {
                                return GridTile(
                                  child: PlaceCard( // design of the places shown
                                      imagePath: placeData
                                          .elementAt(index)
                                          .get("images"),
                                      placeName: placeData
                                          ?.elementAt(index)
                                          .get("name"),
                                      likeClick: addToFavourite,
                                      imageClick: onClick),
                                );
                              }),
                            ),
                          ),
                        );
                      }),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          ),
        ),
      ),

    );
  }
}
