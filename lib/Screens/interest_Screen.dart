import 'package:flutter/material.dart';
import 'package:huna_ksa/Screens/city_Screen.dart';
import 'package:huna_ksa/Components/session.dart' as session;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../Widgets/interest_Card.dart';
import '../Components/common_Functions.dart';
import '../Widgets/rounded_Button.dart';
import '../Components/constants.dart';


final _firestore = FirebaseFirestore.instance;

class InterestScreen extends StatefulWidget {

  @override
  State<InterestScreen> createState() => _InterestScreenState();
}

class _InterestScreenState extends State<InterestScreen> {
  bool showSpinner = false;
  List<String> interests=[];
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  onClick(String place){
    if(interests.contains(place)){
      tost(context, "$place Already added");
    }
    else{
      interests.add(place);
      tost(context, "$place Added successfully");    }
  }
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
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
                  GestureDetector(
                  onTap:(){Navigator.pop(context);},
                      child: const Align(alignment:Alignment.topRight,child:ImageIcon(AssetImage('images/arrow.png'),size: 40,color: kPrimaryColor,),)),
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
                                      child: InterestCard(title: "Recreational Sites", color: Color(0xFFDCCEDA))),
                                  GestureDetector(onTap:(){onClick("Historical Sites");},
                                      child: InterestCard(title: "Historical Sites", color: Color(0xFFB3BFB7))),
                                  GestureDetector(onTap: (){
                                    onClick("Malls");
                                  },
                                      child: InterestCard(title: "Malls", color: Color(0xFF7094A4)))

                                ],
                              ),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(onTap:(){onClick("Water Resorts");},
                                      child: InterestCard(title: "Water Resorts", color: Color(0xFFD2AFAF))),
                                  GestureDetector(onTap:(){onClick("Walkways");},
                                      child: InterestCard(title: "Walkways", color: Color(0xFFC88080))),
                                  GestureDetector(onTap:(){onClick("Beach");},
                                      child: InterestCard(title: "Beach", color: Color(0xFFA4BF9D)))

                                ],
                              ),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(onTap:(){onClick("Spa");},child: InterestCard(title: "Spa", color: Color(0xFFC0BC90), )),
                                  GestureDetector(onTap:(){onClick("Landmarks");},child: InterestCard(title: "Landmarks", color: Color(0xFFDBDCCE))),
                                  GestureDetector(onTap:(){onClick("Parks");},child: InterestCard(title: "Parks", color: Color(0xFF898D86)))

                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],),

                  RoundedButton(title: 'Next',textColor:Colors.white,color: kPinkColor,onPress: () async
  {
if(interests.length>=2){
  setState(() {
    showSpinner=true;
  });
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
}else{
  tost(context, "Please add at least two interests");
}
                  },height: 50),
                ],
              ),
            )

        ),
      ),
    );
  }
}
