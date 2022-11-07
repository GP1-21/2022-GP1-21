
import 'package:huna_ksa/components/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huna_ksa/components/session.dart' as session;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

final _firestore=FirebaseFirestore.instance;

push(BuildContext context,var screen)
{
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => screen
    ),
  );
}
pushAndRemove(BuildContext context,var screen)
{
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
        builder: (context) => screen
    ),
          (Route route) => false  );
}
showAlertDialog(BuildContext context,Function yesFunction,String title,String text) {

  Widget yesButton = TextButton(
    child: const Text("Yes",style: TextStyle(color: Colors.black),),
    onPressed:()async {
     await yesFunction();

    }
  );
  Widget noButton = TextButton(
    child: const Text("No",style: TextStyle(color: Colors.black),),
    onPressed:  () {
      Navigator.pop(context);
    },
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title,style: TextStyle(color: Colors.black),),
        content: Text(text),
        backgroundColor: kBodyColor,
        actions: [
          noButton,
          yesButton,
        ],
      );
    },
  );
}



tost(BuildContext context,String text,[int duration =2])
{
  myNotifier(context,text,duration: duration,function: (){});
}

myNotifier(BuildContext context,String message,{String label="",required Function function,int duration=2,Color buttonColor=Colors.black}) async {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
    backgroundColor: const Color(0xFF616161),
    duration: Duration(seconds: duration),
    content: Text(message,style: TextStyle(color: Colors.white,),textAlign: TextAlign.center,),
    behavior: SnackBarBehavior.fixed,
    action: label!=""?SnackBarAction(
      label: label,
      disabledTextColor: Colors.white,
      textColor: buttonColor,
      onPressed:() async
      {
        await function();
      },
    ): null
    ));
}
// class DrawTriangleShape extends CustomPainter {
//
//   late Paint painter;
//
//   DrawTriangleShape() {
//
//     painter = Paint()
//       ..color = kPrimaryColor
//       ..style = PaintingStyle.fill;
//
//   }
//
//   @override
//   void paint(Canvas canvas, Size size) {
//
//     var path = Path();
//
//     path.moveTo(size.width/2, 180);
//     path.lineTo(-40, size.height-120);
//     path.lineTo(size.height+40, size.width-120);
//     path.close();
//
//     canvas.drawPath(path, painter);
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }