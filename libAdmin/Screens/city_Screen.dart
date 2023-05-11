import 'package:flutter/material.dart';
import 'package:huna_ksa_admin/Screens/delete_Comment_Screen.dart';
import 'package:huna_ksa_admin/Screens/delete_Screen.dart';
import 'package:huna_ksa_admin/Screens/selectPlace_Screen.dart';
import 'package:huna_ksa_admin/Widgets//city_Card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huna_ksa_admin/Components/common_Functions.dart';
import 'package:huna_ksa_admin/Components/constants.dart';
import 'package:huna_ksa_admin/Components/session.dart' as session;

import 'add_Screen.dart';



final _firestore = FirebaseFirestore.instance;
class CityScreen extends StatefulWidget {
  CityScreen({required this.screenFrom});
  final String screenFrom;

  @override
  State<CityScreen> createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  List<CityCard> cards = [
    CityCard(imagePath: "images/Riyadh_jpg", cityName: "Riyadh"),
    CityCard(imagePath: "images/abha1.jpg", cityName: "Abha"),
    CityCard(imagePath: "images/jeddah-city.jpg", cityName: "Jeddah"),
    CityCard(imagePath: "images/ALULA.jpg", cityName: "Al-Ula"),
    CityCard(imagePath: "images/Khobar1.jpg", cityName: "Alkhobar")
  ];
  goNext(String name,String cityName)
  {
    if(name=="delete")
      {
        push(context,DeleteScreen(city: cityName,) );
      }
    else if(name=="add")
    {
      push(context,AddScreen(city: cityName,) );
    }
    else if(name=="edit")
    {
      push(context,SelectPlaceScreen(city: cityName,fromScreen: "edit",) );
    }
    else if(name=="comment")
    {
      push(context,SelectPlaceScreen(city: cityName, fromScreen: 'comment',) );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_new_rounded,size:
          40,color: kPrimaryColor,),
        ),
      ),
      backgroundColor: kBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5,),
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Text("Select the city:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
          ),
          Expanded(
            child: ListView.builder(
              //scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 30, right:30,bottom: 10,top: 1),
                itemCount: cards.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                  onTap:()
    {
      goNext(widget.screenFrom, cards[index].cityName);
    },
    child: cards.elementAt(index));
                }
              //children: orderBubbles,


            ),
          ),
        ],
      ),
    );
  }
}
