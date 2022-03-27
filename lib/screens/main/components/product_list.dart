import 'package:abyssinia_shopping/app_properties.dart';

import 'package:abyssinia_shopping/models/product.dart';
import 'package:abyssinia_shopping/screens/details/details_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class ProductList extends StatelessWidget {
  List<Product> products;

  final SwiperController swiperController = SwiperController();

  ProductList({Key key, this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double cardHeight = MediaQuery.of(context).size.height / 2.7;
    double cardWidth = MediaQuery.of(context).size.width / 1.8;
    if (products == null) products = [];

    return SizedBox(
      height: cardHeight,
      child: Swiper(
        itemCount: products.length,
        itemBuilder: (_, index) {
          return ProductCard(
              height: cardHeight, width: cardWidth, product: products[index]);
        },
        scale: 0.8,
        controller: swiperController,
        viewportFraction: 0.6,
        loop: false,
        fade: 0.5,
        pagination: SwiperCustomPagination(
          builder: (context, config) {
            if (config.itemCount > 20) {
              print(
                  "The itemCount is too big, we suggest use FractionPaginationBuilder instead of DotSwiperPaginationBuilder in this sitituation");
            }
            Color activeColor = mediumYellow;
            Color color = Colors.grey[300];
            double size = 10.0;
            double space = 5.0;

            if (config.indicatorLayout != PageIndicatorLayout.NONE &&
                config.layout == SwiperLayout.DEFAULT) {
              return new PageIndicator(
                count: config.itemCount,
                controller: config.pageController,
                layout: config.indicatorLayout,
                size: size,
                activeColor: activeColor,
                color: color,
                space: space,
              );
            }

            List<Widget> dots = [];

            int itemCount = config.itemCount;
            int activeIndex = config.activeIndex;

            for (int i = 0; i < itemCount; ++i) {
              bool active = i == activeIndex;
              dots.add(Container(
                key: Key("pagination_$i"),
                margin: EdgeInsets.all(space),
                child: ClipOval(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: active ? activeColor : color,
                    ),
                    width: size,
                    height: size,
                  ),
                ),
              ));
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: dots,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final double height;
  final double width;

  const ProductCard({Key key, this.product, this.height, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => DetailsScreen(product: product))),
      child: Stack(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 30),
            height: height,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(24)),
              color: mediumYellow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.favorite_border),
                  onPressed: () {
                    addToWishList(product);
                  },
                  color: Colors.white,
                ),
                Column(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            product.Product_name ?? '',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                        )),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12.0),
                        padding: const EdgeInsets.fromLTRB(8.0, 4.0, 12.0, 4.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10)),
                          color: Color.fromRGBO(224, 69, 10, 1),
                        ),
                        child: Text(
                          'ETB ${product.Real_Product_price ?? 0.0}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Positioned(
            child: Hero(
              tag: product.image0,
              child: Image.network(
                product.image0,
                height: height / 1.7,
                width: height / 1.7,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void addToWishList(Product product) {
    DateTime dateTime = DateTime.now();
    DateFormat dateFormat = DateFormat('dd-MMM-yyyy');
    String date = dateFormat.format(dateTime);
    int timeStamp = dateTime.millisecondsSinceEpoch;
    String uid = FirebaseAuth.instance.currentUser.uid;

    DatabaseReference wishListRef = FirebaseDatabase.instance
        .reference()
        .child("WishLists")
        .child(product.Product_id + uid);
    Map<String, Object> map = Map();
    map = {
      "Merchant_id": product.Merchant_id,
      "Owner": uid,
      "Product_id": product.Product_id,
      "Product_name": product.Product_name,
      "Product_nick_name": product.Product_nick_name,
      "Wish_list_id": product.Product_id + uid,
      "viewed_time": date + "," + timeStamp.toString()
    };
    wishListRef.update(map).whenComplete(() {
      Fluttertoast.showToast(msg: "Added to your wish List.");
    });
  }
}
