import 'package:flutter/material.dart';
import 'package:huna_ksa/Components/constants.dart';
import 'package:huna_ksa/Widgets/rounded_Button.dart';
import 'package:huna_ksa/components/common_Functions.dart';
class FavouriteCard extends StatefulWidget {
FavouriteCard({required this.imagePath,required this.placeName, required this.delete});

final imagePath;
final placeName;
final Function delete;
//imageClick;
  @override
  State<FavouriteCard> createState() => _FavouriteCardState();
}

class _FavouriteCardState extends State<FavouriteCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:15),
      child: Container(
        decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(15)

        ),
        height: 140,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(top:10,bottom: 8,left: 10,right: 10),
          child: Stack(
            children: [
              SizedBox(height: 120,
                width: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10), // Image border
                  child: SizedBox.fromSize(
                    //size: Size.fromWidth(height), // Image radius
                    child: Image.network(widget.imagePath,fit: BoxFit.fill),
                  ),
                ),
              ),
              Positioned(right:0,child: deleteButton((){widget.delete(widget.placeName);})),


              Positioned(left:110,top:45,child: Text(widget.placeName,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black),)),

            ],
          ),
        ),
      ),
    );
  }
}
