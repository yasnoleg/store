import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:store/tools/buttons.dart';
import 'package:store/tools/text.dart';

import '../../database/auth/user_auth.dart';
import '../../tools/colors.dart';

class SignUpPage extends StatefulWidget {
  VoidCallback onTap;
  SignUpPage({super.key, required this.onTap});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {


  //instances
  Auth AuthInstance = Auth();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  COLOR color = COLOR();

  //TextEditingController
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();


  //Create User
  Future<void> _registerUser() async {
    // Store additional user information in Firestore
    await _auth.currentUser!.updateDisplayName(_displayNameController.text);
    await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
      'displayName': _displayNameController.text,
      'email': _emailController.text,
      'phoneNumber': _phoneNumberController.text,
    });

  }


  //initState
  @override
  void initState() {
    super.initState();
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
          child: Image.asset('asset/logo/20230925_182047.png',height: height*0.05,),
        ),
        leading: IconButton(
          onPressed: widget.onTap, 
          icon: Icon(Icons.arrow_back_ios_new_outlined,size: height*0.025,),
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //
                  MyHeightSpacer(height*0.02),
                  MyTitle('لتبدأ رحلتك مع القهوة', color, height),

                  //
                  MyTextField(_displayNameController, height, color, 'Enter Full Name', 'Full Name', 'text'),

                  //
                  MyTextField(_emailController, height, color, 'Enter Email', 'Email', 'email'),

                  //
                  MyTextField(_phoneNumberController, height, color, 'Enter Phone Number', 'Phone Number', 'number'),

                  //
                  MyTextField(_passwordController, height, color, 'Enter Paswword', 'Password', 'password'),

                  //
                  const SizedBox(height: 20),
                  MyButton(height, width, color.SecondColor, 'Sign Up', color.FourdColor, () async {
                    try {
                      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text).whenComplete(() => _registerUser());
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          content: AwesomeSnackbarContent(
                            title: 'Try Again', 
                            message: e.toString(), 
                            contentType: ContentType.failure,
                          ),
                        )
                      );
                    }
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}