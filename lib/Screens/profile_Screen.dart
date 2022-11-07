
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
final _firestore=FirebaseFirestore.instance;

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
  // void reSign() async
  // {
  //   await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: session.email, password: session.password);
  // }
  void logout()async {

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
  void setSessionData()
  {
    setState(() {
      session.username=nameController.text;
    });

  }
  final _auth=FirebaseAuth.instance;
  void updateUser() async
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
          //Navigator.pop(context);
        });


      });

    } on FirebaseAuthException catch (e) {
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
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        progressIndicator:CircularProgressIndicator(color: kProgressIndicatorColor,),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 80.0,),

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
                    height: 60.0,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RoundedButton(horizontal: 5,title: "Edit",color: kPinkColor,textColor: Colors.black,onPress: () async
                      {
setState(() {
  enabled=!enabled;
});
                      }, height: 0),

                      RoundedButton(horizontal:5,title: "Update",color: kPrimaryColor,textColor: Colors.black,onPress: () async
                      {

                        if(nameController.text=="")
                        {
                          tost(context, "Please enter Username.");
                        }
                        else{

                          updateUser();
                        }

                      }, height: 0,),
                    ],
                  ),
                  SizedBox(height: 50.0,),
                  GestureDetector(
                    onTap: (){
                      showAlertDialog(context, logout, "Logout", "Do you want to logout?");
                    },
                    child: Row(mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ImageIcon(AssetImage('images/logout.png'),size: 60,),
                        RoundedButton(horizontal: 5,title: "Logout",color: kPinkColor,textColor: Colors.black,onPress: () async
                        {

                        }, height: 0),

                      ],
                    ),
                  ),

                ],
              ),
              GestureDetector(
                  onTap:(){
pushAndRemove(context, MainScreen());                  },
                    child: Icon(Icons.arrow_back_ios_new_outlined,size:
                     40,)),

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
      decoration: kTextFieldDecoration.copyWith(hintText: hint,prefixIcon: icon,filled: true,fillColor: Colors.grey.shade500),

    );

  }

  Widget inputText(TextEditingController controller, String hint,TextInputType type,Icon icon) {
    return TextField(
      enabled: enabled,
      controller: controller,
      keyboardType: type,
      textAlign: TextAlign.center,
      decoration: kTextFieldDecoration.copyWith(hintText: hint,prefixIcon: icon,filled: true,fillColor: Colors.grey.shade500),

    );

  }
}
