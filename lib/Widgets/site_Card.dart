import 'package:flutter/material.dart';
import 'package:huna_ksa/Components/constants.dart';
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
          borderRadius: BorderRadius.circular(20)
        ),
        child: Stack(
            alignment: Alignment.topCenter,
            children:[
              SizedBox(

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20), // Image border
                  child: SizedBox.fromSize(
                    size: Size.fromHeight(100), // Image radius
                    child: Image(image:AssetImage(widget.imagePath,), fit: BoxFit.cover),
                  ),
                ),
              ),

              Positioned(
                  top: 74,
                  right: 5,
                  child: Container(
                    width: 24,
                    height: 22,
                    child: Icon(
                        Icons.favorite_border,
                        color: Colors.redAccent,
                        size: 23.0,
                    ),

                  )
              ),

              /*Positioned(
                top: 74,
                right: 5,

                child: Container(
                    width: 24,
                    height: 22,

                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(100)
                    ),
                    child: Center(child: ImageIcon(AssetImage('images/heart.png'),size: 20,color: Colors.black45,))),
              ),*/

              Positioned(
                bottom: 5,
                left: 10,
                child: Text(widget.cityName,
                  style: const TextStyle(fontSize: 13.5,fontWeight: FontWeight.bold),),
              )


            ]),
      ),
    );
  }
}
