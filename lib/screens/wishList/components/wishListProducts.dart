import 'package:abyssinia_shopping/models/product.dart';
import 'package:abyssinia_shopping/screens/details/details_screen.dart';
import 'package:abyssinia_shopping/screens/faq_page.dart';
import 'package:abyssinia_shopping/screens/main/main_page.dart';
import 'package:abyssinia_shopping/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

class WishListProducts extends StatefulWidget {
  @override
  _WishListProductsState createState() => _WishListProductsState();
}

class _WishListProductsState extends State<WishListProducts> {
  List<Product> products;
  DatabaseReference wishListRef =
      FirebaseDatabase.instance.reference().child("WishLists");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DatabaseReference productRef =
        FirebaseDatabase.instance.reference().child("Products");

    wishListRef.once().then((DataSnapshot snapshot) {
      var wishVals = snapshot.value;
      var wishKey = snapshot.value.keys;
      products = [];
      
      for (var wkey in wishKey) {
        if (wishVals[wkey]["Owner"] == FirebaseAuth.instance.currentUser.uid) {
          productRef.once().then((DataSnapshot dataSnapshot) {
            var values = dataSnapshot.value;
            var keys = dataSnapshot.value.keys;
            for (var key in keys) {
              if (values[key]["Product_id"] == wishVals[wkey]["Product_id"]) {
                Product product = Product(
                  values[key]["Actual_Product_price"],
                  values[key]["Merchant_id"],
                  values[key]["Product_brand"],
                  values[key]["Product_category"],
                  values[key]["Product_description"],
                  values[key]["Product_id"],
                  values[key]["Product_more_description"],
                  values[key]["Product_name"],
                  values[key]["Product_nick_name"],
                  values[key]["Real_Product_price"],
                  values[key]["discount"],
                  values[key]["image0"],
                  values[key]["image1"],
                  values[key]["image2"],
                  values[key]["image3"],
                  values[key]["image_name0"],
                  values[key]["image_name1"],
                  values[key]["image_name2"],
                  values[key]["image_name3"],
                  values[key]["published_on_date"],
                  values[key]["published_on_time"],
                  values[key]["speciality"],
                  values[key]["z_main_value"],
                  values[key]["z_value_types"],
                  values[key]["z_variable_values"],
                  Wish_list_id: wishVals[wkey]["Wish_list_id"],
                );
                products.add(product);
                if (mounted) {
                  setState(() {});
                }
              }
            }
          });
        }
      }
    });
    if (mounted) {
        setState(() {});
      }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    wishListRef.onDisconnect();
  }

  @override
  Widget build(BuildContext context) {
    return products == null
        ? Center(child: Center(child: CircularProgressIndicator()))
        : products.length == 0
            ? GestureDetector(
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => FaqPage()));
                },
                child: Text(
                    "You do not have no product in your wish list. Learn more"))
            : Flexible(
                child: Padding(
                padding: EdgeInsets.all(8),
                child: LazyLoadScrollView(
                  onEndOfPage: () {},
                  child: StaggeredGridView.countBuilder(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    crossAxisCount: 4,
                    itemCount: products.length,
                    itemBuilder: (BuildContext context, int index) =>
                        new ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      child: InkWell(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) =>
                                    DetailsScreen(product: products[index]))),
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
                                  priceBadge(products[index]),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: GestureDetector(
                                      child: Icon(
                                        Icons.delete_forever,
                                        color: Colors.red,
                                      ),
                                      onTap: () {
                                        wishListRef
                                            .child(products[index].Wish_list_id)
                                            .remove()
                                            .whenComplete(() {
                                          Fluttertoast.showToast(
                                              msg:
                                                  products[index].Product_name +
                                                      " is removed.");
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          MainPage()));
                                        });
                                      },
                                    ),
                                  )
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
              ));
  }

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
}
