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
    child:  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(width: 15,),
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(placeName,style: const TextStyle(fontSize: 28,fontWeight: FontWeight.bold,color: Colors.black),),
        ),
        SizedBox(width:MediaQuery.of(context).size.width*.65,child: Divider(thickness: .7,color: Colors.black,))

      ],
    ),
  );
}