import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:store/database/auth/user_auth.dart';

import '../pages/product_page.dart';
import 'PageTransaction.dart';
import 'buttons.dart';
import 'colors.dart';

//products card
ProductCard(int index, Map<String, dynamic>? data, COLOR color, double height, double width, VoidCallback onTap) {
  return Padding(
    padding: EdgeInsets.only(right: width*0.02,left: width*0.02,top: height*0.01,bottom: height*0.03),
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(height*0.01),
        alignment: Alignment.centerRight,
        height: height*0.42,
        width: width*0.42,
        decoration: BoxDecoration(
          color: color.SecondColor,
          borderRadius: BorderRadius.circular(height*0.01),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Image.network(data!['pictureUrl'],height: height*0.17,width: width*0.42,fit: BoxFit.cover,),
            Text(data['name'],style: TextStyle(color: color.White,fontFamily: 'TEXT',fontSize: height*0.021,fontWeight: FontWeight.w600),maxLines: data['type'] == 'اكواب' ? 1 : 2,overflow: TextOverflow.fade),
            data['type'] == 'اكواب' || data['type'] == 'فلاتر' || data['type'] == 'مستلزمات التنظيف' || data['type'] == 'مكينة قهوة' ? Text('${data['bio']}',style: TextStyle(color: color.White,fontFamily: 'TEXT',fontSize: height*0.015,fontWeight: FontWeight.w300),maxLines: 2,overflow: TextOverflow.fade) : Text('السلالة : ${data['السلالة']}',style: TextStyle(color: color.White,fontFamily: 'TEXT',fontSize: height*0.015,fontWeight: FontWeight.w300),),
            const Expanded(child: SizedBox(height: 1,),),
            const Divider(),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(height*0.008),
                  decoration: BoxDecoration(
                    color: color.ThirdColor,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(height*0.01)),
                  ),
                  width: width*0.1,
                  height: height*0.06,
                  child: Image.asset('asset/icons/grocery-store.png',color: color.White,),
                ),
                const Expanded(child: SizedBox(width: 1,)),
                Text('${data['price']}',style: TextStyle(color: color.ThirdColor,fontFamily: 'TEXT',fontSize: height*0.02,fontWeight: FontWeight.w600),),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

ProductSlider(double height, double width, COLOR color, String collection, String ProType, Map<String, dynamic> UserData) {
  return SizedBox(
    height: height*0.42,
    child: StreamBuilder(
      stream: ProType == 'اكواب' || ProType == 'فلاتر' || ProType == 'مكينة قهوة' || ProType == 'مستلزمات التنظيف' ? FirebaseFirestore.instance.collection('products').where('type', isEqualTo: ProType).snapshots() : FirebaseFirestore.instance.collection(collection).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Lottie.asset('asset/animations/LLoading.json'),
          );
        } else {
          return Swiper(
            loop: false,
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            itemBuilder: (context, index) {
              final data = snapshot.data?.docs.toList();
              if ((snapshot.data!.docs.length)%2 == 0) {
                 return Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     ProductCard(index, data?[index*2].data(), color,height,width, () {Navigator.push(context, PageTransaction(ProductPage(data: data![index*2].data(), UserData: UserData,)));}),
                     ProductCard(index, data?[(index*2)+1].data(), color,height,width, () {Navigator.push(context, PageTransaction(ProductPage(data: data![index*2+1].data(), UserData: UserData,)));}),
                   ],
                 );
              } else {
                if (index == (snapshot.data!.docs.length)~/2) {
                   return Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                       ProductCard(index, data?[index*2].data(), color,height,width, () {Navigator.push(context, PageTransaction(ProductPage(data: data![index*2].data(), UserData: UserData,)));}),
                     ],
                   );
                } else {
                  return Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                       ProductCard(index, data?[index*2].data(), color,height,width, () {Navigator.push(context, PageTransaction(ProductPage(data: data![index*2].data(), UserData: UserData,)));}),
                       ProductCard(index, data?[(index*2)+1].data(), color,height,width, () {Navigator.push(context, PageTransaction(ProductPage(data: data![index*2+1].data(), UserData: UserData,)));}),
                     ],
                   );
                }
              }
            },
            itemCount: snapshot.connectionState == ConnectionState.waiting ? 0 : (snapshot.data!.docs.length)%2 == 0 ? (snapshot.data!.docs.length)~/2 : (((snapshot.data!.docs.length)/2)+1).toInt(),
          );
        }
      }
    ),
  );
}

