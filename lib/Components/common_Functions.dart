
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
      return Container(
        child: AlertDialog(

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


          backgroundColor: kBackgroundColor,
          actions: [
            Align(alignment:Alignment.centerRight,child: yesButton),
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
          duration: Duration(seconds: duration), behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*.50),
          dismissDirection: DismissDirection.none,
          content: Text(message,style: TextStyle(color: Colors.white,),textAlign: TextAlign.center,),
          //behavior: SnackBarBehavior.fixed,
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
Widget smallButton(String text,Function function,{
  Color color=const Color(0xFFD6D6D6),
  double height=30,
  double width=85,
  double fontSize=12}) {
  return GestureDetector(
    onTap: (){
      function();
    },
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(color: color,borderRadius: BorderRadius.circular(25)),
      child:Center(child: Text
        (text, style: TextStyle(color: Colors.black,fontSize: fontSize,fontWeight: FontWeight.bold),)
      ),
    ),
  );
}
Widget deleteButton(Function function,) {
  return GestureDetector(
    onTap: (){
      function();
    },
    child: ImageIcon(AssetImage('images/delete.png'),size: 27,color: Colors.black,),
  );
}
Widget iconButton(Function function,Color color,String imagePath) {
  return GestureDetector(
    onTap: (){
      function();
    },
    child: Container(
        height: 40,width: 50,
        decoration:BoxDecoration(color: color,borderRadius: BorderRadius.circular(10)),child: Center(child: ImageIcon(AssetImage(imagePath),size: 27,color: Colors.black,))),
  );
}
Widget categoryCard(String text,Color color,Color borderColor,double width,Function function) {
  return Padding(
    padding: const EdgeInsets.only(left: 7),
    child: GestureDetector(
      onTap: (){
        function(text);
      },
      child: Container(
        height: 20,width: width,
        decoration: BoxDecoration(color: color,borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor)),
        child:Center(child: Text(text, style: const TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),)),
      ),
    ),
  );
}

Widget commentCard(String text,String username,String id,Function function,BuildContext context) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: Text(username.trim(), style: const TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),
      ),

      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ImageIcon(AssetImage('images/profile.png'),size: 27,color: Colors.black,),
              SizedBox(width: 5,),
              Text(text, style: const TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),),

            ],
          ),
          GestureDetector(onTap:(){
            function(id,text);
          },child: Icon(Icons.info_outline,size:
          27,))
        ],
      ),
      Divider(thickness: 1,)

    ],
  );
}