import 'package:flutter/material.dart';
import 'package:huna_ksa/Screens/city_Screen.dart';
import 'package:huna_ksa/Components/session.dart' as session;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../Widgets/interestLine_Card.dart';
import '../Widgets/interest_Card.dart';
import '../Components/common_Functions.dart';
import '../Widgets/rounded_Button.dart';
import '../Components/constants.dart';

//connect to the database in firebase, //https://medium.com/enappd/connecting-cloud-firestore-database-to-flutter-voting-app-2da5d8631662
final _firestore = FirebaseFirestore.instance;

//Create the class of the edit interest page, //https://api.flutter.dev/flutter/widgets/StatefulWidget/createState.html
class EditInterestScreen extends StatefulWidget {
  static const String id = 'interest_screen';

  @override
  State<EditInterestScreen> createState() => _EditInterestScreenState();
}

//https://api.flutter.dev/flutter/widgets/State/initState.html
class _EditInterestScreenState extends State<EditInterestScreen> {
  bool showSpinner = false;
  //List<String> interests=[];
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }
  //a new user Add&Delete the interests and checking if the user still have at least 3 interests
  onRemoveClick(String interest) {
    if (session.interests.length == 3) {
      tost(context, "Please keep at least 3 interests");
    } else {
      if (!session.interests.contains(interest)) {
        tost(context, "$interest Already Removed");
      } else {
        removeInterest(interest);
        tost(context, "$interest Removed Successfully");
      }
    }
  }
  
  onAddClick(String interest) {
    if (session.interests.contains(interest)) {
      tost(context, "$interest Already Added");
    } else {
      addInterest(interest);
      tost(context, "$interest Added Successfully");
    }
  }
  //for already user, add the interest to the user document in the database
  addInterest(String interest) async {
    await _firestore.collection('userData').doc(session.email).update(
      {
        'interest': FieldValue.arrayUnion([interest]),
      },
    ).then((value) {
      setState(() {
        session.interests.add(interest);
      });
    });
  }
  //for already user, delete the interest to the user document in the database
  removeInterest(String interest) async {
    await _firestore.collection('userData').doc(session.email).update(
      {
        'interest': FieldValue.arrayRemove([interest]),
      },
    ).then((value) {
      setState(() {
        session.interests.remove(interest);
      });
    });
  }

  //Create and design the frame of the page + Create the Interests collection in the database, //https://api.flutter.dev/flutter/widgets/StatelessWidget/build.html
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "INTERESTS",
            style: TextStyle(
                color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: kPrimaryColor,
                size: 30,
              )),
          centerTitle: true,
        ),
        backgroundColor: Colors.grey.shade100,
        body: ModalProgressHUD(
            inAsyncCall: showSpinner,
            progressIndicator: CircularProgressIndicator(
              color: kProgressIndicatorColor,
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 10, left: 10, bottom: 20, right: 10),
              child: SingleChildScrollView(
                child: Container(
                  height: 1050,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InterestLineCard(
                          title: "Recreational Sites",
                          color: Color(0xFFDCCEDA),
                          add: onAddClick,
                          delete: onRemoveClick,
                        ),
                        InterestLineCard(
                            title: "Historical Sites",
                            color: Color(0xFFB3BFB7),
                            add: onAddClick,
                            delete: onRemoveClick),
                        InterestLineCard(
                            title: "Malls",
                            color: Color(0xFF7094A4),
                            add: onAddClick,
                            delete: onRemoveClick),
                        InterestLineCard(
                            title: "Water Resorts",
                            color: Color(0xFFD2AFAF),
                            add: onAddClick,
                            delete: onRemoveClick),
                        InterestLineCard(
                            title: "Restaurants & cafes",
                            color: Color(0xFFC88080),
                            add: onAddClick,
                            delete: onRemoveClick),
                        InterestLineCard(
                            title: "Beach",
                            color: Color(0xFFA4CF9F),
                            add: onAddClick,
                            delete: onRemoveClick),
                        InterestLineCard(
                            title: "Spa",
                            color: Color(0xFFC0BC90),
                            add: onAddClick,
                            delete: onRemoveClick),
                        InterestLineCard(
                            title: "Parks",
                            color: Color(0xFF898D86),
                            add: onAddClick,
                            delete: onRemoveClick)
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
