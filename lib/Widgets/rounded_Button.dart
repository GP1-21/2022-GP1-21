import 'package:flutter/material.dart';
class RoundedButton extends StatelessWidget {


  RoundedButton({this.horizontal=50.0,required this.title,required this.color,required this.onPress,required this.textColor,required this.height, });
  final Color color;
  final double height;
  final Color textColor;
  final String title;
  double horizontal;
  final Function() onPress;
  double getHeight(double height)
  {
    if(height==0)
      {
        return 50;
      }else{
      return height;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal),
      child: Material(
        elevation: 7.0,
        color: color,




        borderRadius: BorderRadius.circular(25.0),
        child: MaterialButton(

          onPressed: onPress,
          height: getHeight(height),
          minWidth: 160,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,

            ),
          ),
        ),
      ),
    );
  }
}