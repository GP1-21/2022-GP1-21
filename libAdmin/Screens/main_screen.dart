import 'package:flutter/material.dart';
import 'package:huna_ksa_admin/Screens/city_Screen.dart';
import 'package:huna_ksa_admin/Screens/reported_Comment_Screen.dart';
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
bool bell=false;
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
  void initState() {
    // TODO: implement initState
    checkBell();
    super.initState();
  }
  checkBell() async {
    if(await _firestore.collection('reportedComments').snapshots().length==0){
      setState(() {
        bell=false;
      });
    }else{
      setState(() {
        bell=true;
      });

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(onTap: (){
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReportedCommentScreen()
                      ),
                    ).then((value) => setState((){
              }));              // if(bell){
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => ReportedCommentScreen()
              //     ),
              //   ).then((value) => checkBell());
              //
              // }

            },child:StreamBuilder<QuerySnapshot>(
    stream: _firestore.collection('reportedComments').snapshots(),
    builder: (context, snapshot) {
    if (!snapshot.hasData) {
    return const Center(
    child: ImageIcon(AssetImage('images/bell.png'),size: 35,color:kPrimaryColor,),

      );
    }
    final placeData = snapshot.data?.docs;

    return ImageIcon(AssetImage('images/bell.png'),size: 35,color:placeData!.isNotEmpty?kPinkColor:kPrimaryColor);
    }

            ),
            ),
          )
        ],
      ),
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(height: 580,
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
                            borderRadius: BorderRadius.circular(15),
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
                              borderRadius: BorderRadius.circular(15),
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
                              borderRadius: BorderRadius.circular(15),
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
                              borderRadius: BorderRadius.circular(15),
                              color: kPrimaryColor
                          ),
                          child: const Center(child: Text("Edit Place",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5,),
              GestureDetector(
                onTap: (){
                  showAlertDialog(context, logout, "", "Do you want to logout?");
                },
                child: Container(
                  height: 40,
                  width: 120,
                  decoration: BoxDecoration(color: kPinkColor,borderRadius: BorderRadius.circular(25)),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("LOG OUT", style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                      ImageIcon(AssetImage('images/logout.png'),size: 27,color: Colors.black,),

                    ],
                  ),
                ),
              ),


            ],
          ),
        ),
      )
    );
  }
}
