import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';
import 'package:scroll_page_view/pager/page_controller.dart';
import 'package:store/pages/transactions.dart';
import 'package:store/tools/buttons.dart';
import 'package:store/tools/products_cards.dart';

import '../database/auth/user_auth.dart';
import '../database/firestore/firestore.dart';
import '../location/locationServices.dart';
import '../tools/PageTransaction.dart';
import '../tools/colors.dart';
import 'product_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

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

  double _latitude = 0;
  double _longitude = 0;
  late LocationData _locatioDT;
  LocationService locationservice = LocationService();
  List<Placemark>? placemark;
  String adr = '';

  //
  FindUserLocation() async {
    _locatioDT = await locationservice.GetUserLocation();
    setState(() {
      _latitude = _locatioDT.latitude!;
      _longitude = _locatioDT.longitude!;
    });
    final Placemark = await placemarkFromCoordinates(_latitude, _longitude);
    setState(() {
      placemark = Placemark;
      adr = '${placemark![0].country},${placemark![0].administrativeArea},${placemark![0].locality},${placemark![0].street}';
    });
    print(placemark);
  }


  @override
  void initState() {
    super.initState();
    
    FindUserLocation();
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
            AuthInstance.SignOut();
          }, 
          icon: const Icon(Icons.logout_outlined),
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
                child: Column(
                  children: [
                    //
                    MyHeightSpacer(height*0.03),
                    MyCard(
                      height, 
                      height*0.2, 
                      width, 
                      color, 
                      Column(
                        children: [
                          //
                          ClipRRect(
                            borderRadius: BorderRadius.circular(height),
                            child: Image.asset('asset/logo/pfp.jpeg',height: height*0.1,width: height*0.1,fit: BoxFit.cover,),
                          ),

                          //
                          Text('الاسم : ${User().username!}',style: TextStyle(color: Colors.black45,fontFamily: 'TEXT',fontSize: height*0.02),),

                          //
                          Text('ايميل : ${User().email!}',style: TextStyle(color: Colors.black45,fontFamily: 'TEXT',fontSize: height*0.02),),

                          //
                          Text('(+966) ${UserData.isEmpty ? '' : '${UserData['phoneNumber']}'} : رقم الهاتف' ,style: TextStyle(color: Colors.black45,fontFamily: 'TEXT',fontSize: height*0.02),),
                        ],
                      ),
                      Alignment.center
                    ),
          
          
          
                    //
                    MyHeightSpacer(height*0.02),
                    MyCard(
                      height, 
                      height*0.289, 
                      width, 
                      color, 
                      StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('users').doc(User().id).collection('fav').snapshots(),
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
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(' : المفضلات',style: TextStyle(color: color.FirstColor,fontFamily: 'H1',fontSize: height*0.025),),
                                  SizedBox(
                                    height: height*0.23,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        final data = snapshot.data!.docs.toList()[index].data();
                                        return Padding(
                                          padding: EdgeInsets.only(right: width*0.01,left: width*0.01,top: height*0.01,bottom: height*0.01),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(context, PageTransaction(ProductPage(data: data, UserData: UserData,)));
                                            },
                                            child: Container(
                                              height: height*0.13,
                                              width: width*0.4,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(height*0.02),
                                                color: color.SecondColor,
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  //
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.only(topRight: Radius.circular(height*0.02),topLeft: Radius.circular(height*0.02)),
                                                    child: Image.network(data['pictureUrl'],height: height*0.13,width: width*0.4,fit: BoxFit.cover,),
                                                  ),

                                                  //
                                                  Row(
                                                    children: [
                                                      MyWidthSpacer(width*0.02),
                                                      Expanded(child: SingleChildScrollView(scrollDirection: Axis.horizontal,child: Text(data['name'],style: TextStyle(color: color.FourdColor,fontFamily: 'TEXT',fontSize: height*0.02),maxLines: 2,overflow: TextOverflow.ellipsis,))),
                                                      MyWidthSpacer(width*0.02),
                                                    ],
                                                  ),

                                                  //
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      MyWidthSpacer(width*0.02),
                                                      Text('الثمن : ' + data['price'],style: TextStyle(color: color.FourdColor,fontFamily: 'TEXT',fontSize: height*0.017),maxLines: 2,overflow: TextOverflow.ellipsis,),
                                                      MyWidthSpacer(width*0.02),
                                                    ],
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }
                          }
                        }
                      ), 
                      Alignment.center,
                    ),
          
          
          
                    //
                    MyHeightSpacer(height*0.02),
                    MyCard(
                      height, 
                      height*0.12, 
                      width, 
                      color, 
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(onPressed: () {
                                //add location
                                FindUserLocation();
                              }, icon: const Icon(Icons.edit_location_alt_outlined,),iconSize: height*0.023,color: Colors.black45,),
                              MyExpanded(),
                              Text(' : عنوان التوصيل',style: TextStyle(color: color.SecondColor,fontFamily: 'TEXT',fontSize: height*0.02,fontWeight: FontWeight.bold),),
                            ],
                          ),
                          //
                          MyHeightSpacer(height*0.01),
                          placemark == null ? Text('اسمح لنا بالوصول لموقعك ',style: TextStyle(color: Colors.black38,fontFamily: 'TEXT',fontSize: height*0.017,fontWeight: FontWeight.w100),overflow: TextOverflow.fade) : Text('${placemark![0].country},${placemark![0].administrativeArea},${placemark![0].locality},${placemark![0].street}',style: TextStyle(color: Colors.black38,fontFamily: 'TEXT',fontSize: height*0.017,fontWeight: FontWeight.w100),overflow: TextOverflow.fade),
                        ],
                      ),
                      Alignment.topRight,
                    ),

         
                    //
                    MyHeightSpacer(height*0.02),
                    MyCard(
                      height, 
                      height*0.295, 
                      width, 
                      color, 
                      StreamBuilder(
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
                              return Padding(
                                padding: EdgeInsets.only(left: width*0.02),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(onPressed: () {
                                          Navigator.push(context, PageTransaction(PaymentTransactions()));
                                        }, icon: Icon(Icons.arrow_back_ios_new_outlined,size: height*0.015,)),
                                        MyExpanded(),
                                        Text(' : التحويلات',style: TextStyle(color: color.FirstColor,fontFamily: 'H1',fontSize: height*0.025),),
                                      ],
                                    ),
                                    SizedBox(
                                      height: height*0.23,
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
                                    ),
                                  ],
                                ),
                              );
                            }
                          }
                        }
                      ), 
                      Alignment.center,
                    ),
          

                  ],
                ),
              ),
            ),
          ),
        )
      )
    );
  }
}