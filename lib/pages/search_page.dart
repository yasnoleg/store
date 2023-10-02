import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scroll_page_view/pager/page_controller.dart';
import 'package:store/pages/all_typeOfproduct.dart';
import 'package:store/tools/buttons.dart';
import 'package:store/tools/products_cards.dart';

import '../database/auth/user_auth.dart';
import '../tools/PageTransaction.dart';
import '../tools/colors.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {


  //instances
  Auth AuthInstance = Auth();
  COLOR color = COLOR();

  //controllers
  final ScrollPageController _scrollController = ScrollPageController();
  final PageController _pageIndicatorController = PageController();

  //user info
  Map<String, dynamic> UserData = {};
  
  //getUserData
  GetUserData() async {
    FirebaseFirestore.instance.collection('users').doc(User().id).snapshots().listen((event) { 
      setState(() {
        UserData = event.data()!;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    GetUserData();
  }

  @override
  Widget build(BuildContext context) {
    //Sizes
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double spaceHeight = height*0.01;
    double spaceWidth = width*0.02;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color.FirstColor,
        elevation: 0,
        toolbarHeight: height*0.12,
        title: Image.asset('asset/logo/20230925_182047.png',height: height*0.05,),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: color.FirstColor,
        ),
        child: Container(
          padding: EdgeInsets.only(left: width*0.015,right: width*0.015,top: height*0.008,bottom: height*0.008),
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topRight: Radius.circular(height*0.05),topLeft: Radius.circular(height*0.05)),
            color: color.White,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(height*0.05),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              child: Column(
                children: [
                  //القهوة
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: MyDivider(color)),
                      Text('القهوة',style: TextStyle(color: color.FirstColor,fontFamily: 'TEXT', fontWeight: FontWeight.w100, fontSize: height*0.02),),
                      Expanded(child: MyDivider(color)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ProductTypeButton(height, width, color, 'فلتر', () {
                        Navigator.push(context, PageTransaction(
                          AllTypeOfProcut(
                            UserData: UserData,
                            type: 'فلتر',
                          )
                        ));
                      }),
                      ProductTypeButton(height, width, color, 'اكسبريسو', () {
                        Navigator.push(context, PageTransaction(
                          AllTypeOfProcut(
                            UserData: UserData,
                            type: 'اكسبريسو',
                          )
                        ));
                      }),
                    ],
                  ),

                  //
                  MyHeightSpacer(height*0.02),

                  //الأدوات
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: MyDivider(color)),
                      Text('الأدوات',style: TextStyle(color: color.FirstColor,fontFamily: 'TEXT', fontWeight: FontWeight.w100, fontSize: height*0.02,),),
                      Expanded(child: MyDivider(color)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ProductTypeButton(height, width, color, 'مستلزمات التنظيف', () {
                        Navigator.push(context, PageTransaction(
                          AllTypeOfProcut(
                            UserData: UserData,
                            type: 'مستلزمات التنظيف',
                          )
                        ));
                      }),
                      ProductTypeButton(height, width, color, 'فلاتر', () {
                        Navigator.push(context, PageTransaction(
                          AllTypeOfProcut(
                            UserData: UserData,
                            type: 'فلاتر',
                          )
                        ));
                      }),
                      ProductTypeButton(height, width, color, 'الأكواب', () {
                        Navigator.push(context, PageTransaction(
                          AllTypeOfProcut(
                            UserData: UserData,
                            type: 'اكواب',
                          )
                        ));
                      }),
                    ],
                  ),

                  //
                  MyHeightSpacer(height*0.02),

                  //الأدوات
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: MyDivider(color)),
                      Text('الآلات',style: TextStyle(color: color.FirstColor,fontFamily: 'TEXT', fontWeight: FontWeight.w100, fontSize: height*0.02,),),
                      Expanded(child: MyDivider(color)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ProductTypeButton(height, width, color, 'مكينات القهوة', () {
                        Navigator.push(context, PageTransaction(
                          AllTypeOfProcut(
                            UserData: UserData,
                            type: 'مكينة قهوة',
                          )
                        ));
                      }),
                    ],
                  ),

                  //
                  MyHeightSpacer(height*0.025),

                  //
                  MyDivider(color),

                  //
                  MyHeightSpacer(height*0.012),

                  //
                  ProductsTitle(height, width, color, 'فلاتر', () {
                    Navigator.push(context, PageTransaction(
                          AllTypeOfProcut(
                            UserData: UserData,
                            type: 'فلاتر',
                          )
                        ));
                  }),
                  ProductSlider(height, width, color, 'product', 'فلاتر', UserData),

                  //
                  MyHeightSpacer(height*0.012),

                  //
                  ProductsTitle(height, width, color, 'مستلزمات التنظيف', () {
                    Navigator.push(context, PageTransaction(
                          AllTypeOfProcut(
                            UserData: UserData,
                            type: 'مستلزمات التنظيف',
                          )
                        ));
                  }),
                  ProductSlider(height, width, color, 'product', 'مستلزمات التنظيف', UserData),

                  //
                  MyHeightSpacer(height*0.012),

                  //
                  ProductsTitle(height, width, color, 'اكواب', () {
                    Navigator.push(context, PageTransaction(
                          AllTypeOfProcut(
                            UserData: UserData,
                            type: 'اكواب',
                          )
                        ));
                  }),
                  ProductSlider(height, width, color, 'product', 'اكواب', UserData),

                  //
                  MyHeightSpacer(height*0.012),

                  //
                  ProductsTitle(height, width, color, 'مكينة قهوة', () {
                    Navigator.push(context, PageTransaction(
                          AllTypeOfProcut(
                            UserData: UserData,
                            type: 'مكينة قهوة',
                          )
                        ));
                  }),
                  ProductSlider(height, width, color, 'product', 'مكينة قهوة', UserData),

                  //
                  MyHeightSpacer(height*0.012),
                ],
              ),
            ),
          ),
        )
      )
    );
  }
}