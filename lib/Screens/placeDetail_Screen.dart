import 'package:flutter/material.dart';
import 'package:huna_ksa/Components/common_Functions.dart';
import 'package:huna_ksa/Screens/main_Screen.dart';
import 'package:huna_ksa/Screens/profile_Screen.dart';
import 'package:huna_ksa/Widgets/rounded_Button.dart';
import 'package:huna_ksa/Widgets/place_Card.dart';
import 'package:huna_ksa/Components/session.dart' as session;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Components/constants.dart';
import 'package:maps_launcher/maps_launcher.dart';


final _firestore = FirebaseFirestore.instance;

class PlaceDetailScreen extends StatefulWidget {
PlaceDetailScreen({required this.place,required this.imageURL});
final place,imageURL;


  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  bool showSpinner = false;//var cards=[categoryCard(text, color, borderColor, width)];
  final _auth = FirebaseAuth.instance;
  int index=0;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }
  //comments section
  addComment(String comment) async {
    await _firestore
        .collection('userComments')
        .doc(session.username+widget.place+comment)
        .set(
      {
        "id":session.username+widget.place+comment,
        'username': session.username,
        'place': widget.place,
        'comment':comment
      },
    ).then((value) {

    });
  }
  // reported comment section
  report(String id,String comment) async {

    showAlertDialog(context,() async {
      await _firestore
          .collection('reportedComments')
          .doc(id)
          .set(
        {
          "id":id,
          'username': session.username,
          'place': widget.place,
          'comment':comment
        },
      ).then((value) {
        Navigator.pop(context);
      });
    }, "Report", "Do you want to report this comment?");


  }

  //add to favorite page
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
      setState(() {
        if(session.favourite.contains(place)){

        }else{
          session.favourite.add(place);
        }      });
    });
  }
  onClick(String name,String image){
    push(context, PlaceDetailScreen(place: name, imageURL: image,));
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:AppBar(
        title: Text(widget.place,style: TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.bold),),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading:GestureDetector(
            onTap:(){
              Navigator.pop(context);                },
            child: Icon(Icons.arrow_back_ios_new_outlined,color: kPrimaryColor,size: 30,)
        ),
        actions: [
          GestureDetector(
            onTap:(){
              addToFavourite(widget.place, widget.imageURL);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  width: 40,
                  height: 28,

                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100)
                  ),
                  child: Center(child: ImageIcon(AssetImage(session.favourite.contains(widget.place)?'images/redheart.png':'images/heart.png'),size: 30,color: session.favourite.contains(widget.place)?Colors.red:Colors.black,))),
            ),
          ),
        ],
        centerTitle: true,
      ),
      backgroundColor: kBackgroundColor,
      body:SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('placeData')
                .where("name",isEqualTo: widget.place)
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
              final images = placeData?.elementAt(0).get("images");
              final data=placeData!.elementAt(0);


              int length=images.length;


              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.width*.70,
                    child: Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap:(){
                              if(index>0){
                                setState(() {
                                  --index;
                                });
                              }
                            },
                            child: Icon(Icons.arrow_back_ios_new_outlined,color: Colors.black,size: 30,)
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20), // Image border
                          child: SizedBox.fromSize(
                            size: Size.fromWidth(MediaQuery.of(context).size.width*.70), // Image radius
                            child: Image.network(placeData?.elementAt(0).get("images")[index],fit: BoxFit.fill,)

                          ),
                        ),
                        GestureDetector(
                            onTap:(){
                              if(index<length-1){
                                setState(() {
                                  index++;
                                });
                              }
                            },
                            child: Icon(Icons.arrow_forward_ios_outlined,color: Colors.black,size: 30,)
                        ),

                      ],),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [ImageIcon(AssetImage('images/ticket.png'),size: 35,color: Colors.black,),
                          SizedBox(width: 5,),
                          Text(data.get("free")=="1"?"Free":data.get("price"),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold))],),
                        Column(
                          children: [
                            Row(children: [ImageIcon(AssetImage('images/map.png'),size: 35,color: Colors.black,),
                              SizedBox(width: 5,),
                              Text(data.get("location"),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold))],),
                            SizedBox(height: 5,),

                            GestureDetector(
                                onTap:(){
                              MapsLauncher.launchQuery(data.get("location"));
              },child: Padding(
                padding: const EdgeInsets.only(left: 100.0),
                child: Container(height:24,width:100,child: const Text("get direction",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,decoration: TextDecoration.underline))),
              ))

              ],
                        )



                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(color: kPrimaryColor,borderRadius: BorderRadius.circular(20)),
                      height: 150,
                      width:double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(crossAxisAlignment:CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
                            Text("Place Details:",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                            SizedBox(height: 5,),
                            Text(data.get("description"),style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold)),

                          ],),
                            Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
                              Text("Opening and closing hours:",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                              SizedBox(height: 5,),

                              Text(data.get("time")=="1"?"24 Hours":data.get("from")+" - "+data.get("to"),style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold)),

                            ],)

                        ],),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(thickness: 1,color: Colors.black,),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text("COMMENTS:",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0,vertical: 4),
                    child: Container(
                      height: 245,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: kPrimaryColor.withOpacity(.4),
                          borderRadius: BorderRadius.circular(40)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0,left: 15),
                        child:   Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            smallButton("ADD COMMENT",color: kPrimaryColor, () async
                            {
                                  addCommentAlertDialog(context, addComment, "Add your comment:");
                            },height: 35,fontSize:16,width: 155),
                            SizedBox(
                              height: 200,
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: _firestore.collection('userComments').where("place",isEqualTo: widget.place)
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


                                    return ListView.builder(
                                        itemCount: placeData?.length,
                                        padding: EdgeInsets.all(20),
                                        itemBuilder: (BuildContext context,int index){

                                          return commentCard(placeData?.elementAt(index).get("comment"),placeData?.elementAt(index).get("username"),placeData?.elementAt(index).get("id"),report,context);
                                        }


                                    );
                                  }

                              ),
                            )
                          ],

                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(thickness: 1,color: Colors.black,),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text("RECOMENDED FOR YOU:",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream:_firestore
                          .collection('placeData')
                          .where("city",isEqualTo: session.city)
                          .where('type',whereIn:session.interests)
                          .where("name",isNotEqualTo: widget.place)
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


                        return Container(
                          height: 175,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                          itemCount: placeData?.length,
                          padding: EdgeInsets.all(10),
                          itemBuilder: (BuildContext context,int index){

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 17),
                              child: PlaceCard(imagePath:placeData?.elementAt(index).get("images"),placeName: placeData?.elementAt(index).get("name"),likeClick: addToFavourite,imageClick: onClick),
                            );
                          }
                          ),
                        );
                      }

                  ),

                ],
              );
            }

        ),
      ),
    );
  }
}
