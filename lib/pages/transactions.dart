import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:scroll_page_view/pager/page_controller.dart';

import '../database/auth/user_auth.dart';
import '../database/firestore/firestore.dart';
import '../tools/PageTransaction.dart';
import '../tools/buttons.dart';
import '../tools/colors.dart';
import '../tools/products_cards.dart';
import 'product_page.dart';

class PaymentTransactions extends StatefulWidget {
  const PaymentTransactions({super.key});

  @override
  State<PaymentTransactions> createState() => _PaymentTransactionsState();
}

class _PaymentTransactionsState extends State<PaymentTransactions> {

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
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          }, 
          icon: Icon(Icons.arrow_back_ios_new_outlined,size: height*0.025,),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: color.FirstColor,
        ),
        child: Container(
          padding: EdgeInsets.only(right: width*0.022, left: width*0.022,top: height*0.008,bottom: height*0.008),
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topRight: Radius.circular(height*0.05),topLeft: Radius.circular(height*0.05)),
            color: color.White,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(topRight: Radius.circular(height*0.05), topLeft: Radius.circular(height*0.05)),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('requests').where('client name', isEqualTo: User().username!).snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Lottie.asset('asset/animations/LLoading.json', height: height*0.2,width: height*0.2);
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
                                    child: Text('اختر منتج من محاصيلنا', style: TextStyle(color: Colors.white.withOpacity(0.7),fontFamily: 'H1',fontSize: height*0.014),),
                                  ),
                                ],
                              );
                            } else {
                              return SizedBox(
                                height: height,
                                child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index) {
                                          final data = snapshot.data!.docs.toList()[index].data();
                                          return Padding(
                                            padding: EdgeInsets.only(right: width*0.01,left: width*0.01,top: height*0.01,bottom: height*0.01),
                                            child: GestureDetector(
                                              child: Container(
                                                padding: EdgeInsets.only(right: width*0.02,left: width*0.02),
                                                height: height*0.2,
                                                width: width*0.89,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(height*0.015),
                                                  color: color.SecondColor,
                                                ),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    //
                                                    Row(
                                                      children: [
                                                        MyExpanded(),
                                                        data['done'] == false ? Text('في الانتظار',style: TextStyle(color: color.FourdColor,fontFamily: 'H1',fontSize: height*0.02)) : Text('تمت العملية',style: TextStyle(color: color.FourdColor,fontFamily: 'H1',fontSize: height*0.02)),
                                                        MyWidthSpacer(width*0.02),
                                                        data['done'] == false ? Icon(Icons.timelapse_outlined, color: Color.fromARGB(255, 187, 3, 49),) : Icon(Icons.done, color: Color.fromARGB(255, 30, 233, 91),),
                                                      ],
                                                    ),
                              
                                                    //
                                                    data['done'] == false ? Text('يرجر الانتظار , طلبك سيصل في اي لحظة , فقط ابقي هاتفك بجنبك',style: TextStyle(color: color.FourdColor,fontFamily: 'TEXT',fontSize: height*0.014)) : Text('تم الرد على طلبك , اذا لم يصلك اي شيء قم بمراسلة الدعم',style: TextStyle(color: color.FourdColor,fontFamily: 'TEXT',fontSize: height*0.014)),
                              
                                                    //
                                                    Text('الثمن : ' + data['price'].toString(),style: TextStyle(color: color.FourdColor,fontFamily: 'TEXT',fontSize: height*0.018),maxLines: 2,overflow: TextOverflow.ellipsis,),
                                                    Text('عدد المنتجات : ' + data['quantity'].toString(),style: TextStyle(color: color.FourdColor,fontFamily: 'TEXT',fontSize: height*0.018),maxLines: 2,overflow: TextOverflow.ellipsis,),
                                                    Text('تاريخ الطلب : ' + data['date'].toString(),style: TextStyle(color: color.FourdColor,fontFamily: 'TEXT',fontSize: height*0.018),maxLines: 2,overflow: TextOverflow.ellipsis,),
                                                    Text('طريقة الدفع : ' + data['payment method'].toString(),style: TextStyle(color: color.FourdColor,fontFamily: 'TEXT',fontSize: height*0.018),maxLines: 2,overflow: TextOverflow.ellipsis,),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                              );
                            }
                          }
                        }
                      ), 
              )
            )
          )
        )
      )
    );
  }
}