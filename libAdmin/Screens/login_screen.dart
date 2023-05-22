import 'package:huna_ksa_admin/Components/common_Functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:huna_ksa_admin/Widgets/rounded_Button.dart';
import 'package:flutter/material.dart';
import 'package:huna_ksa_admin/Components/session.dart' as session;
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../Components/common_Functions.dart';
import '../Components/constants.dart';
import '../main.dart';
import 'main_screen.dart';

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
  final usernameController = TextEditingController();

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
            //https://api.flutter.dev/flutter/widgets/Positioned-class.html
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
                    "Username",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),

                  TextField(
                    controller: usernameController,
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    textInputAction: TextInputAction.next,
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Username',
                        prefixIcon: Icon(
                          Icons.supervised_user_circle_outlined,
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

                ],
              ),
            ),
          ),
        ],)

      ),
    );
  }

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
    try {
      if (usernameController.text == "") {
        myNotifier(context, "Please enter your Email.", function: () {});
        setState(() {
          showSpinner = false;
        });
      } else if (!RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(usernameController.text)) {
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
        if(usernameController.text=="admin@gmail.com"){
          //print("hy");
          await _auth
              .signInWithEmailAndPassword(
              email: usernameController.text, password: passwordController.text)
              .then((value) {

            setState(() async {
              await getCurrentUser().then((value) {
                usernameController.clear();
                passwordController.clear();
                showSpinner = false;
                pushAndRemove(context, MainScreen());
              });
            });
          });
        }else{

        }
      } //// https://firebase.google.com/docs/auth/flutter/start?hl=ar
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

}
