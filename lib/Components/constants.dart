import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFFAABDA0);
Color? kBackgroundColor=Color(0xFFFFFEF6);
const kProgressIndicatorColor=Colors.black;
const kPinkColor=Color(0xFFE3B3B3);
const kBodyColor=Color(0xFFBDBDBD);

InputDecoration kTextFieldDecoration=const InputDecoration(
  hintText: 'Enter Value',
  filled: true,
  fillColor: Colors.white,
  contentPadding:

  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color: kPrimaryColor, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color: kPrimaryColor, width: 3.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);


Widget customInputText(TextEditingController controller, String hint,
    TextInputType type, Icon icon) {
  return TextField(
    controller: controller,
    keyboardType: type,
    textAlign: TextAlign.center,
    decoration:
    kTextFieldDecoration.copyWith(hintText: hint, prefixIcon: icon,),
  );
}

Widget customPasswordInputText(TextEditingController controller, String hint,
    TextInputType type, bool obscure, Icon prefix, IconButton suffix) {
  return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: type,
      textAlign: TextAlign.center,
      decoration: kTextFieldDecoration.copyWith(
          hintText: hint, prefixIcon: prefix, suffixIcon: suffix));
}