ProductsTitle(double height, double width, COLOR color, String title, VoidCallback onTap) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      AccessButton(
        height, 
        color,
        onTap,
      ),
      Expanded(child: Divider(color: color.FirstColor,)),
      SizedBox(width: width*0.02,),
      Container(
        alignment: Alignment.center,
        height: height*0.04,
        width: title.length*(width*0.025),
        decoration: BoxDecoration(
          color: color.FourdColor,
          boxShadow: [
            BoxShadow(
              color: color.FirstColor,
              blurRadius: 0,
              spreadRadius: 0,
              offset: const Offset(2, 3)
            ),
          ],
          borderRadius: BorderRadius.only(topLeft: Radius.circular(height*0.02),bottomRight: Radius.circular(height*0.02)),
        ),
        child: Text(title,style: TextStyle(color: color.FirstColor,fontFamily: 'TEXT',fontSize: height*0.018),),
      ),
    ],
  );
}

AddComment(TextEditingController msg, double height, double width, COLOR color) {
  return TextField(
    controller: msg,
    decoration: InputDecoration(
      hintText: 'اضف رأيك',
      hintStyle: const TextStyle(color: Colors.black54),
      icon: ClipRRect(
        borderRadius: BorderRadius.circular(height),
        child: Image.asset('asset/logo/pfp.jpeg',height: height*0.05,width: height*0.05,),
      ),
      suffixIcon: MyButton(height*0.8, width*0.2, color.SecondColor, 'اضافة', color.FourdColor, () {}),
    ),
  );
}

BascketSlider(double height, double width, COLOR color, Map<String, dynamic> UserData) {
  return StreamBuilder(
    stream: FirebaseFirestore.instance.collection('users').doc(User().id).collection('bascket').snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Lottie.asset('asset/animations/LLoading.json',height: height*0.05);
      } else {
        if (snapshot.data!.docs.isEmpty) {
          return Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Lottie.asset('asset/animations/empty.json')
              ),
              Align(
                alignment: const Alignment(0,-0.2),
                child: Text('قم باضافة منتج الى السلة', style: TextStyle(color: Colors.white.withOpacity(0.7),fontFamily: 'H1',fontSize: height*0.018),),
              ),
            ],
          );
        } else {
          return ListView.builder(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final data = snapshot.data!.docs.toList()[index].data();
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, PageTransaction(OrderPage(Howmany: data['quantity'],FinalPrice: data['price'].toString(),data: data['product info'],UserData: UserData,)));
                },
                child: ProductBascket(data['quantity'], data['price'], data['product info'], height, width, color),
              );
            },
          );
        }
      }
    },
  );
}


ProductBascket(int quantity, double price, Map<String, dynamic> productInfo, double height, double width, COLOR color) {
  return Padding(
    padding: EdgeInsets.only(top: height*0.015,bottom: height*0.015),
    child: Container(
      padding: EdgeInsets.only(right: width*0.025),
      height: height*0.12,
      width: width,
      decoration: BoxDecoration(
        color: color.SecondColor,
        borderRadius: BorderRadius.circular(height*0.03),
      ),
      child: Row(
        children: [
          //
          ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(height*0.03),bottomLeft: Radius.circular(height*0.03)),
            child: Image.network(productInfo['pictureUrl'],height: height*0.12,width: width*0.25,fit: BoxFit.cover,),
          ),

          //
          MyExpanded(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              //
              SizedBox(width: width*0.6,child: Row(
                children: [
                  Expanded(child: SingleChildScrollView(scrollDirection: Axis.horizontal,child: Text(productInfo['name'],style: TextStyle(color: color.FourdColor,fontFamily: 'TEXT',fontSize: height*0.019,fontWeight: FontWeight.bold,),overflow: TextOverflow.fade))),
                ],
              )),

              //
              Text('الكمية : $quantity',style: TextStyle(color: color.FourdColor,fontFamily: 'TEXT',fontSize: height*0.015,fontWeight: FontWeight.w300,),),
              Text('الثمن : $price رس',style: TextStyle(color: color.FourdColor,fontFamily: 'TEXT',fontSize: height*0.015,fontWeight: FontWeight.w300,),),
            ],
          ),
        ],
      ),
    ),
  );
}


MyCard(double ScreenHeight, double height, double width, COLOR color, Widget child, AlignmentGeometry Alignment) {
  return Container(
    alignment: Alignment,
    padding: EdgeInsets.only(right: width*0.02,left: width*0.00,top: height*0.008),
    height: height,
    width: width,
    decoration: BoxDecoration(
      color: color.FourdColor,
      borderRadius: BorderRadius.circular(ScreenHeight*0.015),
      boxShadow: const [
        BoxShadow(
          color: Colors.black26,
          spreadRadius: 0.5,
          blurRadius: 2,
          offset: Offset(1, 1)
        ),
      ],
    ),
    child: child,
  );
}