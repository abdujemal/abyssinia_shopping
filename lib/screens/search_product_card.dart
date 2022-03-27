import 'package:abyssinia_shopping/models/ProductInfo.dart';
import 'package:abyssinia_shopping/models/product.dart';
import 'package:abyssinia_shopping/screens/details/details_screen.dart';
import 'package:abyssinia_shopping/tools.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SearchProduct extends StatelessWidget {
  Product product;
  List<ProductInfo> productInfo;
  SearchProduct(this.product, this.productInfo);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 5),
        child: Card(
          elevation: 0,
          margin: EdgeInsets.all(10),
          child: GestureDetector(
            onTap: () {
              
              
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => DetailsScreen(product: product)));
            },
            child: Container(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.network(
                      product.image0,
                      height: 100,
                      width: 100,
                    ),
                  ),
                  Container(
                    height: 100,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          product.Product_name,
                          style: TextStyle(color: Colors.black54, fontSize: 18),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          product.Product_description,
                          style: TextStyle(color: Colors.black45, fontSize: 14),
                        ),
                        Text("ETB ${product.Real_Product_price}"),
                        FlutterRatingBar(
                          onRatingUpdate: (double rating) {},
                          initialRating: productInfo[0].rating.toDouble(),
                          itemSize: 15,
                          ignoreGestures: true,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
