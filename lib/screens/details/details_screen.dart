import 'package:abyssinia_shopping/custom_background.dart';
import 'package:abyssinia_shopping/models/product.dart';
import 'package:abyssinia_shopping/screens/search_page.dart';
import 'package:abyssinia_shopping/screens/shop/check_out_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants.dart';
import 'components/body.dart';


class DetailsScreen extends StatefulWidget {
  final Product product;
  final List<Product> productList;

  const DetailsScreen({Key key, this.product, this.productList})
      : super(key: key);
  @override
  _DetailsScreenState createState() => _DetailsScreenState(product,productList);
}

class _DetailsScreenState extends State<DetailsScreen> {
  final Product product;
  final List<Product> productList;
  _DetailsScreenState(this.product, this.productList);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MainBackground(),
      child: Scaffold(
        // each product have a color
        body: Column(
          children: [
            SizedBox(height: 39),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.keyboard_backspace),
                  onPressed: () => Navigator.pop(context),
                ),
                Row(
                  children: [
                    
                    IconButton(
                      icon: Icon(Icons.shopping_cart_outlined),
                      onPressed: () {
                        Navigator.push(context,MaterialPageRoute(builder:(_)=>CheckOutPage()));
                      },
                    ),
                    SizedBox(width: kDefaultPaddin / 2)
                  ],
                )
              ],
            ),
            Flexible(child: ListView(children: [Body(product)])),
          ],
        ),
      ),
    );
  }
}
