import 'package:huna_ksa/Screens/main_Screen.dart';
import 'package:huna_ksa/Components/common_Functions.dart';
import 'package:huna_ksa/Screens/registration_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:huna_ksa/Widgets/rounded_Button.dart';
import 'package:flutter/material.dart';
import 'package:huna_ksa/Components/session.dart' as session;
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../Components/common_Functions.dart';
import '../Components/constants.dart';
import '../main.dart';

//https://medium.com/enappd/connecting-cloud-firestore-database-to-flutter-voting-app-2da5d8631662
final _firestore = FirebaseFirestore.instance;

//https://api.flutter.dev/flutter/widgets/StatefulWidget/createState.html
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscure = true;
  bool showSpinner = false;
  final emailController = TextEditingController(); //controller for editable text field

  final passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  //https://api.flutter.dev/flutter/widgets/StatelessWidget/build.html
  @override
  Widget build(BuildContext context) {
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
                  SizedBox(
                    height: 190.0,
                  ),
                  Text(
                    "Email",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),

                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    textInputAction: TextInputAction.next,
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Email',
                        prefixIcon: Icon(
                          Icons.email_outlined,
                        )),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    "Password",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),

                  customPasswordInputText(
                    passwordController,
                    'Password',
                    TextInputType.text,
                    true,
                    Icon(Icons.lock_outlined),
                    IconButton(
                      icon: Icon(Icons.remove_red_eye_outlined),
                      color: obscure ? Colors.black : Colors.grey,
                      onPressed: () {
                        setState(() {
                          this.obscure = !this.obscure;
                        });
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: TextButton(
                        child: Text(
                          "FORGET PASSWORD",
                          style: (TextStyle(
                              decoration: TextDecoration.underline,
                              color: Color(0xFF616161))),
                        ),
                        onPressed: () {
                          resetPassword();
                        }),
                  ),
                  SizedBox(
                    height: 22.0,
                  ),
                  RoundedButton(
                      title: 'LOGIN',
                      height: 55,
                      color: kPrimaryColor,
                      textColor: Colors.white,
                      onPress: () async {
                        await LogIn();
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: GestureDetector(
                        onTap: () {
                          pushAndRemove(context, RegistrationScreen());
                        },
                        child: Text(
                          "Create Account",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ],)

      ),
    );
  }
  // Return user data after login successfully
  Future getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        final userData = await _firestore
            .collection('userData')
            .where('email', isEqualTo: user.email)
            .get();

        for (var myData in userData.docs) {
          setState(() {
            session.email = myData.data()['email'];
            session.username = myData.data()['name'];
            session.password = myData.data()['password'];
            session.city = myData.data()['city'];
            session.interests = myData.data()['interest'];
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  LogIn() async {
    try { //Email text field
      if (emailController.text == "") {
        myNotifier(context, "Please enter your Email.", function: () {});
        setState(() {
          showSpinner = false;
        });
      } else if (!RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(emailController.text)) {
        myNotifier(context, "Please enter a valid Email.", function: () {});

        setState(() {
          showSpinner = false;
        });
      } else if (passwordController.text == "") {
        tost(context, 'Please enter your Password');

        setState(() {
          showSpinner = false;
        });
      } else {
        setState(() {
          showSpinner = true;
        });
        FocusScope.of(context).unfocus();
        await _auth
            .signInWithEmailAndPassword(
                email: emailController.text, password: passwordController.text)
            .then((value) {
          setState(() async {
            await getCurrentUser().then((value) {
              emailController.clear();
              passwordController.clear();
              showSpinner = false;
              pushAndRemove(context, MainScreen());
            });
          });
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          showSpinner = false;
        });
        tost(context, 'Invalid Email!');
      } else if (e.code == 'wrong-password') {
        setState(() {
          showSpinner = false;
        });
        tost(context, 'Incorrect Password!');
      }
    } catch (e) {
      print(e);
      setState(() {
        showSpinner = false;
      });
    }
  }
  // Reset password with email
  resetPassword() async {
    try {
      if (emailController.text == "") {
        tost(context, 'Please enter your Email');
      } else if (!RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(emailController.text)) {
        tost(context, 'Please enter a valid Email.');
      } else {
        setState(() {
          showSpinner = true;
        });

        await _auth
              //Sending password reset email to the given email adress
            .sendPasswordResetEmail(email: emailController.text)
            .then((value) {
          setState(() {
            showSpinner = false;
          });
          tost(context, 'Please check your email to reset password.');
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          showSpinner = false;
        });
        tost(context, 'No user found for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
}
