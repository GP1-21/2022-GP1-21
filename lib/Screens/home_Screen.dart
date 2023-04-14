import 'package:flutter/material.dart';
import 'package:huna_ksa/Components/common_Functions.dart';
import 'package:huna_ksa/Screens/main_Screen.dart';
import 'package:huna_ksa/Screens/placeDetail_Screen.dart';
import 'package:huna_ksa/Screens/viewMore_Screen.dart';
import 'package:huna_ksa/Widgets/place_Card.dart';
import 'package:huna_ksa/Components/session.dart' as session;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Components/constants.dart';

//connect to the database in firebase
final _firestore = FirebaseFirestore.instance;

//StatefulWidget describes part of the user interface
class HomeScreen extends StatefulWidget {

  //state read synchronously when the widget is built, might change during the lifetime of the widget
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

  //transfer to place details page if the user click on the plase
  onClick(String name,String image){
    push(context, PlaceDetailScreen(place: name, imageURL: image,));
  }

  //add the place in favourite if the user click on the like button
  addToFavourite(String place,String imageurl) async {
    //bringing the data from firebase
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
      setState(() {
        if(session.favourite.contains(place)){

        }else{
          session.favourite.add(place);
        }});
    });
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
                      color: kBackgroundColor,
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child:   SingleChildScrollView(
                      child: SizedBox(
                        height: 723,
                        child: Column(mainAxisAlignment: MainAxisAlignment.start,
                          children: [

                            //general category part
                            StreamBuilder<QuerySnapshot>(
                              //take the data from firebase
                                stream: _firestore.collection('placeData')
                                    .where("city",isEqualTo: session.city).where('category',isEqualTo: "General")
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


                                  return placeData.isEmpty?Container():Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 20,right: 20),
                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          //show more button that will open the list of places page
                                          children: [
                                            const Text("General",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                                            smallButton(width: 96,"show more >", (){
                                              session.category="General";
                                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewMoreScreen(categoryName: session.category,)));
                                            }),

                                          ],
                                        ),
                                      ),
                                      //3 places for each category
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              PlaceCard(imagePath:placeData.elementAt(0).get("images"),placeName: placeData.elementAt(0).get("name"),likeClick: addToFavourite,imageClick: onClick),
                                              length >1?PlaceCard(imagePath:placeData.elementAt(1).get("images"),placeName: placeData.elementAt(1).get("name"),likeClick: addToFavourite,imageClick: onClick):Container(),
                                              length >2?PlaceCard(imagePath:placeData.elementAt(2).get("images"),placeName: placeData.elementAt(2).get("name"),likeClick: addToFavourite,imageClick: onClick):Container(),

                                            ]),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 30),
                                        child: Divider(
                                          thickness: 3,
                                        ),
                                      ),

                                    ],
                                  );
                                }

                            ),
                            //woman category part
                            StreamBuilder<QuerySnapshot>(
                              //take the data from firebase
                                stream: _firestore.collection('placeData')
                                    .where("city",isEqualTo: session.city).where('category',isEqualTo: "Woman")
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


                                  return placeData!.isEmpty?Container():Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          //show more button that will open the list of places page
                                          children: [
                                            const Text("Woman",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                                            smallButton(width: 96,"show more >", (){
                                              session.category="Woman";
                                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewMoreScreen(categoryName: session.category)));

                                            }),


                                          ],
                                        ),
                                      ),
                                      //3 places for each category
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              PlaceCard(imagePath:placeData.elementAt(0).get("images"),placeName: placeData.elementAt(0).get("name"),likeClick: addToFavourite,imageClick: onClick,),
                                              length >1?PlaceCard(imagePath:placeData.elementAt(1).get("images"),placeName: placeData.elementAt(1).get("name"),likeClick: addToFavourite,imageClick: onClick):Container(),
                                              length >2?PlaceCard(imagePath:placeData.elementAt(2).get("images"),placeName: placeData.elementAt(2).get("name"),likeClick: addToFavourite,imageClick: onClick):Container(),

                                            ]),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 30),
                                        child: Divider(
                                          thickness: 3,
                                        ),
                                      ),

                                    ],
                                  );
                                }

                            ),

                            //kids category part
                            StreamBuilder<QuerySnapshot>(
                              //take the data from firebase
                                stream: _firestore.collection('placeData')
                                    .where("city",isEqualTo: session.city).where('category',isEqualTo: "Kids")
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


                                  return placeData!.isEmpty?Container():Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            //show more button that will open the list of places page
                                            Text("Kids",style: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                                            smallButton(width: 96,"show more >", (){
                                              session.category="Kids";
                                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewMoreScreen(categoryName: session.category)));

                                            }),

                                          ],
                                        ),
                                      ),
                                      //3 places for each category
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            //show more button that will open the list of places page
                                            children: [
                                              PlaceCard(imagePath:placeData.elementAt(0).get("images"),placeName: placeData.elementAt(0).get("name"),likeClick: addToFavourite,imageClick: onClick),
                                              length >1?PlaceCard(imagePath:placeData.elementAt(1).get("images"),placeName: placeData.elementAt(1).get("name"),likeClick: addToFavourite,imageClick: onClick):Container(),
                                              length >2?PlaceCard(imagePath:placeData.elementAt(2).get("images"),placeName: placeData.elementAt(2).get("name"),likeClick: addToFavourite,imageClick: onClick):Container(),

                                            ]),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 30),
                                        child: Divider(
                                          thickness: 3,
                                        ),
                                      ),

                                    ],
                                  );
                                }

                            ),



                          ],
                        ),
                      ),
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
