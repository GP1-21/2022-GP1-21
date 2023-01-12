import 'package:flutter/material.dart';
import 'package:huna_ksa_admin/Widgets/rounded_Button.dart';

import '../Components/constants.dart';

Widget PlaceCard(String placeName,BuildContext context)
{
  return Container(
    decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(15)

    ),
    height: 110,
    width: double.infinity,
    child: Padding(
      padding: const EdgeInsets.only(top:10,bottom: 8,left: 10,right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 15,),
          Text(placeName,style: const TextStyle(fontSize: 35,fontWeight: FontWeight.bold,color: Colors.black),),
          Align(alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 15,),
              child: SizedBox(width:MediaQuery.of(context).size.width*.65,child: Divider(thickness: .7,color: Colors.black,)),
            ),
          )

        ],
      ),
    ),
  );
}