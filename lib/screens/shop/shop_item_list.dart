
import 'package:abyssinia_shopping/models/cart.dart';
import 'package:abyssinia_shopping/models/product.dart';

import 'package:abyssinia_shopping/screens/shop/components/shop_product.dart';

import 'package:flutter/material.dart';

import '../../app_properties.dart';



class ShopItemList extends StatefulWidget {
  final Cart cart;
  final Function onRemove;

  ShopItemList(this.cart, {Key key, this.onRemove}) : super(key: key);

  @override
  _ShopItemListState createState() => _ShopItemListState();
}

class _ShopItemListState extends State<ShopItemList> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    var real_product_price = widget.cart.Product_Price;
        return Container(
          margin: EdgeInsets.only(top: 20),
          height: 130,
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment(0, 0.8),
                child: Container(
                    height: 100,
                    margin: EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: shadow,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 12.0, right: 12.0),
                            width: 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  widget.cart.Product_name,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: darkGrey,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    width: 160,
                                    padding: const EdgeInsets.only(
                                        left: 32.0, top: 8.0, bottom: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        // ColorOption(Colors.red),
                                        Text(
                                          'ETB ${real_product_price}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: darkGrey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Text(
                                  widget.cart.Properties,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: darkGrey,
                                  ),
                                ),
                          ],
                        ),
                      ),
                      SizedBox(width: 30,)

                    ])),
          ),
           Positioned(
              top: 5,
              child: ShopProductDisplay(
                widget.cart,
                onPressed: widget.onRemove,
              )),
          
        ],
      ),
    );
  }
}
