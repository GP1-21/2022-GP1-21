import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFFAABDA0);
Color? kBackgroundColor=Colors.grey[300];
const kProgressIndicatorColor=Colors.black;
const kPinkColor=Color(0xFFD97C7C);

const kBodyColor=Color(0xFFBDBDBD);


TextStyle kTextStyle= const TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.black);
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
InputDecoration kTextField2Decoration=InputDecoration(
  hintText: 'Enter Value',
  filled: true,
  fillColor: Colors.white,
  contentPadding:

  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.circular(15),
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
