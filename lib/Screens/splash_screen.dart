import 'dart:async';
import 'package:huna_ksa/components/common_Functions.dart';
import 'package:huna_ksa/components/constants.dart';
import 'package:huna_ksa/Screens/registration_screen.dart';
import 'package:huna_ksa/Components/session.dart' as session;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


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
              //Text('DERZI',style: kButtonTextStyle.copyWith(fontSize: 60,color: Colors.brown[900])),
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
    pushAndRemove(context, RegistrationScreen());
  }
}
