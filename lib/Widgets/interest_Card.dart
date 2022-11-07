
import 'package:flutter/material.dart';
class InterestCard extends StatelessWidget {


  InterestCard({required this.title,required this.color});
  final Color color;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      color: color,


      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        height: 110,
        width: 85,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15)
        ),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(
              color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}