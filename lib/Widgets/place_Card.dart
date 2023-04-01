import 'package:flutter/material.dart';
import 'package:huna_ksa/Components/constants.dart';
import 'package:huna_ksa/Components/session.dart' as session;

class PlaceCard extends StatefulWidget {
PlaceCard({required this.imagePath,required this.placeName, required this.likeClick, required this.imageClick});

final imagePath;
final placeName;
final Function likeClick,imageClick;
  @override
  State<PlaceCard> createState() => _PlaceCardState();
}

class _PlaceCardState extends State<PlaceCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:15),
      child: Container(
        height: 130,
        width: 100,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(25)
        ),
        child: Stack(
            alignment: Alignment.topCenter,
            children:[
              SizedBox(

                child: GestureDetector(
                  onTap: (){
                    widget.imageClick(widget.placeName,widget.imagePath[0]);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20), // Image border
                    child: SizedBox.fromSize(
                      size: Size.fromHeight(100), // Image radius
                      child: Image.network(widget.imagePath[0], fit: BoxFit.fill),
                      //FadeInImage(image: NetworkImage(widget.imagePath[0],), fit: BoxFit.fill, placeholder: const AssetImage("images/Boulevard.png"),),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 80,
                right: 10,

                child: GestureDetector(
                  onTap: (){widget.likeClick(widget.placeName,widget.imagePath[0]);
                    },
                  child: Container(
                      width: 28,
                      height: 26,

                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100)
                      ),
                      child: Center(child: ImageIcon(AssetImage(session.favourite.contains(widget.placeName)?'images/redheart.png':'images/heart.png'),size: 22,color: session.favourite.contains(widget.placeName)?Colors.red:Colors.black,))),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 5,
                child: Text(widget.placeName,style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
              )


            ]),
      ),
    );
  }
}
