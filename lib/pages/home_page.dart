import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:scroll_page_view/scroll_page.dart';
import 'package:store/tools/banners.dart';
import 'package:store/tools/buttons.dart';
import 'package:store/tools/colors.dart';

import '../database/auth/user_auth.dart';
import '../tools/PageTransaction.dart';
import '../tools/products_cards.dart';
import 'product_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


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
        title: GestureDetector(
          onTap: () {
            AuthInstance.SignOut();
          },
          child: Image.asset('asset/logo/20230925_182047.png',height: height*0.05,)
        ),
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
            borderRadius: BorderRadius.only(topRight: Radius.circular(height*0.05), topLeft: Radius.circular(height*0.05)),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(height*0.05),
                child: Column(
                  children: [
                    //الاعلانات
                    SizedBox(
                      height: height*0.2,
                      width: width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(height*0.03),
                        child: ScrollPageView(
                          scrollDirection: Axis.horizontal,
                          controller: _scrollController,
                          checkedIndicatorColor: color.FirstColor,
                          children: [
                            Image.network('https://i.pinimg.com/564x/4f/f3/7c/4ff37c89df5123f84ea3428f584cc533.jpg',fit: BoxFit.cover,height: width,width: width,),
                            Image.network('https://i.pinimg.com/564x/42/43/63/4243633363aa59ced35b082ba5670289.jpg',fit: BoxFit.cover,height: width,width: width,),
                          ],
                        ),
                      ),
                    ),
                        
                    //space
                    SizedBox(
                      height: spaceHeight,
                    ),
                        
                    //قهوة فلتر----------------------------------------------------------------------------------------------------------
                    //عنوان
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AccessButton(
                          height, 
                          color,
                          () {},
                        ),
                        Expanded(child: Divider(color: color.FirstColor,)),
                        SizedBox(width: width*0.02,),
                        Container(
                          alignment: Alignment.center,
                          height: height*0.04,
                          width: width*0.2,
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
                          child: Text('قهوة فلتر',style: TextStyle(color: color.FirstColor,fontFamily: 'TEXT',fontSize: height*0.018),),
                        ),
                      ],
                    ),
                    //Products
                    SizedBox(
                      height: height*0.42,
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('filter').snapshots(),
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
                    ),
                    //-------------------------------------------------------------------------------------------------------------------------
                        
                    //small banner
                    SmallBanner(height, width, 'https://i.pinimg.com/564x/a5/f0/e4/a5f0e45f6928dfe4096b0a382d134657.jpg'),

                    //اسبريسو----------------------------------------------------------------------------------------------------------
                    //عنوان
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AccessButton(
                          height, 
                          color,
                          () {},
                        ),
                        Expanded(child: Divider(color: color.FirstColor,)),
                        SizedBox(width: width*0.02,),
                        Container(
                          alignment: Alignment.center,
                          height: height*0.04,
                          width: width*0.2,
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
                          child: Text('اسبريسو',style: TextStyle(color: color.FirstColor,fontFamily: 'TEXT',fontSize: height*0.018),),
                        ),
                      ],
                    ),
                    //Products
                    SizedBox(
                      height: height*0.42,
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('espresso').snapshots(),
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
                                         ProductCard(index, data?[index].data(), color,height,width, () {Navigator.push(context, PageTransaction(ProductPage(data: data![index*2].data(), UserData: UserData,)));}),
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
                    ),
                    //-------------------------------------------------------------------------------------------------------------------------
          

                    //الأدوات---------------------------------------------------------------------------------------------------------
                    //عنوان
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AccessButton(
                          height, 
                          color,
                          () {},
                        ),
                        Expanded(child: Divider(color: color.FirstColor,)),
                        SizedBox(width: width*0.02,),
                        Container(
                          alignment: Alignment.center,
                          height: height*0.04,
                          width: width*0.2,
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
                          child: Text('الأكواب',style: TextStyle(color: color.FirstColor,fontFamily: 'TEXT',fontSize: height*0.018),),
                        ),
                      ],
                    ),
                    //Products
                    SizedBox(
                      height: height*0.42,
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('products').where('type', isEqualTo: 'اكواب').snapshots(),
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
                                         ProductCard(index, data?[index].data(), color,height,width, () {Navigator.push(context, PageTransaction(ProductPage(data: data![index*2].data(), UserData: UserData,)));}),
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
                    ),
                    //-------------------------------------------------------------------------------------------------------------------------
          
          
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}