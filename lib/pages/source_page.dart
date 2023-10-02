import 'package:flutter/material.dart';
import 'package:store/pages/bascket_page.dart';
import 'package:store/pages/home_page.dart';
import 'package:store/pages/profile_page.dart';
import 'package:store/pages/search_page.dart';
import 'package:store/tools/colors.dart';


class SourcePage extends StatefulWidget {
  const SourcePage({super.key});

  @override
  State<SourcePage> createState() => _SourcePageState();
}

class _SourcePageState extends State<SourcePage> {

  //currentindex
  int currentIndex = 0;

  //instances
  COLOR color = COLOR();

  //pages
  List<Widget> Pages = [
    const HomePage(),
    const SearchPage(),
    const BascketPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body:Pages[currentIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(20),
        height: size.width * .155,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.15),
              blurRadius: 15,
              offset: const Offset(0, 10),
            ),
          ],
          borderRadius: BorderRadius.circular(50),
        ),
        child: ListView.builder(
          itemCount: 4,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: size.width * .024),
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              setState(
                () {
                  currentIndex = index;
                },
              );
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.fastLinearToSlowEaseIn,
                  margin: EdgeInsets.only(
                    bottom: index == currentIndex ? 0 : size.width * .029,
                    right: size.width * .0422,
                    left: size.width * .0422,
                  ),
                  width: size.width * .128,
                  height: index == currentIndex ? size.width * .014 : 0,
                  decoration: BoxDecoration(
                    color: color.FirstColor,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(10),
                    ),
                  ),
                ),
                Image.asset(
                  listOfIcons[index],
                  height: size.width * .05,
                  color: index == currentIndex
                      ? color.FirstColor
                      : Colors.black38,
                ),
                SizedBox(height: size.width * .03),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<String> listOfIcons = [
    'asset/icons/store.png',
    'asset/icons/panier-dachat-simple.png',
    'asset/icons/grocery-store.png',
    'asset/icons/utilisateur.png',
  ];
}