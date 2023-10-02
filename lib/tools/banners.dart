import 'package:flutter/material.dart';

SmallBanner(double ScreenHeight, double ScreenWidth, String Url) {
  return Padding(
    padding: EdgeInsets.only(bottom: ScreenHeight*0.015),
    child: SizedBox(
      height: ScreenHeight*0.12,
      width: ScreenWidth,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ScreenHeight*0.03),
        child: Image.network(Url,fit: BoxFit.cover,),
      ),
    ),
  );
}