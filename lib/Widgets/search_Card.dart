import 'package:flutter/material.dart';
import 'package:huna_ksa/Components/constants.dart';
import 'package:huna_ksa/Widgets/rounded_Button.dart';
class SearchCard extends StatefulWidget {
SearchCard({required this.imagePath,required this.placeName});

final imagePath;
final placeName;
//imageClick;
  @override
  State<SearchCard> createState() => _SearchCardState();
}

class _SearchCardState extends State<SearchCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child:
      Padding(
        padding: const EdgeInsets.only(top:15),
        child: Container(
          height: 130,
          width: 90,
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(25)
          ),
          child: Row(

              children:[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                  width: 90,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20), // Image border
                      child: SizedBox.fromSize(
                        size: Size.fromHeight(130), // Image radius
                        child: Image.network(widget.imagePath[0],fit: BoxFit.fill),),
                    ),
                  ),
                ),
                SizedBox(width: 30,),
                Text(widget.placeName,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)


              ]),
        ),
      ),
    );
  }
}
