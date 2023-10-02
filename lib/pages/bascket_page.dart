import 'package:badges/badges.dart' as Bge;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scroll_page_view/pager/page_controller.dart';
import 'package:store/tools/buttons.dart';
import 'package:store/tools/products_cards.dart';

import '../database/auth/user_auth.dart';
import '../database/firestore/firestore.dart';
import '../tools/PageTransaction.dart';
import '../tools/colors.dart';
import 'product_page.dart';

class BascketPage extends StatefulWidget {
  const BascketPage({super.key});

  @override
  State<BascketPage> createState() => _BascketPageState();
}

class _BascketPageState extends State<BascketPage> {

  //Insatances
  COLOR color = COLOR();

  //instances
  Auth AuthInstance = Auth();
  FireStore firestore = FireStore();

  //controllers
  final ScrollPageController _scrollController = ScrollPageController();
  final PageController _pageIndicatorController = PageController();


  //user info
  Map<String, dynamic> UserData = {};
  List BascketData = [];
  int BascketLength = 0;

  //getUserData
  GetUserData() async {
    FirebaseFirestore.instance.collection('users').doc(User().id).snapshots().listen((event) { 
      setState(() {
        UserData = event.data()!;
      });
    });
  }

  //get bascket info
  GetBascketProducts() async {
    FirebaseFirestore.instance.collection('users').doc(User().id).collection('bascket').snapshots().listen((event) { 
      setState(() {
        BascketData = event.docs.toList();
        BascketLength = event.docs.length;
      });
      print(BascketData[0].data());
      print(BascketLength);
    });
  }

  @override
  void initState() {
    super.initState();
    GetBascketProducts();
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
        title: Bge.Badge(
            badgeContent: Text(BascketLength.toString()),
            position: Bge.BadgePosition.topStart(),
            child: TextButton(
              onPressed: () {
                Navigator.push(context, PageTransaction(OrderPage(length: BascketLength, BascketItems: BascketData,UserData: UserData,Howmany: BascketLength, FinalPrice: '0',data: const {},)));
              }, 
              child: Text('السلة',style: TextStyle(color: color.White,fontFamily: 'H1',fontSize: height*0.022,fontWeight: FontWeight.bold),),
            ),
          ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: color.FirstColor,
        ),
        child: Container(
          padding: EdgeInsets.only(left: width*0.022,right: width*0.00,top: height*0.008,bottom: height*0.008),
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topRight: Radius.circular(height*0.05),topLeft: Radius.circular(height*0.05)),
            color: color.White,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(right: width*0.022),
              child: Column(
                children: [
                  //
                  MyHeightSpacer(height*0.03),
                  ProductsTitle(height, width, color, 'المنتجات التي أضفتها في سلة', () { 
                    Navigator.push(context, PageTransaction(OrderPage(length: BascketLength, BascketItems: BascketData,UserData: UserData,Howmany: BascketLength, FinalPrice: '0',data: const {},)));
                  }),

                  //
                  MyHeightSpacer(height*0.01),
            
                  //
                  SizedBox(height: height,child: BascketSlider(height, width, color, UserData),),
                ],
              ),
            ),
          ),
        )
      )
    );
  }
}