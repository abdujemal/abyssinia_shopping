import 'package:abyssinia_shopping/constants.dart';
import 'package:abyssinia_shopping/models/product.dart';
import 'package:abyssinia_shopping/screens/details/components/more_description.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'add_to_cart.dart';

import 'color_and_size.dart';

import 'description.dart';
import 'product_title_with_image.dart';

class Body extends StatefulWidget {
  Product product;
  Body(this.product);
  @override
  _BodyState createState() => _BodyState(product);
}

class _BodyState extends State<Body> {
  DateTime dateTime = DateTime.now();
  DateFormat dateFormat = DateFormat('dd-MMM-yyyy');
  String date;
  int timeStamp;
  String uid = FirebaseAuth.instance.currentUser.uid;

  final Product product;
  List<String> variableValues, valueTypes;
  String mainValue;
  var SelectedItem;

  bool isAddingToWishList = false;

  bool isAddingToCart = false;

  _BodyState(this.product) {
    variableValues = product.z_variable_values.split(",");
    valueTypes = product.z_value_types.split(",");
    mainValue = product.z_main_value;
    SelectedItem = variableValues[0];
  }
  var numOfItems = 1;
  @override
  Widget build(BuildContext context) {
    date = dateFormat.format(dateTime);
    timeStamp = dateTime.millisecondsSinceEpoch;
    // It provide us total height and width
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: size.height,
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: size.height * 0.3),
                  padding: EdgeInsets.only(
                    top: size.height * 0.12,
                    left: kDefaultPaddin,
                    right: kDefaultPaddin,
                  ),
                  // height: 500,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      Description(product: product),
                      SizedBox(height: kDefaultPaddin / 2),
                      MoreDescription(product: product),
                      SizedBox(
                        height: kDefaultPaddin / 2,
                      ),
                      colorSize(context),
                      SizedBox(height: kDefaultPaddin / 2),
                      counterWithFav(),
                      SizedBox(height: kDefaultPaddin / 2),
                      isAddingToCart
                          ? Center(child: CircularProgressIndicator())
                          : addToCart()
                    ],
                  ),
                ),
                ProductTitleWithImage(product: product)
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget colorSize(context) {
    return Container(
      height: 110,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: kTextColor),
                children: [
                  TextSpan(
                      text: valueTypes.length == 1 ? "" : valueTypes[0] + "\n"),
                  TextSpan(
                    text: valueTypes.length == 1 ? "" : mainValue,
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  valueTypes.length == 1 ? "" : valueTypes[1],
                  style: TextStyle(fontSize: 18),
                ),
                valueTypes.length == 1
                    ? SizedBox()
                    : Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: variableValues.length,
                          itemBuilder: (BuildContext context, int index) {
                            return valueTypes[1] == "Color"
                                ? ColorDot(color: Color(0xFFF8C078))
                                : Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          SelectedItem = variableValues[index];
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.orange),
                                            color: SelectedItem ==
                                                    variableValues[index]
                                                ? Colors.orange
                                                : Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            variableValues[index],
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: SelectedItem ==
                                                        variableValues[index]
                                                    ? Colors.white
                                                    : Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                          },
                        ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget counterWithFav() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        cartCounter(),
        isAddingToWishList
            ? CircularProgressIndicator()
            : CircleAvatar(
                backgroundColor: Colors.red,
                child: IconButton(
                  icon: Icon(
                    Icons.favorite,
                    size: 21,
                  ),
                  onPressed: () {
                    addToWishList(product);
                    setState(() {
                      isAddingToWishList = true;
                    });
                  },
                  color: Colors.white,
                ),
              )
      ],
    );
  }

  Widget cartCounter() {
    return Row(
      children: <Widget>[
        buildOutlineButton(
          icon: Icons.remove,
          press: () {
            if (numOfItems > 1) {
              setState(() {
                numOfItems--;
              });
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin / 2),
          child: Text(
            // if our item is less  then 10 then  it shows 01 02 like that
            numOfItems.toString().padLeft(2, "0"),
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        buildOutlineButton(
            icon: Icons.add,
            press: () {
              if (numOfItems < 10) {
                setState(() {
                  numOfItems++;
                });
              }
            }),
      ],
    );
  }

  SizedBox buildOutlineButton({IconData icon, Function press}) {
    return SizedBox(
      width: 40,
      height: 32,
      child: OutlineButton(
        color: Colors.orange,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        onPressed: press,
        child: Icon(
          icon,
          color: Colors.orange,
        ),
      ),
    );
  }

  Widget addToCart() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin),
      child: Row(
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(right: kDefaultPaddin),
              height: 50,
              width: 58,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Colors.orange,
                ),
              ),
              child: buildOutlineButton(
                  icon: Icons.add_shopping_cart,
                  press: () {
                    saveToCart("cart");
                  })),
          Expanded(
            child: SizedBox(
              height: 50,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                color: Colors.orange,
                onPressed: () {
                  setState(() {
                    isAddingToCart = true;
                  });
                  saveToCart("buy");
                },
                child: Text(
                  "Buy  Now".toUpperCase(),
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void saveToCart(String type) {
    DatabaseReference cartRef =
        FirebaseDatabase.instance.reference().child("CartList").push();
    Map<String, Object> map = Map();

    if (valueTypes.length == 1) {
      map = {
        "Cart_id": cartRef.key,
        "Merchant_id": product.Merchant_id,
        "Owner": uid,
        "Product_Image": product.image0,
        "Product_Price":
            (numOfItems * int.parse(product.Real_Product_price)).toString(),
        "Product_id": product.Product_id,
        "Product_name": product.Product_name,
        "Properties":
            "color: default, size: default, quantity: " + numOfItems.toString(),
        "Publish_on_Date": date,
        "Publish_on_Time": timeStamp,
        "quantity": numOfItems.toString(),
        "state": "not ordered"
      };
    } else {
      if (valueTypes[1] == "Size") {
        map = {
          "Cart_id": cartRef.key,
          "Merchant_id": product.Merchant_id,
          "Owner": uid,
          "Product_Image": product.image0,
          "Product_Price":
              (numOfItems * int.parse(product.Real_Product_price)).toString(),
          "Product_id": product.Product_id,
          "Product_name": product.Product_name,
          "Properties": "color: default, size: " +
              SelectedItem +
              ", quantity: " +
              numOfItems.toString(),
          "Publish_on_Date": date,
          "Publish_on_Time": timeStamp,
          "quantity": numOfItems.toString(),
          "state": "not ordered"
        };
      } else {
        map = {
          "Cart_id": cartRef.key,
          "Merchant_id": product.Merchant_id,
          "Owner": uid,
          "Product_Image": product.image0,
          "Product_Price":
              (numOfItems * int.parse(product.Real_Product_price)).toString(),
          "Product_id": product.Product_id,
          "Product_name": product.Product_name,
          "Properties": "color: " +
              SelectedItem +
              ", size: default, quantity: " +
              numOfItems.toString(),
          "Publish_on_Date": date,
          "Publish_on_Time": timeStamp,
          "quantity": numOfItems.toString(),
          "state": "not ordered"
        };
      }
    }
  
    cartRef.update(map).whenComplete(() {
      Navigator.pop(context);
    });
  }

  void addToWishList(Product product) {
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
      setState(() {
        isAddingToWishList = false;
        Fluttertoast.showToast(msg: "Added to your wish List.");
      });
    });
  }
}
