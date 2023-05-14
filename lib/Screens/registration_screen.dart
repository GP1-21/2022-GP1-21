import 'package:huna_ksa/Screens/interest_Screen.dart';
import 'package:huna_ksa/Components/common_Functions.dart';
import 'package:huna_ksa/Widgets/rounded_Button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:huna_ksa/Components/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:huna_ksa/Components/session.dart' as session;


import 'login_screen.dart';

//https://medium.com/enappd/connecting-cloud-firestore-database-to-flutter-voting-app-2da5d8631662
final _firestore = FirebaseFirestore.instance; // connection to firebase

//https://api.flutter.dev/flutter/widgets/StatefulWidget/createState.html
class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> { // constructor
  bool showSpinner = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  bool obscure1 = true;
  void setEmpty() {
    setState(() {
      nameController.clear();
      emailController.clear();
      passwordController.clear();
    });
  }

  //https://api.flutter.dev/flutter/widgets/StatelessWidget/build.html
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kBackgroundColor,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        progressIndicator: CircularProgressIndicator(
          color: kProgressIndicatorColor,
        ),
        child: Stack(alignment: Alignment.topLeft,
          children: [
          Align(alignment: Alignment.bottomLeft,
            child: Container(
              width: MediaQuery.of(context).size.width*.65,
              height: MediaQuery.of(context).size.height*.90,
              decoration: BoxDecoration(
                  color:kPrimaryColor.withOpacity(.50),
                  borderRadius: BorderRadius.only(topRight: Radius.circular(30),bottomRight: Radius.circular(30))

              ),
            ),
          ),
          Positioned(top: MediaQuery.of(context).size.height*.15,
              child: Image(image: AssetImage("images/shape.png",),height: MediaQuery.of(context).size.width*.50,width: MediaQuery.of(context).size.width*.50,)),

          Padding(
            padding: EdgeInsets.only(left: 80,right: 80,top: MediaQuery.of(context).size.height*.10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox( // creation of the username field
                    height: 190.0,
                  ),
                  Text("Username",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),),
                  customInputText(
                    nameController,
                    'Username',
                    TextInputType.text,
                    Icon(Icons.person_outlined),
                  ),
                  SizedBox( // creation of the email field
                    height: 8.0,
                  ),
                  Text("Email",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),),

                  customInputText(emailController, 'Email', TextInputType.emailAddress,
                      Icon(Icons.email_outlined)),
                  SizedBox( // creation of the password field
                    height: 8.0,
                  ),
                  Text("Password",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),),

                  customPasswordInputText(
                    passwordController,
                    'Password',
                    TextInputType.text,
                    obscure1,
                    Icon(Icons.lock_outlined),
                    IconButton(
                      icon: Icon(Icons.remove_red_eye_outlined),
                      color: obscure1 ? Colors.black : Colors.grey, //change field color when it is pressed
                      onPressed: () {
                        setState(() {
                          this.obscure1 = !this.obscure1;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  RoundedButton(
                    height: 55,
                    title: 'Create',
                    color: kPrimaryColor,
                    textColor: Colors.white,
                    onPress: () async { // when user clicks create, their username and password will be checked and validated
                      if (nameController.text == "") {
                        tost(context, 'Please enter Username.');
                      } else if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(emailController.text)) {
                        tost(context, 'Please enter a valid Email.');
                      } else if (passwordController.text == "") {
                        tost(context, 'Please Enter Password');
                      } else {
createUser();



                      }
                    },
                  ),
                  SizedBox( // redirect to login screen
                    height: 10.0,
                  ),
                  Center(
                    child: GestureDetector(onTap:(){
                      pushAndRemove(context, LoginScreen());                  },
                        child: Text("Log-in",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
                  ),

                ],
              ),
            ),
          ),
        ],),

      ),
    );
  }

  createUser() async { // create user and add them in the database
    setState(() {
      showSpinner=true;
    });
    try {
      final newUser =
      await _auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text);
      if (newUser != null) {
        await _firestore
            .collection('userData')
            .doc(emailController.text)
            .set(
          {
            'email': emailController.text,
            'password': passwordController.text,
            'name': nameController.text,
            'interest':[],
            'city':''
          },
        ).then((value) {
          setState(() {
            session.email=emailController.text;
            session.username=nameController.text;
            session.password=passwordController.text;
            showSpinner = false;
          });
          push(context, InterestScreen());
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') { // firebase checks and validates pwd
        tost(context, 'The password provided is too weak.');

        setState(() {
          showSpinner = false;
        });
      } else if (e.code == 'email-already-in-use') { // prevent creation of 2 accounts with the same email
        tost(context,
            'The account already exists for that email.');
        setState(() {
          showSpinner = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

}
