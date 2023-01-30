import 'package:flutter/material.dart';
import 'package:huna_ksa/Screens/placeDetail_Screen.dart';
import 'package:huna_ksa/Widgets/place_Card.dart';
import 'package:huna_ksa/Components/session.dart' as session;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Components/constants.dart';
import '../components/common_Functions.dart';


final _firestore = FirebaseFirestore.instance;

class ViewMoreScreen extends StatefulWidget {



  @override
  State<ViewMoreScreen> createState() => _ViewMoreScreenState();
}

class _ViewMoreScreenState extends State<ViewMoreScreen> {
  bool showSpinner = false;
  List categories=[
    'Recreational Sites',
    'Historical Sites',
    'Malls',
    "Water Resorts",
    "Restaurants & Cafes",
    "Beach",
    "Spa",
    "Parks"
  ];
  //var cards=[categoryCard(text, color, borderColor, width)];
  List<String> interests=[];
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }
  onClick(String name,String image){
    push(context, PlaceDetailScreen(place: name, imageURL: image,));
  }
  addToFavourite(String place,String imageurl) async {
    await _firestore
        .collection('favouritePlace')
        .doc(session.email+place)
        .set(
      {
        'email': session.email,
        'place': place,
        'image':imageurl
      },
    ).then((value) {

    });
  }
  interestClick(String newInterest){
    if(interests.contains(newInterest)){
      setState(() {
        interests.remove(newInterest);
      });
    }else{
      setState(() {
        interests.add(newInterest);
      });
    }
    print(interests);
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: kBackgroundColor,
      body:Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child:   SingleChildScrollView(
          child: SizedBox(
            height: 680,
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 30,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,

                    padding: const EdgeInsets.only(left: 16, right:16),
                      itemCount: categories.length,
                      itemBuilder: (BuildContext listContext, int index) {

                        return categoryCard(categories[index], interests.contains(categories[index])?kPrimaryColor:Colors.white, interests.contains(categories[index])?kPrimaryColor:Colors.grey, 140,interestClick);


                      }


                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: interests.isEmpty?_firestore.collection('placeData')
                        .where("city",isEqualTo: session.city).snapshots():_firestore.collection('placeData')

                        .where("city",isEqualTo: session.city).where('type',whereIn: interests)
                    //.orderBy("name", descending: false)
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
                      final length= placeData!.length;


                      return
                        placeData!.isEmpty?Container():
                        Container(
                          height: 600,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 120),
                            child: GridView.count(
                              crossAxisCount: 3,
                              crossAxisSpacing: 15,
                              padding: EdgeInsets.all(20.0),
                              childAspectRatio: 6.5 / 9.0,

                              children: List<Widget>.generate(length, (index) {
                                return GridTile(
                                  child:PlaceCard(imagePath:placeData.elementAt(index).get("images"),placeName: placeData?.elementAt(index).get("name"),likeClick: addToFavourite,imageClick: onClick),
                                );
                              }),
                            ),
                          ),
                        );
                    }

                ),


                SizedBox(height: 50,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
