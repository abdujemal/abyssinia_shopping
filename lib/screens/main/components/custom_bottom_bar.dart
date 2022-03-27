import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomBottomBar extends StatefulWidget {
  final TabController controller;

  CustomBottomBar({this.controller});
  @override
  _CustomBottomBarState createState() => _CustomBottomBarState(controller);
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  final TabController controller;

  _CustomBottomBarState(this.controller);

  @override
  Widget build(BuildContext context) {
    String bottomTabs = "";
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.home,
              color: bottomTabs == "home" ? Colors.black : Colors.grey,
              size: 20,
            ),
            onPressed: () {
              setState(() {
                bottomTabs = "home";
              });
              controller.animateTo(0);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.favorite,
              size: 20,
              color: bottomTabs == "category" ? Colors.black : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                bottomTabs = "category";
              });
              controller.animateTo(1);
            },
          ),
          IconButton(
            icon: Icon(
              FontAwesomeIcons.cartArrowDown,
              size: 20,
              color: bottomTabs == "cart" ? Colors.black : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                bottomTabs = "cart";
              });
              controller.animateTo(2);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.account_circle,
              size: 20,
              color: bottomTabs == "profile" ? Colors.black : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                bottomTabs = "profile";
              });
              controller.animateTo(3);
            },
          )
        ],
      ),
    );
  }
}
