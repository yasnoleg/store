import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';
import 'package:scroll_page_view/pager/page_controller.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:store/database/firestore/firestore.dart';
import 'package:store/tools/buttons.dart';
import 'package:store/tools/colors.dart';
import 'package:store/tools/products_cards.dart';

import '../database/auth/user_auth.dart';
import '../location/locationServices.dart';

class ProductPage extends StatefulWidget {
  ProductPage({super.key, this.data, required this.UserData});

  Map<String, dynamic>? data;
  Map<String, dynamic>? UserData;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  //Insatances
  COLOR color = COLOR();

  //instances
  Auth AuthInstance = Auth();
  FireStore firestore = FireStore();

  //controllers
  final ScrollPageController _scrollController = ScrollPageController();
  final PageController _pageIndicatorController = PageController();
  final TextEditingController _msgController = TextEditingController();

  //
  int HowMany = 1;
  bool liked = false;
  double HowMuch = 0;


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
          child: Image.asset('asset/logo/20230925_182047.png',height: height*0.05,),
        ),
        centerTitle: true,
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
          child: ClipRRect(
            borderRadius: BorderRadius.only(topRight: Radius.circular(height*0.05),topLeft: Radius.circular(height*0.05)),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [

                  //صورة المنتج
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(height*0.05), topLeft: Radius.circular(height*0.05)),
                        child: Image.network(widget.data!['pictureUrl'], height: height*0.42,width: width*0.95,fit: BoxFit.cover,)
                      ),
                    ],
                  ),

                  //النوع
                  MyHeightSpacer(height*0.015),
                  Row(
                    children: [
                      liked == false ? IconButton(
                        onPressed: () {
                          FireStore().AddToFav(widget.data!);
                          setState(() {
                            liked = true;
                          });
                        }, 
                        icon: Image.asset('asset/icons/like.png',height: height*0.02,width: height*0.02,),
                      ) : IconButton(
                        onPressed: () {
                          setState(() {
                            liked = false;
                          });
                        },
                        icon: Lottie.asset('asset/animations/like.json',height: height*0.08,width: height*0.08,repeat: false),
                      ),
                      MyExpanded(),
                      widget.data!['السلالة'] != null  ? Text(widget.data!['weight'].toString(),style: TextStyle(color:Colors.black54, fontFamily: 'TEXT', fontSize: height*0.017,fontWeight: FontWeight.w200),) : Text(widget.data!['type'],style: TextStyle(color: Colors.black45,fontFamily: 'TEXT',fontSize: height*0.02,fontWeight: FontWeight.w200, fontStyle: FontStyle.italic),),
                    ],
                  ),

                  //اسم المنتج
                  Text(widget.data!['name'],style: TextStyle(color: Colors.black,fontFamily: 'H1',fontSize: height*0.026,fontWeight: FontWeight.bold),),
                
                  //
                  MyHeightSpacer(height*0.015),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(widget.data!['price'],style: TextStyle(color: color.FirstColor, fontFamily: 'TEXT', fontSize: height*0.017,fontWeight: FontWeight.w300),),
                      Text(' : الثمن',style: TextStyle(color: color.FirstColor, fontFamily: 'TEXT', fontSize: height*0.02,fontWeight: FontWeight.bold),),
                    ],
                  ),
                
                  //
                  MyHeightSpacer(height*0.015),
                  widget.data!['السلالة'] != null  ? Text(': الاحاءات',style: TextStyle(color: color.FirstColor, fontFamily: 'TEXT', fontSize: height*0.02,fontWeight: FontWeight.bold),) : Text(': الوصف',style: TextStyle(color: color.FirstColor, fontFamily: 'TEXT', fontSize: height*0.02,fontWeight: FontWeight.bold),),
                  widget.data!['السلالة'] != null  ? Text(widget.data!['tags'].toString(),style: TextStyle(color:Colors.black54, fontFamily: 'TEXT', fontSize: height*0.017,fontWeight: FontWeight.w200),) : Text(widget.data!['bio'],style: TextStyle(color:Colors.black54, fontFamily: 'TEXT', fontSize: height*0.017,fontWeight: FontWeight.w200),),
                
                  //
                  MyHeightSpacer(height*0.015),
                  widget.data!['type'] == 'اكواب' ? Text(': عن المنتج',style: TextStyle(color: color.FirstColor, fontFamily: 'TEXT', fontSize: height*0.02,fontWeight: FontWeight.bold),) : Container(),
                  widget.data!['type'] == 'اكواب' ? Text('الحجم: ' + widget.data!['الحجم'],style: TextStyle(color:Colors.black54, fontFamily: 'TEXT', fontSize: height*0.017,fontWeight: FontWeight.w200),) : Container(),
                  widget.data!['type'] == 'اكواب' ? Text(widget.data!['السعة'] + ' : السعة ',style: TextStyle(color:Colors.black54, fontFamily: 'TEXT', fontSize: height*0.017,fontWeight: FontWeight.w200),) : Container(),
                  widget.data!['type'] == 'اكواب' ? Text('الوزن : ' +  widget.data!['الوزن'],style: TextStyle(color:Colors.black54, fontFamily: 'TEXT', fontSize: height*0.017,fontWeight: FontWeight.w200),) : Container(),

                  widget.data!['السلالة'] != null ? Text(': عن المنتج',style: TextStyle(color: color.FirstColor, fontFamily: 'TEXT', fontSize: height*0.02,fontWeight: FontWeight.bold),) : Container(),
                  widget.data!['السلالة'] != null? Text('السلالة : ' + widget.data!['السلالة'],style: TextStyle(color:Colors.black54, fontFamily: 'TEXT', fontSize: height*0.017,fontWeight: FontWeight.w200),) : Container(),
                  widget.data!['السلالة'] != null ? Text('المعالجة : ' + widget.data!['المعالجة'],style: TextStyle(color:Colors.black54, fontFamily: 'TEXT', fontSize: height*0.017,fontWeight: FontWeight.w200),) : Container(),
                  widget.data!['السلالة'] != null ? Text(widget.data!['الشركة'] + ' : الشركة',style: TextStyle(color:Colors.black54, fontFamily: 'TEXT', fontSize: height*0.017,fontWeight: FontWeight.w200),) : Container(),
                
                  //
                  MyHeightSpacer(height*0.02),
                  Container(
                    alignment: Alignment.center,
                    height: height*0.06,
                    width: width,
                    child: Container(
                      padding: EdgeInsets.all(height*0.003),
                      height: height*0.05,
                      width: width*0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(height*0.05),
                        color: color.FourdColor,
                      ),
                      child: Row(
                        children: [
                          IconButton(onPressed: () {
                            if (HowMany == 1) {
                              
                            } else {
                              setState(() {
                                HowMany = HowMany - 1;
                              });
                            }
                          }, icon: const Icon(Icons.remove)),
                          Text(HowMany.toString()),
                          IconButton(onPressed: () {
                            setState(() {
                              HowMany = HowMany + 1; 
                              HowMuch = (double.parse(widget.data!['price'].toString().split(' ')[0])*HowMany);
                            });
                          }, icon: const Icon(Icons.add)),
                          MyWidthSpacer(width*0.02),
                          Text('رس ${(double.parse(widget.data!['price'].toString().split(' ')[0])*HowMany)}'),
                          MyExpanded(),
                          Container(
                            alignment: Alignment.center,
                            height: height*0.049,
                            width: width*0.3,
                            decoration: BoxDecoration(
                              color: color.SecondColor,
                              borderRadius: BorderRadius.circular(height*0.05),
                            ),
                            child: GestureDetector(
                              onTap: () async {
                                //Navigator.push(context, PageTransaction(OrderPage(Howmany: HowMany,FinalPrice: (double.parse(widget.data!['price'].toString().split(' ')[0])*HowMany).toString(),data: widget.data,UserData: widget.UserData,)));
                                setState(() {
                                  HowMuch = (double.parse(widget.data!['price'].toString().split(' ')[0])*HowMany);
                                });
                                await FirebaseFirestore.instance.collection('users').doc(User().id).collection('bascket').add({
                                  'quantity': HowMany,
                                  'price': HowMuch,
                                  'product info': widget.data!,
                                }).catchError((e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      content: AwesomeSnackbarContent(
                                        title: 'حدث خطأ', 
                                        message: 'يرجى التأكد من اتصالك بالانترنيت', 
                                        contentType: ContentType.failure,
                                      ),
                                    )
                                  );
                                }).whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      content: AwesomeSnackbarContent(
                                        title: 'تم', 
                                        message: 'تم اضافة المنتج الى السلة بنجاح', 
                                        contentType: ContentType.success,
                                      ),
                                    )
                                  ));
                              },
                              child: Text('اضف',style: TextStyle(color: color.FourdColor,fontFamily: 'TEXT',fontSize: height*0.018),)
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  //

                ],
              ),
            ),
          ),
        ),
      ),
      //اذا اردتي اضافة خاصية التعليق 
      //bottomNavigationBar: Padding(
      //  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, right: width*0.02,left: width*0.02),
      //  child: AddComment(_msgController, height, width, color),
      //),
    );
  }
}


