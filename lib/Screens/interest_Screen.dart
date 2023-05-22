import 'package:flutter/material.dart';
import 'package:huna_ksa/Screens/city_Screen.dart';
import 'package:huna_ksa/Components/session.dart' as session;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../Widgets/interest_Card.dart';
import '../Components/common_Functions.dart';
import '../Widgets/rounded_Button.dart';
import '../Components/constants.dart';

//https://medium.com/enappd/connecting-cloud-firestore-database-to-flutter-voting-app-2da5d8631662
//connect to the database in firebase
//https://firebase.flutter.dev/docs/firestore/usage/
final _firestore = FirebaseFirestore.instance;

//https://api.flutter.dev/flutter/widgets/StatefulWidget/createState.html
//StatefulWidget describes part of the user interface
class InterestScreen extends StatefulWidget {
  static const String id = 'interest_screen';
  InterestScreen();

  //state read synchronously when the widget is built, might change during the lifetime of the widget
  @override
  State<InterestScreen> createState() => _InterestScreenState();
}

class _InterestScreenState extends State<InterestScreen> {
  bool showSpinner = false;
  List<String> interests=[];
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }
  createUser() async {
    setState(() {
      showSpinner=true;
    });
    try {

        //save the user interest to the database
        await _firestore
            .collection('userData')
            .doc(session.email)
            .update(
          {

            'interest':interests,
          },
        ).then((value) {
          setState(() {

            session.interests=interests;
            showSpinner = false;
          });
          push(context, CityScreen());
        });


    } catch (e) {
      print(e);
      setState(() {

        showSpinner = false;
      });
    }
  }
  onClick(String place){
    if(interests.contains(place)){
      setState(() {
        interests.remove(place);
      });

      //tost(context, "$place Removed successfully");
    }
    else{
      setState(() {
        interests.add(place);
      });

      //tost(context, "$place Added successfully");
      }
  }
  
  //https://api.flutter.dev/flutter/widgets/StatelessWidget/build.html
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // leading: GestureDetector(
        //     onTap:(){
        //       Navigator.pop(context);                },
        //     child: Icon(Icons.arrow_back_ios_new_outlined,color: kPrimaryColor,size: 30,)
        // ),
      ),
      backgroundColor: Colors.grey.shade100,
      body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          progressIndicator: CircularProgressIndicator(
            color: kProgressIndicatorColor,),
          child: Padding(
            padding: const EdgeInsets.only(top:10,left: 10,bottom: 20,right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(alignment: Alignment.bottomLeft,
                  children: [
                    Positioned(
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                          color: Colors.grey.shade200,
                        ),
                        height: MediaQuery.of(context).size.height*.75,
                        width: MediaQuery.of(context).size.width*.95,
                      ),
                    ),
                  Positioned(
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                        color: Colors.grey.shade300,
                      ),
                      height: MediaQuery.of(context).size.height*.72,
                      width: MediaQuery.of(context).size.width*.90,
                    ),
                  ),

                  //https://api.flutter.dev/flutter/widgets/Positioned-class.html
                  //list of 8 interests
                  Positioned(
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                        color: Colors.grey.shade400,
                      ),
                      height: MediaQuery.of(context).size.height*.70,
                      width: MediaQuery.of(context).size.width*.85,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0,left: 15,right: 15,bottom: 60),
                        child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("What are your interests?",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),

                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                    onTap:(){onClick("Recreational Sites");},
                                    child: InterestCard(title: "Recreational Sites", color: Color(0xFFDCCEDA),borderColor:interests.contains("Recreational Sites")?Colors.green:Colors.transparent),),
                                GestureDetector(onTap:(){onClick("Historical Sites");},
                                    child: InterestCard(title: "Historical Sites", color: Color(0xFFB3BFB7),borderColor:interests.contains("Historical Sites")?Colors.green:Colors.transparent)),
                                GestureDetector(onTap: (){
                                  onClick("Malls");
                                },
                                    child: InterestCard(title: "Malls", color: Color(0xFF7094A4),borderColor:interests.contains("Malls")?Colors.green:Colors.transparent))

                              ],
                            ),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(onTap:(){onClick("Water Resorts");},
                                    child: InterestCard(title: "Water Resorts", color: Color(0xFFD2AFAF),borderColor:interests.contains("Water Resorts")?Colors.green:Colors.transparent,)),
                                GestureDetector(onTap:(){onClick("Restaurants & cafes");},
                                    child: InterestCard(title: "Restaurants & cafes", color: Color(0xFFC88080),borderColor:interests.contains("Restaurants & cafes")?Colors.green:Colors.transparent)),
                                GestureDetector(onTap:(){onClick("Beach");},
                                    child: InterestCard(title: "Beach", color: Color(0xFFA4CF9F),borderColor:interests.contains("Beach")?Colors.green:Colors.transparent))

                              ],
                            ),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(onTap:(){onClick("Spa");},child: InterestCard(title: "Spa", color: Color(0xFFC0BC90),borderColor:interests.contains("Spa")?Colors.green:Colors.transparent )),
                                GestureDetector(onTap:(){onClick("Parks");},child: InterestCard(title: "Parks", color: Color(0xFF898D86),borderColor:interests.contains("Parks")?Colors.green:Colors.transparent))

                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],),

                RoundedButton(title: 'Next',
                    textColor:Colors.white,
                    color: kPinkColor,
                    onPress: () async
  {
    //eror message if the user didn't add 3 or more interests
if(interests.length>=3){
  createUser();
}else{
  tost(context, "Please add at least three interests");
}
                },height: 50),
              ],
            ),
          )

      ),
    );
  }
}
