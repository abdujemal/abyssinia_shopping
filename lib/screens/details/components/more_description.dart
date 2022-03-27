import 'package:abyssinia_shopping/models/product.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class MoreDescription extends StatelessWidget {
  const MoreDescription({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin),
      child: Text(
        product.Product_more_description,
        style: TextStyle(height: 1.5),
      ),
    );
  }
}