class OrderPage extends StatefulWidget {
  OrderPage({super.key, this.Howmany, this.FinalPrice, this.data, this.UserData, this.length, this.BascketItems});

  int? Howmany;
  String? FinalPrice;
  Map? data;
  Map<String, dynamic>? UserData;
  List? BascketItems;
  int? length;

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {

  //Insatances
  COLOR color = COLOR();

  //instances
  Auth AuthInstance = Auth();
  FireStore firestore = FireStore();

  //controllers
  final ScrollPageController _scrollController = ScrollPageController();
  final PageController _pageIndicatorController = PageController();

  //
  int selected = 0;
  String PaymentMethod = 'دفع الكتروني';
  double _latitude = 0;
  double _longitude = 0;
  late LocationData _locatioDT;
  LocationService locationservice = LocationService();
  List<Placemark>? placemark;
  String adr = '';
  double price = 0;


  //
  CalculateThePrice() {
    for (var element in widget.BascketItems!) {
      setState(() {
        price = price + element['price'];
      });
    }
  }

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
    //
    FindUserLocation();
    //
    Future.delayed(const Duration(seconds: 1), () {
      CalculateThePrice();
    });
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
          child: Text('تأكيد الطلب',style: TextStyle(color: color.White,fontFamily: 'H1',fontSize: height*0.022,fontWeight: FontWeight.bold),),
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
          child: ClipRRect(
            borderRadius: BorderRadius.only(topRight: Radius.circular(height*0.05), topLeft: Radius.circular(height*0.05)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    //
                    MyHeightSpacer(height*0.02),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: Divider(color: color.FirstColor,)),
                        SizedBox(width: width*0.02,),
                        Container(
                          alignment: Alignment.center,
                          height: height*0.04,
                          width: 10*(width*0.025),
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
                          child: Text('تأكيد الطلب',style: TextStyle(color: color.FirstColor,fontFamily: 'TEXT',fontSize: height*0.018),),
                        ),
                      ],
                    ),
            
            
                    //
                    MyHeightSpacer(height*0.015),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selected = 1;
                              PaymentMethod = 'الدفع عند الاستلام';
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: height*0.06,
                            width: width*0.4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(height*0.015),
                              color: selected == 1 ? color.SecondColor : color.FourdColor,
                              boxShadow: [
                                selected == 0 ? const BoxShadow(
                                  color: Colors.black26,
                                  spreadRadius: 0.5,
                                  blurRadius: 2,
                                  offset: Offset(1, 1)
                                ) : const BoxShadow(),
                              ]
                            ),
                            child: Text('الدفع عند الاستلام',style: TextStyle(color: selected == 1 ? color.FourdColor : color.SecondColor,fontFamily: 'TEXT',fontSize: height*0.02,fontWeight: FontWeight.bold),),
                          ),
                        ),
                        MyWidthSpacer(width*0.01),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selected = 0;
                              PaymentMethod = 'دفع الكتروني';
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: height*0.06,
                            width: width*0.4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(height*0.015),
                              color: selected == 0 ? color.SecondColor : color.FourdColor,
                              boxShadow: [
                                selected == 1 ? const BoxShadow(
                                  color: Colors.black26,
                                  spreadRadius: 0.5,
                                  blurRadius: 2,
                                  offset: Offset(1, 1)
                                ) : const BoxShadow(),
                              ]
                            ),
                            child: Text('دفع الكتروني',style: TextStyle(color: selected == 0 ? color.FourdColor : color.SecondColor,fontFamily: 'TEXT',fontSize: height*0.02,fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ],
                    ),
            
            
            
                    //
                    MyHeightSpacer(height*0.02),
                    MyDivider(color),
                    MyHeightSpacer(height*0.02),
                    MyCard(
                        height, 
                        height*0.135, 
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
                            placemark == null ? Container() : Text('${placemark![0].country},${placemark![0].administrativeArea},${placemark![0].locality},${placemark![0].street}',style: TextStyle(color: Colors.black38,fontFamily: 'TEXT',fontSize: height*0.017,fontWeight: FontWeight.w100),overflow: TextOverflow.fade),
                          ],
                        ), 
                        Alignment.topRight
                      ),
            
            
            
                    //
                    MyHeightSpacer(height*0.02),
                    MyDivider(color),
                    MyHeightSpacer(height*0.02),
                    SizedBox(
                      height: widget.length == null ? height*0.13 : ((height*0.13) + height*0.02)*widget.length!,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.length ?? 1,
                        itemBuilder: (context, index) {
                          if (widget.length == null) {
                            return MyCard(
                              height, 
                              height*0.13, 
                              width, 
                              color, 
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    //
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(height*0.015),
                                      child: Image.network(widget.data!['pictureUrl'],height: height*0.131,width: width*0.23,fit: BoxFit.cover,),
                                    ),
            
                                    //
                                    MyExpanded(), 
            
                                    //
                                    MyWidthSpacer(width*0.012),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          width: width*0.6,
                                          height: height*0.03,
                                          child: Row(
                                            children: [
                                              Expanded(child: SingleChildScrollView(reverse: false,scrollDirection: Axis.horizontal,child: Text(widget.data!['name'],style: TextStyle(color: color.SecondColor,fontFamily: 'TEXT',fontSize: height*0.02,fontWeight: FontWeight.bold,),overflow: TextOverflow.ellipsis,maxLines: 1,))),
                                            ],
                                          ),
                                        ),
                                        //
                                        MyHeightSpacer(height*0.01),
                                        Text('الكمية : ${widget.Howmany}',style: TextStyle(color: Colors.black45,fontFamily: 'TEXT',fontSize: height*0.017,fontWeight: FontWeight.w100,),),
                                        Text('ثمن الطلب  : ${widget.FinalPrice} رس',style: TextStyle(color: Colors.black45,fontFamily: 'TEXT',fontSize: height*0.017,fontWeight: FontWeight.w100,),),
                                        Text('طريقة الدفع : $PaymentMethod',style: TextStyle(color: Colors.black45,fontFamily: 'TEXT',fontSize: height*0.017,fontWeight: FontWeight.w100,),),
                                      ],
                                    ),
                                  ],
                                ), 
                              Alignment.center,
                            );
                          } else {
                            return Padding(
                              padding: EdgeInsets.only(bottom: height*0.02),
                              child: MyCard(
                                height, 
                                height*0.13, 
                                width, 
                                color, 
                                Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      //
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(height*0.015),
                                        child: Image.network(widget.BascketItems![index].data()['product info']['pictureUrl'],height: height*0.131,width: width*0.23,fit: BoxFit.cover,),
                                      ),
                
                                      //
                                      MyExpanded(), 
                
                                      //
                                      MyWidthSpacer(width*0.012),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          SizedBox(
                                            width: width*0.6,
                                            height: height*0.03,
                                            child: Row(
                                              children: [
                                                Expanded(child: SingleChildScrollView(reverse: false,scrollDirection: Axis.horizontal,child: Text(widget.BascketItems![index].data()['product info']['name'],style: TextStyle(color: color.SecondColor,fontFamily: 'TEXT',fontSize: height*0.02,fontWeight: FontWeight.bold,),overflow: TextOverflow.ellipsis,maxLines: 1,))),
                                              ],
                                            ),
                                          ),
                                          //
                                          MyHeightSpacer(height*0.01),
                                          Text('الكمية : ${widget.BascketItems![index].data()['quantity']}',style: TextStyle(color: Colors.black45,fontFamily: 'TEXT',fontSize: height*0.017,fontWeight: FontWeight.w100,),),
                                          Text('ثمن الطلب  : ${widget.BascketItems![index].data()['price']} رس',style: TextStyle(color: Colors.black45,fontFamily: 'TEXT',fontSize: height*0.017,fontWeight: FontWeight.w100,),),
                                          Text('طريقة الدفع : $PaymentMethod',style: TextStyle(color: Colors.black45,fontFamily: 'TEXT',fontSize: height*0.017,fontWeight: FontWeight.w100,),),
                                        ],
                                      ),
                                    ],
                                  ), 
                                Alignment.center,
                              ),
                            );
                          }
                        },
                      ),
                    ),
            
            
            
                    //
                    MyHeightSpacer(height*0.02),
                    MyDivider(color),
                    MyHeightSpacer(height*0.02),
                    MyCard(
                      height, 
                      height*0.14, 
                      width, 
                      color, 
                      Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                Text('  ثمن الطلب',style: TextStyle(color: Colors.black45,fontFamily: 'TEXT',fontSize: height*0.017,fontWeight: FontWeight.w100,),),
                                MyExpanded(),
                                Text('${widget.length == null ? widget.FinalPrice.toString() : price.toString()} رس',style: TextStyle(color: Colors.black45,fontFamily: 'TEXT',fontSize: height*0.017,fontWeight: FontWeight.w100,),),
                              ],
                            ),
                            Row(
                              children: [
                                Text('  رسوم التوصيل',style: TextStyle(color: Colors.black45,fontFamily: 'TEXT',fontSize: height*0.017,fontWeight: FontWeight.w100,),),
                                MyExpanded(),
                                Text('رس 10',style: TextStyle(color: Colors.black45,fontFamily: 'TEXT',fontSize: height*0.017,fontWeight: FontWeight.w100,),),
                              ],
                            ),
                            MyDivider(color),
                            Row(
                              children: [
                                Text(' الثمن النهائي',style: TextStyle(color: Colors.black45,fontFamily: 'TEXT',fontSize: height*0.017,fontWeight: FontWeight.w100,),),
                                MyExpanded(),
                                Text('${widget.length == null ? (double.parse(widget.FinalPrice!) + 10) : price + 10} رس',style: TextStyle(color: Colors.black45,fontFamily: 'TEXT',fontSize: height*0.017,fontWeight: FontWeight.w100,),),
                              ],
                            ),
                          ],
                        ), 
                      Alignment.center,
                    ),
            
            
            
            
                    //
                    MyHeightSpacer(height*0.03),
                    SlideAction(
                      borderRadius: height*0.02,
                      innerColor: color.SecondColor,
                      outerColor: color.FourdColor,
                      text: 'تأكيد',
                      textStyle: TextStyle(fontFamily: 'H1',fontSize: height*0.025,color: color.SecondColor),
                      onSubmit: () {
                        double pricee = 0.0;
                        Map temp = {};
                        setState(() {
                          pricee = double.parse(widget.FinalPrice!) + 10;
                        });
                        if (widget.length == null) {
                          return firestore.AddRequest(widget.data!['name'], pricee, PaymentMethod, widget.Howmany!, User().username!, User().email!, adr, widget.UserData!['phoneNumber']);
                        } else {
                          for (var i = 0; i < widget.length!; i++) {
                            temp.addAll({'$i':widget.BascketItems![i].data()});
                          }
                          return FireStore().CollectionOfRequest(temp, price, PaymentMethod, User().username!, User().email!, widget.UserData!['phoneNumber'].toString(), adr);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
}