import 'package:flutter/material.dart';
import 'package:huna_ksa_admin/Widgets/rounded_Button.dart';

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
    child: Padding(
      padding: const EdgeInsets.only(top:10,bottom: 8,left: 10,right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(height: 120,
                width: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10), // Image border
                  child: SizedBox.fromSize(
                    //size: Size.fromWidth(height), // Image radius
                    child: FadeInImage(image: NetworkImage(imagePaths[0],), fit: BoxFit.fill, placeholder: const AssetImage("images/Boulevard.png"),
                  ),
                ),
              ),
              ),
              SizedBox(width: 15,),
              Column(children: [
                Text(placeName,style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.black),),
                SizedBox(height: 10,),
                RoundedButton(title: "Delete", color: kPinkColor, onPress: (){delete(placeName,imagePaths);}, textColor: Colors.black,height: 20, horizontal: 0,width: 80,)
              ],)
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15,),
            child: SizedBox(width:MediaQuery.of(context).size.width*.75,child: Divider(thickness: .7,color: Colors.black,)),
          )

        ],
      ),
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
      padding: const EdgeInsets.only(top:10,bottom: 8,left: 15,right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(username,style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.black),),
              SizedBox(height: 10,),

              Text(comment,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black),),
            ],),

            RoundedButton(title: "Delete", color: kPinkColor, onPress: (){delete(username+placeName+comment);}, textColor: Colors.black,height: 20, horizontal: 0,width: 80,)
          ],),
          Padding(
            padding: const EdgeInsets.only(top: 20,),
            child: SizedBox(width:MediaQuery.of(context).size.width*.75,child: Divider(thickness: .7,color: Colors.black,)),
          )

        ],
      ),
    ),
  );
}