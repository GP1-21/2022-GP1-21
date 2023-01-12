import 'package:flutter/material.dart';
import 'package:huna_ksa_admin/Screens/city_Screen.dart';
import 'package:huna_ksa_admin/Widgets//city_Card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huna_ksa_admin/Components/common_Functions.dart';
import 'package:huna_ksa_admin/Components/constants.dart';
import 'package:huna_ksa_admin/Components/session.dart' as session;
import 'package:huna_ksa_admin/Widgets/rounded_Button.dart';

import 'login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';



final _firestore = FirebaseFirestore.instance;
class MainScreen extends StatefulWidget {

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  void logout()async {

    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(pageBuilder: (BuildContext context, Animation animation,
            Animation secondaryAnimation) {
          return LoginScreen();
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 100,),
            Container(height: 600,
              child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: (){
                      push(context, CityScreen(screenFrom: "delete"));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: kPrimaryColor
                        ),
                        child: const Center(child: Text("Delete Place",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      push(context, CityScreen(screenFrom: "add"));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: kPrimaryColor
                        ),
                        child: const Center(child: Text("Add Place",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      push(context, CityScreen(screenFrom: "comment"));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: kPrimaryColor
                        ),
                        child: const Center(child: Text("Delete Comment",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      push(context, CityScreen(screenFrom: "edit"));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        height: 130,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: kPrimaryColor
                        ),
                        child: const Center(child: Text("Edit Place",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),

            RoundedButton(color: kPinkColor,title: "Logout", onPress: () {
              showAlertDialog(context, logout, "LOG OUT", "Do you want to logout?");
            //logout();
            }, textColor: Colors.black, height: 20)
          ],
        ),
      )
    );
  }
}
