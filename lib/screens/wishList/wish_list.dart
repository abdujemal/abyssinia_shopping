import 'package:abyssinia_shopping/app_properties.dart';
import 'package:abyssinia_shopping/custom_background.dart';
import 'package:abyssinia_shopping/models/category.dart';

import 'package:abyssinia_shopping/screens/wishList/components/wishListProducts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';



class WishListPage extends StatefulWidget {
  @override
  _WishListPageState createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: MainBackground(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 20,),
            Align(
              alignment: Alignment(-1, 0),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Wish Lists',
                    style: TextStyle(
                      color: darkGrey,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            WishListProducts()
            
            
          ],
        ),
        ),
    );
  }
}
