import 'package:flutter/material.dart';
import 'package:huna_ksa_admin/Components/constants.dart';
class SiteCard extends StatefulWidget {
SiteCard({required this.imagePath,required this.cityName});

final imagePath;
final cityName;
  @override
  State<SiteCard> createState() => _SiteCardState();
}

class _SiteCardState extends State<SiteCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:15),
      child: Container(
        height: 120,
        width: 90,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(25)
        ),
        child: Stack(
            alignment: Alignment.topCenter,
            children:[
              SizedBox(

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20), // Image border
                  child: SizedBox.fromSize(
                    //size: Size.fromWidth(height), // Image radius
                    child: Image(image:AssetImage(widget.imagePath,), fit: BoxFit.cover),
                  ),
                ),
              ),
              Positioned(
                top: 65,
                right: 10,

                child: Container(
                    width: 35,
                    height: 33,

                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100)
                    ),
                    child: Center(child: ImageIcon(AssetImage('images/heart.png'),size: 27,color: Colors.black,))),
              ),
              Positioned(
                bottom: 5,
                left: 10,
                child: Text(widget.cityName,style: const TextStyle(fontSize: 13,fontWeight: FontWeight.bold),),
              )


            ]),
      ),
    );
  }
}
