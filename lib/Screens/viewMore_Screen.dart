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

//https://medium.com/enappd/connecting-cloud-firestore-database-to-flutter-voting-app-2da5d8631662
final _firestore = FirebaseFirestore.instance; // connection to firebase


enum _SelectedTab {
  Home,
  Search,
  Map,
  Favourites,
  Cities,
  More,
}

//https://api.flutter.dev/flutter/widgets/StatefulWidget/createState.html
class ViewMoreScreen extends StatefulWidget {
  final String categoryName;

  const ViewMoreScreen({super.key, required this.categoryName});
  @override
  State<ViewMoreScreen> createState() => _ViewMoreScreenState();
}

class _ViewMoreScreenState extends State<ViewMoreScreen> {
  bool showSpinner = false;

  var _selectedTab = _SelectedTab.Home;
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

       Scaffold(
        body: HomeScreen(),
      ),
      const Scaffold(
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
        body: ViewMoreScreen(categoryName: session.category),
      ),
    ];

    super.initState();
  }

  onClick(String name, String image) {
    push(
        context,
        PlaceDetailScreen(
          place: name,
          imageURL: image,
        ));
  }

  addToFavourite(String place, String imageurl) async { // when user likes a place it gets added to favorites page
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




  interestClick(String newInterest) {
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

  String getTitle() { 
    String title = "";
    if (_selectedTab.name == "Home") {
      title = widget.categoryName.toString() + " Sites";
    } else if (_selectedTab.name == "More") {
      title = session.category + " Sites";
    } else {
      title = _selectedTab.name;
    }
    return title;
  }
  
  //https://api.flutter.dev/flutter/widgets/StatelessWidget/build.html
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      // appBar:,
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios_new_outlined,
              color: kPrimaryColor,
              size: 30,
            ))
        ,
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 10.0, left: 10),
              child: GestureDetector(
                onTap: () {
                  push(context, ProfileScreen());
                },
                child: const ImageIcon(
                  AssetImage('images/profile.png'),
                  size: 30,
                  color: kPrimaryColor,
                ),
              )),
        ],
        iconTheme: const IconThemeData(color: kPrimaryColor),
        backgroundColor: kBackgroundColor,
        centerTitle: true,
        title:  Text(
          getTitle(),
          style: TextStyle(
              color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
        ),

      ),
      bottomNavigationBar: DotNavigationBar(
        marginR: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        currentIndex: _SelectedTab.values.indexOf(_selectedTab),
        unselectedItemColor: Colors.white,
        dotIndicatorColor: Colors.transparent,
        backgroundColor: kPrimaryColor,
        selectedItemColor: Colors.black,

        onTap: _handleIndexChanged,
        items: [
          DotNavigationBarItem(
            icon: ImageIcon(
              AssetImage('images/home.png'),
              size: 27,
            ),
          ),
          DotNavigationBarItem(
            icon: ImageIcon(
              AssetImage('images/search.png'),
              size: 30,
            ),
          ),
          DotNavigationBarItem(
            icon: ImageIcon(
              AssetImage('images/city.png'),
              size: 27,
            ),
          ),
          DotNavigationBarItem(
            icon: ImageIcon(
              AssetImage('images/favourite.png'),
              size: 27,
            ),
          ),
          DotNavigationBarItem(
            icon: Icon(CupertinoIcons.globe),
          ),
        ],
      ),
      body:_selectedTab.index == 0? Scaffold(
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
                                  : Colors.white,
                              interests.contains(categories[index])
                                  ? kPrimaryColor
                                  : Colors.grey,
                              140,
                              interestClick);
                        }),
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: interests.isEmpty
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
                                  child: PlaceCard(
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
      ): children.elementAt(_selectedTab.index),

    );
  }
}
