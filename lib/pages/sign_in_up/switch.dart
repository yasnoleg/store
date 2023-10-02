import 'package:flutter/material.dart';
import 'package:store/pages/onBoarding.dart';

import 'signIn.dart';
import 'signUp.dart';

class SwitchSignPages extends StatefulWidget {
  const SwitchSignPages({super.key});

  @override
  State<SwitchSignPages> createState() => _SwitchSignPagesState();
}

class _SwitchSignPagesState extends State<SwitchSignPages> {

  //switch variable 
  int switchPages = 0;

  //
  @override
  Widget build(BuildContext context) {
    if (switchPages == 0) {
      return onBoarding(onTap: () {
        setState(() {
          switchPages = 1;
        });
      },);
    } else {
      if (switchPages == 1) {
        return SignInPage(
          onTap: () { 
            setState(() {
              switchPages = 2;
            }); 
          },
        );
      } else {
        return SignUpPage(
          onTap: () { 
            print('switch');
            setState(() {
              switchPages = 1;
            }); 
          },
        );
      }
    }
  }
}