import 'package:flutter/material.dart';
class RoundedButton extends StatelessWidget {


  RoundedButton({this.horizontal=50.0,this.decuration=TextDecoration.none,required this.title,required this.color,required this.onPress,required this.textColor,required this.height,this.width=160});
  final Color color;
  final TextDecoration decuration;
  final double height;
  final Color textColor;
  final String title;
  double horizontal,width;
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
        elevation: 5.0,
        color: color,


        borderRadius: BorderRadius.circular(15.0),
        child: MaterialButton(

          onPressed: onPress,
          height: getHeight(height),
          minWidth: width,
          child: Text(
            title,
            style: TextStyle(decoration: decuration,
              color: textColor,fontSize: 18,fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}