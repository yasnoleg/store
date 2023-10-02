import 'package:flutter/material.dart';
import 'package:store/tools/buttons.dart';
import 'package:store/tools/colors.dart';

class onBoarding extends StatelessWidget { 
  VoidCallback onTap;
  onBoarding({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    //instances
    COLOR color = COLOR();

    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('asset/images/coffee_wallpaper.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const Expanded(
              child: SizedBox(height: 1,),
            ),

            //
            Text('Its Great day for Coffee',style: TextStyle(color: color.White,fontSize: height*0.026,fontFamily: 'H1',fontWeight: FontWeight.bold),maxLines: 2,),

            SizedBox(height: height*0.03,),

            //
            Text('The best grain, the finest coffee, the powerful flavor',style: TextStyle(color: color.White,fontSize: height*0.016,fontFamily: 'TEXT',fontWeight: FontWeight.w300),maxLines: 2,),

            SizedBox(height: height*0.1,),

            //button
            MyButton(
              height, 
              width*0.7, 
              color.FirstColor, 
              'GET STARTED', 
              color.White,
              onTap,
            ),

            SizedBox(height: height*0.06,),
          ],
        ),
      ),
    );
  }
}