import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:huna_ksa/Screens/city_Screen.dart';
import 'package:huna_ksa/Screens/favorites_Screen.dart';
import 'package:huna_ksa/Screens/profile_Screen.dart';
import 'package:huna_ksa/Screens/registration_screen.dart';
import 'package:huna_ksa/Screens/search_Screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:huna_ksa/Components/common_Functions.dart';
import 'package:huna_ksa/Components/session.dart' as session;
import '../Components/constants.dart';
import 'home_Screen.dart';
final _firestore=FirebaseFirestore.instance;
class MainScreen extends StatefulWidget {


  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _auth=FirebaseAuth.instance;
  late int _selectedIndex=0;
  String title="";
  static final List<Widget> _children = <Widget>[
    Scaffold(

      body:HomeScreen(),
    ),
    const Scaffold(

      body: FavoritesScreen(),
    ),
    Scaffold(

      body: CityScreen(),
    ),
    Scaffold(

      body: SearchScreen(),
    ),
    Scaffold(

      body: ProfileScreen(),
    ),

  ];

  void logout()async {
//print(" logout");

    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(pageBuilder: (BuildContext context, Animation animation,
            Animation secondaryAnimation) {
          return RegistrationScreen();
        }, transitionsBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation, Widget child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        }),
            (Route route) => false);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
String getTitle()
{

  if(_selectedIndex==0){
    title=session.city;
  }else if(_selectedIndex==1){
    title="Favourites";
  }else if(_selectedIndex==2){
    title="Cities";
  }else if(_selectedIndex==3){
    title="Search";
  }else if(_selectedIndex==4){
    title="Profile";
  }
  return title;
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
         actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 10.0,left: 10),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex=4;
                    });
                  },
                  child: const ImageIcon(AssetImage('images/profile.png'),size: 26,color: kPrimaryColor,),

    )
            ),

          ],
        iconTheme: IconThemeData(color: kPrimaryColor),
        backgroundColor: kBackgroundColor,
        centerTitle: true,
        title: Text(getTitle(),style: (TextStyle(color: Colors.black)),), systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      drawer: Drawer(
        backgroundColor: kPrimaryColor,
        width: 200,
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: Padding(
          padding: const EdgeInsets.only(left: 5,top: 40,bottom: 50),
          child: Column(
            // Important: Remove any padding from the ListView.
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 80,left: 10),
                    child: GestureDetector(onTap:(){
                      Navigator.pop(context);
                    },
                        child: const ImageIcon(AssetImage('images/close.png'),size: 20,)),
                  ),
                  ListTile(
                    title: const Text('Home',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                    leading: const ImageIcon(AssetImage('images/home.png'),size: 27,),
                    onTap: () {
                      // Update the state of the app.
                      Navigator.pop(context);
                      setState(() {
                        _selectedIndex=0;
                      });
                      // ...
                    },
                  ),
                  ListTile(
                    title: const Text('Favorites',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                    leading: const ImageIcon(AssetImage('images/heart.png'),size: 27,),
                    onTap: () {
                      // Update the state of the app.
                      Navigator.pop(context);

                      setState(() {
                        _selectedIndex=1;
                      });
                      // ...
                    },
                  ),
                  ListTile(
                    title: const Text('Cities',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                    leading: const ImageIcon(AssetImage('images/city.png'),size: 27,),
                    onTap: () {
                      // Update the state of the app.
                      Navigator.pop(context);
                      setState(() {
                        _selectedIndex=2;
                      });
                      // ...
                    },
                  ),
                  ListTile(
                    title: const Text('Search',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                    leading: const ImageIcon(AssetImage('images/search.png'),size: 27,),
                    onTap: () {
                      // Update the state of the app.
                      Navigator.pop(context);
                      setState(() {
                        _selectedIndex=3;
                      });
                      // ...
                    },
                  ),
                ],
              ),
              ListTile(
                title: const Text('Logout',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),),
                leading: const ImageIcon(AssetImage('images/logout.png'),size: 30,),
                onTap: () {
                  // Update the state of the app.
                  showAlertDialog(context, logout, "Logout", "Do you want to logout?");
                  // ...
                },
              ),
            ],
          ),
        ),
      ),
      body:_children.elementAt(_selectedIndex),
      backgroundColor: kBackgroundColor,
    );
  }
}
