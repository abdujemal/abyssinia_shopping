import 'package:abyssinia_shopping/models/product.dart';
import 'package:flutter/material.dart';


import '../../../constants.dart';

class ProductTitleWithImage extends StatelessWidget {
  const ProductTitleWithImage({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          
          Text(
            product.Product_name,
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: kDefaultPaddin),
          Row(
            children: <Widget>[
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: "Price\n"),
                    TextSpan(
                      text: "ETB ${product.Real_Product_price}",
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          color: Colors.orange, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(width: kDefaultPaddin),
              Expanded(
                child: Hero(
                  tag: "${product.Product_id}",
                  child: Image.network(
                    product.image0,
                    fit: BoxFit.fill,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
