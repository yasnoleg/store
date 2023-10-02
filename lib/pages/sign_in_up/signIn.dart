import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../database/auth/user_auth.dart';
import '../../tools/buttons.dart';
import '../../tools/colors.dart';
import '../../tools/text.dart';

class SignInPage extends StatefulWidget {
  VoidCallback onTap;
  SignInPage({super.key, required this.onTap});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {


  //instances
  Auth AuthInstance = Auth();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  COLOR color = COLOR();

  //Controllers
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();


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
                  MyTitle('مرحبا بك مجددا', color, height),

                  //
                  MyTextField(_email, height, color, 'Enter Email', 'Email', 'email'),

                  //
                  MyTextField(_password, height, color, 'Enter Paswword', 'Password', 'password'),

                  //
                  const SizedBox(height: 20),
                  MyButton(height, width, color.SecondColor, 'Sign In', color.FourdColor, () async {
                    try {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email.text, password: _password.text);
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