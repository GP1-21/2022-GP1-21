import 'package:flutter/material.dart';
import 'package:huna_ksa/Widgets/site_Card.dart';
import 'package:huna_ksa/Components/session.dart' as session;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Components/constants.dart';


final _firestore = FirebaseFirestore.instance;

class HomeScreen extends StatefulWidget {


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showSpinner = false;
  List<String> interests=[];
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body:Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              height: MediaQuery.of(context).size.height*.30,
              width: MediaQuery.of(context).size.width,
              child: SizedBox(
                  child: Image(image:AssetImage(session.cityImage[session.city]), fit: BoxFit.cover,)),
            ),
            Positioned(
              top:MediaQuery.of(context).size.height*.20,
              child: Container(
                height:MediaQuery.of(context).size.height*.65,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40)
                ),
child: Padding(
  padding: const EdgeInsets.symmetric(vertical: 30),
  child:   Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("General Sites",style: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                    //Text("show more >>",style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white70,
                      ),
                      onPressed: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('show more', style: TextStyle(color: Colors.black),),
                          Icon( // <-- Icon
                            Icons.keyboard_double_arrow_right,
                            color: Colors.black,
                            size: 20.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SiteCard(imagePath: "images/jeddahCor.jpg", cityName: "  Corniche"),
                    SiteCard(imagePath: "images/WadiHanifa.jpg", cityName: "Wadi Hanifa"),
                    SiteCard(imagePath: "images/highCity.jpg", cityName: "  High City")
                          ]),
            ],
          ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Divider(
          thickness: 3,
        ),
      ),
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20,right: 20),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("Woman Sites",style: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
               // Text("show more >>",style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white70,
                  ),
                  onPressed: () {},
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('show more', style: TextStyle(color: Colors.black),),
                      Icon( // <-- Icon
                        Icons.keyboard_double_arrow_right,
                        color: Colors.black,
                        size: 20.0,
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),

          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SiteCard(imagePath: "images/bounce.jpeg", cityName: "    Bounce"),
                SiteCard(imagePath: "images/Kore_Kobar.jpg", cityName: "      Kore"),
                SiteCard(imagePath: "images/nirvana.jpeg", cityName: "   Nirvana")

              ]),
        ],
      ),
    ],
  ),
),
            )
            ),
          ],
        ),
      ),
    );
  }
}
