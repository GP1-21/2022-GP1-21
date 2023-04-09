import 'package:flutter/material.dart';
import 'package:huna_ksa_admin/Widgets/rounded_Button.dart';

import '../Components/common_Functions.dart';
import '../Components/constants.dart';

Widget DeletePlaceCard(List imagePaths,String placeName,Function delete,BuildContext context)
{
  return Container(
    decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(15)

    ),
    height: 170,
    width: double.infinity,
    child: Stack(
      children: [
        Positioned(
          left: 10,top: 10,
          child: SizedBox(height: 120,
            width: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10), // Image border
              child: SizedBox.fromSize(
                //size: Size.fromWidth(height), // Image radius
                child: Image.network(imagePaths[0], fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
        Positioned(left:120,top:45,child: Text(placeName,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),)),

        Positioned(right:10,top:10,child: deleteButton((){delete(placeName,imagePaths);},context)),

        Positioned(
          bottom: 0,
          child: SizedBox(width:MediaQuery.of(context).size.width*.75,child: Divider(thickness: .7,color: Colors.black,)),
        )
      ],
    ),
  );
}

Widget DeleteCommentCard(String username,String comment,String placeName,Function delete,BuildContext context)
{
  return Container(
    decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(15)

    ),
    height: 120,
    width: double.infinity,
    child: Padding(
      padding: const EdgeInsets.only(top:10,bottom: 8,left:0,right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(username.trim(),style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.black),),
                    SizedBox(height: 10,),

                    Text(comment,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black),),
                  ],),
                deleteButton((){delete(username+placeName+comment);},context),
                //RoundedButton(title: "Delete", color: kPinkColor, onPress: (){delete(username+placeName+comment);}, textColor: Colors.black,height: 20, horizontal: 0,width: 80,)

              ],),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20,),
            child: SizedBox(width:MediaQuery.of(context).size.width*.75,child: Divider(thickness: .7,color: Colors.black,)),
          )

        ],
      ),
    ),
  );
}

Widget DeleteReportedCommentCard(String username,String comment,String placeName,Function delete,Function deleteReport,BuildContext context,String id)
{
  return Container(
    decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(15)

    ),
    //height: 120,
    width: double.infinity,
    child: Padding(
      padding: const EdgeInsets.only(top:15,bottom: 0,left:0,right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(username.trim(),style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.black),),
                    SizedBox(height: 10,),

                    Text(comment,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black),),
                  ],),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    smallButton(context, (){delete(id);deleteReport(id);}, kPinkColor, "Delete", "Do you want to delete this comment?"),
                    SizedBox(height: 5,),
                    smallButton(context, (){deleteReport(id);}, Colors.green.withOpacity(.5), "Keep", "Do you want to keep this comment?")

                  ],
                ),

                //deleteButton((){delete(id);},context),
                //RoundedButton(title: "Delete", color: kPinkColor, onPress: (){delete(username+placeName+comment);}, textColor: Colors.black,height: 20, horizontal: 0,width: 80,)

              ],),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20,),
            child: SizedBox(width:MediaQuery.of(context).size.width*.75,child: Divider(thickness: .7,color: Colors.black,)),
          )

        ],
      ),
    ),
  );
}