import 'package:flutter/material.dart';
class CityCard extends StatefulWidget {
CityCard({required this.imagePath,required this.cityName});

final imagePath;
final cityName;
  @override
  State<CityCard> createState() => _CityCardState();
}

class _CityCardState extends State<CityCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:15),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          SizedBox(height: 130,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20), // Image border
              child: SizedBox.fromSize(
                //size: Size.fromWidth(height), // Image radius
                child: Image(image:AssetImage(widget.imagePath,), fit: BoxFit.cover),
              ),
            ),
          ),
          Text(widget.cityName,style: const TextStyle(fontSize: 32,fontWeight: FontWeight.bold,color: Colors.white),)
        ],
      ),
    );
  }
}
