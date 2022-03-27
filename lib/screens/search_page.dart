import 'package:abyssinia_shopping/app_properties.dart';
import 'package:abyssinia_shopping/models/ProductInfo.dart';
import 'package:abyssinia_shopping/models/category.dart';
import 'package:abyssinia_shopping/models/product.dart';

import 'package:abyssinia_shopping/screens/search_product_card.dart';
import 'package:abyssinia_shopping/services/database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rubber/rubber.dart';

class SearchPage extends StatefulWidget {
  List<Product> products;
  String type;
  List<String> moreInfo;
  SearchPage(this.products, this.type, this.moreInfo);
  @override
  _SearchPageState createState() => _SearchPageState(products, type, moreInfo);
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  String selectedPeriod;
  String selectedCategory;
  String selectedPrice;

  List<Product> products;
  String type;
  List<String> moreInfo;

  List<Product> tempList = List<Product>();

  bool isSearching = false;
  _SearchPageState(this.products, this.type, this.moreInfo);

  
  List<Product> searchResults;
  List<ProductInfo> productInfos = [];

  TextEditingController searchController = TextEditingController();

  RubberAnimationController _controller;

  @override
  void initState() {
    DatabaseReference productsInfoRef =
        FirebaseDatabase.instance.reference().child("ProductsInfo");
    productsInfoRef.once().then((DataSnapshot dataSnapshot) {
      var values = dataSnapshot.value;
      var keys = dataSnapshot.value.keys;
      for (var key in keys) {
        ProductInfo productInfo = ProductInfo(
            values[key]["Product_id"],
            values[key]["rating"],
            values[key]["sold"],
            values[key]["total_viewed"],
            values[key]["total_wishList"]);
        productInfos.add(productInfo);
        setState(() {});
      }
    });
    _controller = RubberAnimationController(
        vsync: this,
        halfBoundValue: AnimationControllerValue(percentage: 0.4),
        upperBoundValue: AnimationControllerValue(percentage: 0.4),
        lowerBoundValue: AnimationControllerValue(pixel: 50),
        duration: Duration(milliseconds: 200));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _expand() {
    _controller.expand();
  }

  Widget _getLowerLayer() {
    return Container(
      color: Colors.orange[100],
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            type == "All" ? "" : 
                             moreInfo[0] != null ?
                             moreInfo[0] : "",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                      ),
                      type == "store"
                          ? GestureDetector(
                              child: Text(
                                "follow",
                                style: TextStyle(color: Colors.blue),
                              ),
                              onTap: () {},
                            )
                          : SizedBox()
                    ],
                  ),
                ),
                Container(
                  decoration: type == "All"
                      ? BoxDecoration(color: Colors.white)
                      : BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(moreInfo[1]))),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Search',
                              style: TextStyle(
                                color: darkGrey,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            CloseButton()
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.orange, width: 1))),
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        tempList = List<Product>();
                        products.forEach((product) {
                          if (product.Product_nick_name.toLowerCase()
                              .contains(value)) {
                            tempList.add(product);
                          }
                        });
                        setState(() {
                          searchResults.clear();
                          isSearching = true;
                          searchResults.addAll(tempList);
                        });
                        return;
                      } else {
                        setState(() {
                          searchResults.clear();
                          searchResults.addAll(products);
                        });
                      }
                    },
                    cursorColor: darkGrey,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                        prefixIcon: SvgPicture.asset(
                          'assets/icons/search_icon.svg',
                          fit: BoxFit.scaleDown,
                        ),
                        suffix: FlatButton(
                            // onPressed: () {
                            //   // searchController.clear();
                            //   // searchResults.clear();
                            // },
                            child: Text(
                              'Clear',
                              style: TextStyle(color: Colors.white),
                            ))),
                  ),
                ),
              ],
            ),
          ),
          products == null ?
          Center(child: CircularProgressIndicator(),):
           productInfos.length == 0 ?
           
           Center(child: CircularProgressIndicator(),):
           Flexible(
              child: Container(
                  child: ListView.builder(
                      itemCount:
                          isSearching ? searchResults.length : products.length,
                      itemBuilder: (_, index) => SearchProduct(
                          isSearching ? searchResults[index] : products[index],
                          isSearching
                              ? productInfos.where((element) =>
                                  element.Product_id ==
                                  searchResults[index].Product_id).toList()
                              : productInfos.where((element) =>
                                  element.Product_id ==
                                  products[index].Product_id).toList())))),
        ],
      ),
    );
  }

  Widget _getUpperLayer() {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.05),
                offset: Offset(0, -3),
                blurRadius: 10)
          ],
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(24), topLeft: Radius.circular(24)),
          color: Colors.white),
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        //          controller: _scrollController,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Filters',
                style: TextStyle(color: Colors.grey[300]),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 32.0, top: 16.0, bottom: 16.0),
              child: Text(
                'Sort By',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          )
      ]));
          
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        top: true,
        bottom: false,
        child: Scaffold(
            //          bottomSheet: ClipRRect(
            //            borderRadius: BorderRadius.only(
            //                topRight: Radius.circular(25), topLeft: Radius.circular(25)),
            //            child: BottomSheet(
            //                onClosing: () {},
            //                builder: (_) => Container(
            //                      padding: EdgeInsets.all(16.0),
            //                      child: Row(
            //                          mainAxisAlignment: MainAxisAlignment.center,
            //                          children: <Widget>[Text('Filters')]),
            //                      color: Colors.white,
            //                      width: MediaQuery.of(context).size.height,
            //                    )),
            //          ),
            body: RubberBottomSheet(
          lowerLayer: _getLowerLayer(), // The underlying page (Widget)
          upperLayer:
              Container(), //_getUpperLayer(), // The bottomsheet content (Widget)
          animationController: _controller, // The one we created earlier
        )),
      ),
    );
  }
}
