import 'package:flutter/material.dart';

class PageTransaction extends PageRouteBuilder {
  final Widget page;

  PageTransaction(this.page)
  : super(
      pageBuilder: (context, animation, anotherAnimation) => page,
      transitionDuration: const Duration(milliseconds: 1000),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, anotherAnimation, child) {
        animation = CurvedAnimation(
            curve: Curves.fastLinearToSlowEaseIn,
            parent: animation,
            reverseCurve: Curves.fastOutSlowIn);
        return Align(
          alignment: Alignment.topCenter,
          child: SizeTransition(
            sizeFactor: animation,
            axisAlignment: 0,
            child: page,
          ),
        );
      },
    );
}