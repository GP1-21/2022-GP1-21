import 'package:flutter/material.dart';
import 'package:huna_ksa/Components/constants.dart';
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
      child: Container(
        height: 120,
        width: MediaQuery.of(context).size.width*.70,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(25)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 90,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20), // Image border
                child: SizedBox.fromSize(
                  //size: Size.fromWidth(height), // Image radius
                  child: Image(image:AssetImage(widget.imagePath,), fit: BoxFit.cover),
                ),
              ),
            ),
            Text(widget.cityName,style: const TextStyle(fontSize: 22,fontWeight: FontWeight.bold),)
          ],
        ),
      ),
    );
  }
}
