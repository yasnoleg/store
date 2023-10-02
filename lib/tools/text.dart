import 'package:flutter/material.dart';

import 'colors.dart';

MyTitle(String title, COLOR color, double height) {
  return Text(title, style: TextStyle(color: color.FirstColor,fontFamily: 'H1',fontSize: height*0.026,fontWeight: FontWeight.w800),);
}

MyTextField(TextEditingController controller, double height, COLOR color, String hitText, String lableText, String type) {
  return Padding(
    padding: EdgeInsets.only(top: height*0.01,bottom: height*0.01),
    child: TextField(
      controller: controller,
      keyboardType: type == 'text' ? TextInputType.text : type == 'number' ? TextInputType.number : TextInputType.emailAddress,
      obscureText: type == 'password' ? true : false,
      decoration: InputDecoration(
        hintText: hitText,
        labelText: lableText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: color.SecondColor,width: 1),
          borderRadius: BorderRadius.circular(height*0.025),
        ),
      ),
    ),
  );
}