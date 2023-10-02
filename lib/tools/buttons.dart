import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:store/tools/colors.dart';

MyButton(double ScreenHeight ,double Buttonwidth, HexColor ButtonColor, String Buttontext, Color TextColor, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      alignment: Alignment.center,
      height: ScreenHeight*0.07,
      width: Buttonwidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ScreenHeight*0.02),
        color: ButtonColor,
      ),
      child: Text(Buttontext, style: TextStyle(color: TextColor, fontFamily: 'TEXT', fontSize: ScreenHeight*0.02,fontWeight: FontWeight.w500),),
    ),
  );
}

AccessButton(double height, COLOR color, VoidCallback onTap) {
  return Padding(
    padding: EdgeInsets.only(right: height*0.012),
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: height*0.04,
        width: height*0.04,
        decoration: BoxDecoration(
          color: color.FourdColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.FirstColor,
              spreadRadius: 0,
              blurRadius: 0,
              offset: const Offset(1, 2)
            ),
          ]
        ),
        child: Icon(Icons.arrow_back_ios_new_outlined, color: color.FirstColor, size: height*0.022,),
      ),
    ),
  );
}

ProductTypeButton(double height, double width, COLOR color, String Buttontext, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      alignment: Alignment.center,
      height: height*0.035,
      width: Buttontext.length*(width*0.03),
      decoration: BoxDecoration(
        color: color.FourdColor,
        borderRadius: BorderRadius.circular(height*0.02),
        boxShadow: [
          BoxShadow(
            color: color.FirstColor,
            spreadRadius: 0,
            blurRadius: 0,
            offset: const Offset(1, 2),
          ),
        ],
      ),
      child: Text(Buttontext,style: TextStyle(color: color.FirstColor,fontFamily: 'TEXT', fontStyle: FontStyle.italic, fontSize: height*0.018,),),
    ),
  );
}

MyDivider(COLOR color) {
  return Container(
    height: 0.3,
    decoration: BoxDecoration(
      color: color.FirstColor,
      borderRadius: BorderRadius.circular(50),
    ),
  );
}

MyExpanded() {
  return const Expanded(child: SizedBox(width: 1,));
}

MyHeightSpacer(double height) {
  return SizedBox(height: height);
}

MyWidthSpacer(double width) {
  return SizedBox(width: width,);
}