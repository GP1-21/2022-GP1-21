
import 'package:huna_ksa/Screens/editInterest_Screen.dart';
import 'package:huna_ksa/Screens/main_Screen.dart';
import 'package:huna_ksa/Screens/registration_screen.dart';
import 'package:huna_ksa/Components/common_Functions.dart';
import 'package:huna_ksa/Widgets/rounded_Button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:huna_ksa/Components/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:huna_ksa/Components/session.dart' as session;

import '../Widgets/interest_Card.dart';
final _firestore=FirebaseFirestore.instance; //firebase connection

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  bool showSpinner = false;
  bool enabled=false;
  final emailController = TextEditingController();
  final nameController = TextEditingController();
@override
  void initState() {
  // TODO: implement initState
  super.initState();

  //reSign();
  setState(() {
    emailController.text = session.email;
    nameController.text = session.username;
  });
}

  void logout()async { // user logging out of the app

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
  void setSessionData() // save user data after they have logged out
  {
    setState(() {
      session.username=nameController.text;
    });

  }
  final _auth=FirebaseAuth.instance;
  void updateUser() async // update the information the user changes in their profile
  {
    try {

      await _firestore.collection('userData').doc(session.email).update(
          {

            'name': nameController.text,
          }).then((value) {
        setState(() {
          showSpinner=false;
          tost(context, "Profile Updated Successfully.");
          setSessionData();
          setEmpty();

        });


      });

    } on FirebaseAuthException catch (e) { // check if the email or password they changed are valid
      if (e.code == 'weak-password') {
        tost(context, "The password provided is too weak.");
        setState(() {
          showSpinner=false;
        });
      } else if (e.code == 'email-already-in-use') {
        tost(context, "The account already exists for that email.");
        setState(() {
          showSpinner=false;
        });
      }
    } catch (e) {
      print(e);
    }
  }
  void setEmpty()
  {
    setState(() {
      enabled=false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text("ACCOUNT",style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold),),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
            onTap:(){
              pushAndRemove(context, MainScreen());                },
            child: Icon(Icons.arrow_back_ios_new_outlined,color: kPrimaryColor,size: 30,)
        ),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        progressIndicator:CircularProgressIndicator(color: kProgressIndicatorColor,),
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ImageIcon(AssetImage('images/profile.png'),size: 120,color: kPrimaryColor,),
              SizedBox(height: 15,),
              Container(
                height: 300,
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(.4),
                  borderRadius: BorderRadius.circular(40)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                    Text("Email",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),

                    emailInputText(emailController, 'Email', TextInputType.emailAddress,
                        Icon(Icons.email_outlined)),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text("Username",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
                    inputText(
                      nameController,
                      'Username',
                      TextInputType.text,
                      Icon(Icons.person_outlined),
                    ),

                    SizedBox(
                      height: 30.0,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        smallButton("Edit",color: kPinkColor,() async
                        {
                          setState(() {
                            enabled=!enabled;
                          });
                        }, height: 40,width: 90,  fontSize: 18),

                        smallButton( "Update",color: kPrimaryColor,() async
                        {

                          if(nameController.text=="")
                          {
                            tost(context, "Please enter Username.");
                          }
                          else{

                            updateUser();
                          }

                        }, height: 40,fontSize: 18,width: 100),
                      ],
                    ),
                  ],),
                ),
              ),

              SizedBox(height: 50.0,),
              Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(.4),
                      borderRadius: BorderRadius.circular(40)
                  ),
child: Padding(
  padding: const EdgeInsets.only(top: 10.0,left: 10),
  child:   Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    smallButton("Edit",color: kPinkColor, () async
    {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditInterestScreen() // user edits their interests
        ),
      ).then((value) => setState((){}));
    },height: 40,fontSize:18),
      Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            session.interests.isNotEmpty?InterestCard(title: session.interests[0], color: Color(0xFFDCCEDA)):Container(),
            session.interests.length>1?InterestCard(title: session.interests[1], color: Color(0xFFB3BFB7)):Container(),
            session.interests.length>2?InterestCard(title: session.interests[2], color: Color(0xFF7094A4)):Container(),

          ],
        ),
      ),



    ],),
),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child:

                GestureDetector(
                  onTap: (){
                    showAlertDialog(context, logout, "LOG OUT", "Do you want to logout?");
                  },
                  child: Container(
                    height: 40,
                    width: 120,
                    decoration: BoxDecoration(color: kPinkColor,borderRadius: BorderRadius.circular(15)),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("LOG OUT", style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                        ImageIcon(AssetImage('images/logout.png'),size: 27,color: Colors.black,),

                      ],
                    ),
                  ),
                ),

              ),

            ],
          ),
        ),
      ),
    );
  }
  Widget emailInputText(TextEditingController controller, String hint,TextInputType type,Icon icon) {
    return TextField(
      enabled: false,
      controller: controller,
      keyboardType: type,
      textAlign: TextAlign.center,
      decoration: kTextFieldDecoration.copyWith(hintText: hint,prefixIcon: icon,filled: true,fillColor: Colors.white),

    );

  }

  Widget inputText(TextEditingController controller, String hint,TextInputType type,Icon icon) {
    return TextField(
      enabled: enabled,
      controller: controller,
      keyboardType: type,
      textAlign: TextAlign.center,
      decoration: kTextFieldDecoration.copyWith(hintText: hint,prefixIcon: icon,filled: true,fillColor: Colors.white),

    );

  }
}
