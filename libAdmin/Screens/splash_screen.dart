import 'dart:async';
import 'package:huna_ksa_admin/Screens/main_screen.dart';
import 'package:huna_ksa_admin/components/constants.dart';
import 'package:huna_ksa_admin/Components/session.dart' as session;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:huna_ksa_admin/Components/common_Functions.dart';
import 'login_screen.dart';

//Create the class of the splash page, https://api.flutter.dev/flutter/widgets/StatefulWidget/createState.html
class SplashScreen extends StatefulWidget {
  static const String id='splash_screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }
  //Create and design the frame of the splash page
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [kPrimaryColor, kPrimaryColor]
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('images/logo.png'),
                height: 200,
                width: 200,
              ),

            ],
          ),
        ),
      ),
    );
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 3), onDoneLoading);
  }

  onDoneLoading() async {
    pushAndRemove(context, LoginScreen());
  }
}
