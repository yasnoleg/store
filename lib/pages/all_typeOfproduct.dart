import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:scroll_page_view/pager/page_controller.dart';
import 'package:store/tools/products_cards.dart';

import '../database/auth/user_auth.dart';
import '../database/firestore/firestore.dart';
import '../tools/PageTransaction.dart';
import '../tools/colors.dart';
import 'product_page.dart';

class AllTypeOfProcut extends StatefulWidget {
  AllTypeOfProcut({super.key, this.UserData, this.type});

  Map<String, dynamic>? UserData;
  String? type;

  @override
  State<AllTypeOfProcut> createState() => _AllTypeOfProcutState();
}

class _AllTypeOfProcutState extends State<AllTypeOfProcut> {

  //Insatances
  COLOR color = COLOR();

  //instances
  Auth AuthInstance = Auth();
  FireStore firestore = FireStore();

  //controllers
  final ScrollPageController _scrollController = ScrollPageController();
  final PageController _pageIndicatorController = PageController();

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
        title: GestureDetector(
          onTap: () {
            AuthInstance.SignOut();
          },
          child: Text(widget.type!,style: TextStyle(color: color.White,fontFamily: 'H1',fontSize: height*0.022,fontWeight: FontWeight.bold),),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          }, 
          icon: const Icon(Icons.arrow_back_ios_outlined),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: color.FirstColor,
        ),
        child: Container(
          padding: EdgeInsets.only(left: width*0.022,right: width*0.022,top: height*0.008,bottom: height*0.008),
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topRight: Radius.circular(height*0.05),topLeft: Radius.circular(height*0.05)),
            color: color.White,
          ),
          child:  StreamBuilder(
            stream: widget.type == 'اكواب' ? FirebaseFirestore.instance.collection('products').where('type', isEqualTo: 'اكواب').snapshots() : widget.type == 'فلاتر' ? FirebaseFirestore.instance.collection('products').where('type', isEqualTo: 'فلاتر').snapshots() : widget.type == 'مستلزمات التنظيف' ? FirebaseFirestore.instance.collection('products').where('type', isEqualTo: 'مستلزمات التنظيف').snapshots() : widget.type == 'مكينة قهوة' ? FirebaseFirestore.instance.collection('products').where('type', isEqualTo: 'مكينة قهوة').snapshots() : FirebaseFirestore.instance.collection(widget.type == 'فلتر' ? 'filter' : 'espresso').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Lottie.asset('asset/animations/LLoading.json');
              } else {
                return AnimationLimiter(
                  child: GridView.builder(
                    physics:const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    padding: EdgeInsets.all(width / 60),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.5
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index){
                      final data = snapshot.data!.docs.toList()[index].data();
                      return AnimationConfiguration.staggeredGrid(
                          position: index,
                          duration: const Duration(milliseconds: 500),
                          columnCount: 3,
                          child: ScaleAnimation(
                            duration: const Duration(milliseconds: 900),
                            curve: Curves.fastLinearToSlowEaseIn,
                            child: FadeInAnimation(
                              child: ProductCard(
                                index, 
                                data, 
                                color, 
                                height, 
                                width, 
                                () {
                                  Navigator.push(context, PageTransaction(ProductPage(data: data, UserData: widget.UserData,)));
                                },
                              ),
                            ),
                          ),
                        );
                      }
                  ),
                );
              }
            }
          ),
        )
      )
    );
  }
}