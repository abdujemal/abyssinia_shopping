import 'package:abyssinia_shopping/app_properties.dart';
import 'package:abyssinia_shopping/models/product.dart';
import 'package:abyssinia_shopping/screens/details/details_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

class RecommendedList extends StatefulWidget {
  List<Product> products = [];
  var type;

  RecommendedList(this.products, this.type);
  @override
  State createState() => RecommendedList_State(products, type);
}

class RecommendedList_State extends State<RecommendedList> {
  List<Product> products = [];
  var type;

  RecommendedList_State(this.products, this.type);
  Widget priceBadge(product) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12.0),
        padding: const EdgeInsets.fromLTRB(8.0, 4.0, 12.0, 4.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
            color: Colors.white //Color.fromRGBO(224, 69, 10, 1),
            ),
        child: Text(
          'ETB ${product.Real_Product_price ?? 0.0}',
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget dicountBadge(product) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12.0),
        padding: const EdgeInsets.fromLTRB(8.0, 4.0, 12.0, 4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
          color: Color.fromRGBO(224, 69, 10, 1),
        ),
        child: Text(
          '${product.discount}% - off',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        type == "normal"
            ? SizedBox(
                height: 20,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    IntrinsicHeight(
                      child: Container(
                        margin: const EdgeInsets.only(left: 16.0, right: 8.0),
                        width: 4,
                        color: mediumYellow,
                      ),
                    ),
                    Center(
                        child: Text(
                      'Recommended',
                      style: TextStyle(
                          color: darkGrey,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    )),
                  ],
                ),
              )
            : SizedBox(
                height: 0,
              ),
        Flexible(
            child: Padding(
          padding: EdgeInsets.all(8),
          child: LazyLoadScrollView(
            onEndOfPage: () {},
            child: StaggeredGridView.countBuilder(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              crossAxisCount: 4,
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) => new ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => DetailsScreen(product: products[index]))),
                  child: Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                            colors: [Colors.grey[500], Colors.grey[700]],
                            center: Alignment(0, 0),
                            radius: 0.6,
                            focal: Alignment(0, 0),
                            focalRadius: 0.1),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: NetworkImage(
                            products[index].image0,
                          ),
                          fit: BoxFit.fill,
                        )),
                        child: Stack(
                          children: [
                            products[index].discount != 0
                                ? dicountBadge(products[index])
                                : SizedBox(),
                            priceBadge(products[index])
                          ],
                        ),
                      )),
                ),
              ),
              staggeredTileBuilder: (int index) =>
                  new StaggeredTile.count(2, index.isEven ? 3 : 2),
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
            ),
          ),
        )),
      ],
    );
  }
}
