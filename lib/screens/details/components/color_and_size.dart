import 'package:abyssinia_shopping/models/product.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class ColorAndSize extends StatefulWidget {
  const ColorAndSize({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;
  @override
  _ColorAndSizeState createState() => _ColorAndSizeState(product);
}

class _ColorAndSizeState extends State<ColorAndSize> {
  Product product;
  _ColorAndSizeState(this.product);
  @override
  Widget build(BuildContext context) {
    
    return Container();
  }
}

class ColorDot extends StatelessWidget {
  final Color color;
  final bool isSelected;
  const ColorDot({
    Key key,
    this.color,
    // by default isSelected is false
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: kDefaultPaddin / 4,
        right: kDefaultPaddin / 2,
      ),
      padding: EdgeInsets.all(2.5),
      height: 24,
      width: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? color : Colors.transparent,
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
