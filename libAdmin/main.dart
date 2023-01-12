import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Start());
}
class Start extends StatefulWidget {

  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  @override
  Widget build(BuildContext context) {
    theme: ThemeData.dark().copyWith(
    );

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

      return MaterialApp(

        theme: ThemeData(

          colorScheme: ThemeData().colorScheme.copyWith(
            primary:Colors.black,
            //brightness: Brightness.dark,
        ),
        ),

        debugShowCheckedModeBanner: false,

        initialRoute: SplashScreen.id,
        routes: {
          SplashScreen.id:(context)=>SplashScreen(),
        },

      );
    }
}
