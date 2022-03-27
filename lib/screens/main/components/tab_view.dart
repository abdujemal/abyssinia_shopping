import 'package:abyssinia_shopping/models/category.dart';
import 'package:abyssinia_shopping/models/product.dart';
import 'package:abyssinia_shopping/screens/search_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'category_card.dart';
import 'recommended_list.dart';

class TabView extends StatefulWidget {
  final TabController tabController;
 

  TabView(this.tabController);
  @override
  _TabViewState createState() => _TabViewState(tabController);
}

class _TabViewState extends State<TabView> {
  List<Product> products = [];

  var selectedCategory = "All";
  final TabController tabController;

  List<Category> newCategory = [];

  List linkInfo;

  _TabViewState(this.tabController);

  List<Category> categories = [];

  String appUrl;

  @override 
  void initState() {
    // TODO: implement initState
    super.initState();
    DatabaseReference productRef =
        FirebaseDatabase.instance.reference().child("Products");
    productRef.once().then((DataSnapshot snapshot) {
      products.clear();
      var kes = snapshot.value.keys;
      var values = snapshot.value;

      for (var key in kes) {
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
            values[key]["z_variable_values"]);
        products.add(product);
        setState(() {});
      }
    });
    

    DatabaseReference categoryRef =
        FirebaseDatabase.instance.reference().child("Category_Item");
    categoryRef.once().then((DataSnapshot dataSnapshot) {
      var vals = dataSnapshot.value;
      var keys = dataSnapshot.value.keys;
      for (var key in keys) {
        Category category = Category(
            vals[key]["CategoryAmharicName"],
            vals[key]["CategoryImage"],
            vals[key]["CategoryName"],
            vals[key]["main_category"],
            vals[key]["productNumber"]);
        categories.add(category);
        setState(() {});
      }
      newCategory.addAll(categories
          .where((element) => int.parse(element.productNumber) > 0)
          .toList());
      ;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height / 9);
    return TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: <Widget>[
         
          Container(
            child: Column(
              
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
               
                Container(
                    margin: EdgeInsets.all(8.0),
                    height: MediaQuery.of(context).size.height / 9,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: newCategory.length,
                        itemBuilder: (_, index) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: GestureDetector(
                                  onTap: () {
                                    

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SearchPage(
                                                    products
                                                        .where((element) =>
                                                            element
                                                                .Product_category ==
                                                            newCategory[index]
                                                                .CategoryName)
                                                        .toList(),
                                                    "category",
                                                    [
                                                      newCategory[index]
                                                          .CategoryName,
                                                      newCategory[index]
                                                          .CategoryImage
                                                    ])));
                                  },
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Stack(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5.0),
                                              child: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    newCategory[index]
                                                        .CategoryImage),
                                                radius: 25,
                                              ),
                                            ),
                                            Positioned(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.orange,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(3.0),
                                                  child: Text(
                                                    newCategory[index]
                                                        .productNumber,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Text(
                                            newCategory[index].CategoryName,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ))),
                SizedBox(
                  height: 16.0,
                ),
                Flexible(child: RecommendedList(products, "normal")),
              ],
            ),
          ),
          Column(children: <Widget>[
            SizedBox(
              height: 16.0,
            ),
            Flexible(child: RecommendedList(products, "normal"))
          ]),
          Column(children: <Widget>[
            SizedBox(
              height: 16.0,
            ),
            Flexible(child: RecommendedList(products, "normal"))
          ]),
          Column(children: <Widget>[
            SizedBox(
              height: 16.0,
            ),
            Flexible(child: RecommendedList(products, "normal"))
          ]),
          Column(children: <Widget>[
            SizedBox(
              height: 16.0,
            ),
            Flexible(child: RecommendedList(products, "normal"))
          ]),
        ]);
  }
}
