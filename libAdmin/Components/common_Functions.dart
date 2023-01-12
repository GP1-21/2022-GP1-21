
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huna_ksa_admin/components/session.dart' as session;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../Widgets/rounded_Button.dart';
import 'constants.dart';

final _firestore=FirebaseFirestore.instance;
TextField inputText(TextEditingController controller,TextInputType type,String hint){
  return TextField(
    style: kTextStyle,
    controller: controller,
    keyboardType: type,
    textAlign: TextAlign.center,
    decoration: kTextField2Decoration.copyWith(
        hintText: hint,
  )
  );
}
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
      child: const Text("Yes",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 20),),
      onPressed:()async {
        await yesFunction();

      }
  );
  Widget noButton = TextButton(
    child: const Text("No",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
    onPressed:  () {
      Navigator.pop(context);
    },
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Container(
        child: AlertDialog(
          title: Center(child: Text(title,style: TextStyle(color: Colors.black),)),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
              width:MediaQuery.of(context).size.width*.90,
              height: 85.0,
              decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                color: const Color(0xFFFFFF),
                borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(child: Text(text,style: TextStyle(fontSize: 27),textAlign: TextAlign.center,)
                  //       TextField(
                  //       decoration: InputDecoration(
                  //       hintText: "Add Review",
                  //       border: InputBorder.none,
                  //     ),
                  //   maxLines: 8,
                  // ),
                ),
              )),


          backgroundColor: Colors.white,
          actions: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                yesButton,
                noButton,

              ],
            ),
          ],
        ),
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
