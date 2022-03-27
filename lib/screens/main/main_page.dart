import 'package:abyssinia_shopping/app_properties.dart';
import 'package:abyssinia_shopping/custom_background.dart';
import 'package:abyssinia_shopping/models/city.dart';
import 'package:abyssinia_shopping/models/product.dart';
import 'package:abyssinia_shopping/models/speciality.dart';

import 'package:abyssinia_shopping/screens/notifications_page.dart';
import 'package:abyssinia_shopping/screens/profile_page.dart';
import 'package:abyssinia_shopping/screens/search_page.dart';
import 'package:abyssinia_shopping/screens/shop/check_out_page.dart';

import 'package:abyssinia_shopping/screens/wishList/wish_list.dart';
import 'package:abyssinia_shopping/services/database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'components/custom_bottom_bar.dart';
import 'components/product_list.dart';
import 'components/tab_view.dart';
import 'package:url_launcher/url_launcher.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

List<Speciality> timelines = [];
String selectedTimeline = '';

List<Product> products = [], newproducts = [];

class _MainPageState extends State<MainPage>
    with TickerProviderStateMixin<MainPage> {
  SwiperController swiperController;
  TabController tabController;
  TabController bottomTabController;
  bool hasUpdate = false;

  @override
  void initState() {
    // TODO: implement initState
    DatabaseReference udpateRef =
        FirebaseDatabase.instance.reference().child("Updates");
    udpateRef.once().then((DataSnapshot snapshot) {
      var keys = snapshot.value.keys;
      for (var key in keys) {
        if (key == "v2") {
          hasUpdate = true;
        }
      }
    });
    refresh();
  }

  void refresh() {
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

    DatabaseReference specialities =
        FirebaseDatabase.instance.reference().child("speciality");
    specialities.once().then((DataSnapshot snapshot) {
      timelines.clear();
      print(snapshot.value);
      var ks = snapshot.value.keys;

      var vals = snapshot.value;
      for (var key in ks) {
        Speciality speciality = Speciality(vals[key]["value"]);
        timelines.add(speciality);

        print("val");
        setState(() {
          selectedTimeline = timelines[0].value;
        });
      }
    });

    tabController = TabController(length: 5, vsync: this);
    bottomTabController = TabController(length: 4, vsync: this);
  }

  @protected
  @mustCallSuper
  void dispose() {
    super.dispose();
    tabController.dispose();
    bottomTabController.dispose();
    swiperController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget appBar = Container(
      height: kToolbarHeight + MediaQuery.of(context).padding.top,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          hasUpdate
              ? Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: GestureDetector(
                    onTap: () async {
                      String url =
                          "https://play.google.com/store/apps/details?id=com.abyssinia.abyssinia_shopping";
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        Fluttertoast.showToast(msg: "It is not working");
                      }
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.red),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text("Upgrade",
                              style: TextStyle(color: Colors.white)),
                        )),
                  ),
                )
              : SizedBox(
                  width: 50,
                ),
          Padding(
            padding: EdgeInsets.all(2),
            child: Image(
              image: AssetImage('assets/logo.png'),
              width: 100,
              height: 100,
            ),
          ),
          IconButton(
              onPressed: () {
                print(products);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => SearchPage(products, "All", [])));
              },
              icon: SvgPicture.asset('assets/icons/search_icon.svg'))
        ],
      ),
    );

    Widget topHeader = Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 4.0),
        child: Container(
          width: 100,
          height: 50,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: timelines.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedTimeline = timelines[index].value;

                        // for (var p in products) {
                        // newproducts = products;
                        //   if (p.Product_category == "Men's Shoes") {
                        //     newproducts.add(p);
                        //   }
                        // }
                      });
                    },
                    child: Text(
                      timelines[index].value,
                      style: TextStyle(
                          fontSize: timelines[index].value == selectedTimeline
                              ? 20
                              : 14,
                          color: darkGrey),
                    ),
                  ),
                );
              }),
        ));

    Widget tabBar = TabBar(
      tabs: [
        Tab(text: 'Trending'),
        Tab(text: 'Sports'),
        Tab(text: 'Headsets'),
        Tab(text: 'Wireless'),
        Tab(text: 'Bluetooth'),
      ],
      labelStyle: TextStyle(fontSize: 16.0),
      unselectedLabelStyle: TextStyle(
        fontSize: 14.0,
      ),
      labelColor: darkGrey,
      unselectedLabelColor: Color.fromRGBO(0, 0, 0, 0.5),
      isScrollable: true,
      controller: tabController,
    );

    return Scaffold(
      bottomNavigationBar: CustomBottomBar(controller: bottomTabController),
      body: CustomPaint(
        painter: MainBackground(),
        child: TabBarView(
          controller: bottomTabController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            SafeArea(
              child: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  // These are the slivers that show up in the "outer" scroll view.
                  return <Widget>[
                    SliverToBoxAdapter(
                      child: appBar,
                    ),
                    SliverToBoxAdapter(
                      child: topHeader,
                    ),
                    SliverToBoxAdapter(
                      child: ProductList(
                        products: products.where((element) {
                          if (element.speciality != null) {
                            return element.speciality == selectedTimeline;
                          }
                        }).toList(),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: tabBar,
                    )
                  ];
                },
                body: TabView(tabController),
              ),
            ),
            WishListPage(),
            CheckOutPage(),
            ProfilePage()
          ],
        ),
      ),
    );
  }
}
