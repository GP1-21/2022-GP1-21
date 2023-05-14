import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:huna_ksa/Screens/city_Screen.dart';
import 'package:huna_ksa/Screens/favorites_Screen.dart';
import 'package:huna_ksa/Screens/map.dart';
import 'package:huna_ksa/Screens/profile_Screen.dart';
import 'package:huna_ksa/Screens/registration_screen.dart';
import 'package:huna_ksa/Screens/search_Screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:huna_ksa/Components/common_Functions.dart';
import 'package:huna_ksa/Components/session.dart' as session;
import 'package:huna_ksa/Screens/viewMore_Screen.dart';
import 'package:huna_ksa/Screens/view_more_v1.dart';
import '../Components/constants.dart';
import 'home_Screen.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';

//https://medium.com/enappd/connecting-cloud-firestore-database-to-flutter-voting-app-2da5d8631662
final _firestore = FirebaseFirestore.instance; //firebase connection

//https://api.flutter.dev/flutter/widgets/StatefulWidget/createState.html
class MainScreen extends StatefulWidget {
  MainScreen({this.title = ""});

  final title;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

enum _SelectedTab {
  Home,
  Search,
  Map,
  Favourites,
  Cities,
  More,
}

class _MainScreenState extends State<MainScreen> {
  final _auth = FirebaseAuth.instance;
  var _selectedTab = _SelectedTab.Home;
  static final List<Widget> _children = <Widget>[  // create static bar at the bottom of the main page
    Scaffold(
      body: HomeScreen(),
    ),
    Scaffold(
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
      body: ViewMoreScreenVersionOne(categoryName: '',),
    ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    checkPage();
    super.initState();
  }

  checkPage() {
    if (widget.title != "") {
      setState(() {
        _selectedTab = _SelectedTab.values[4];
      });
    }
  }

  void _handleIndexChanged(int i) {
    setState(() {
      _selectedTab = _SelectedTab.values[i];
    });
  }

  String getTitle() {
    String title = "";
    if (_selectedTab.name == "Home") {
      title = session.city;
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
      appBar: AppBar(
        leading: _selectedTab == _SelectedTab.More
            ? GestureDetector(
                onTap: () {
                  pushAndRemove(context, MainScreen());
                },
                child: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: kPrimaryColor,
                  size: 30,
                ))
            : Container(),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 10.0, left: 10),
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
        iconTheme: IconThemeData(color: kPrimaryColor),
        backgroundColor: kBackgroundColor,
        centerTitle: true,
        title: Text(
          getTitle(),
          style: TextStyle(
              color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
        ),
        
      ),
      
      bottomNavigationBar: DotNavigationBar(
        marginR: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
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
      body: _children.elementAt(_selectedTab.index),
      backgroundColor: kBackgroundColor,
    );
  }
}
