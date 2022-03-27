import 'package:abyssinia_shopping/models/address.dart';
import 'package:abyssinia_shopping/models/cart.dart';
import 'package:abyssinia_shopping/models/payment.dart';
import 'package:abyssinia_shopping/models/product.dart';
import 'package:abyssinia_shopping/screens/address/add_address_page.dart';
import 'package:abyssinia_shopping/screens/address/addressList.dart';

import 'package:abyssinia_shopping/screens/faq_page.dart';
import 'package:abyssinia_shopping/screens/main/main_page.dart';

import 'package:abyssinia_shopping/screens/shop/shop_item_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import '../../app_properties.dart';


//TODO: NOT DONE. WHEEL SCROLL QUANTITY
class CheckOutPage extends StatefulWidget {
  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  SwiperController swiperController = SwiperController();
  DatabaseReference cartRef =
      FirebaseDatabase.instance.reference().child("CartList");
  String orderPolicy =
      "1: An adult who accepts your orders must be at the location.\n2: If no one accepts your order and you want to take it another time, you will have to pay extra money.\n3: After we have delivered your products, you will be punished by law for not wanting to accept without good reason.\n4: Do not take your products without knowing the full health of your product and without signing that it was completely healthy.\n5: We will be responsible for any damage to your products before you get it.";
  List<Cart> cartList;
  List<Address> myAddresses = [];
  Address address;
  Payment payment;
  List<String> userInfos;
  var totalPrice = 0;
  TextEditingController userPhoneController = TextEditingController(),
      userNameController = TextEditingController();
  List<Payment> payments = [
    Payment("You will pay when you get your order", FontAwesomeIcons.truck,
        "Cash On Delivery")
  ];

  bool isOrdering = false;

  bool isAgreed = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DatabaseReference addressRef =
        FirebaseDatabase.instance.reference().child("Address");
    addressRef.once().then((DataSnapshot dataSnapShot) {
      var values = dataSnapShot.value;
      var keys = dataSnapShot.value.keys;
      for (var key in keys) {
        if (values[key]["owner"] == FirebaseAuth.instance.currentUser.uid) {
          Address address = Address(
              values[key]["Address_name"],
              values[key]["address_id"],
              values[key]["city"],
              values[key]["homeNumber"],
              values[key]["latitude"],
              values[key]["longitude"],
              values[key]["moreInfo"],
              values[key]["owner"],
              values[key]["subcity"],
              values[key]["wereda"]);

          myAddresses.add(address);
          setState(() {});
        }
      }
    });
    getCart();
  }

  void getCart() {
    cartRef.once().then((DataSnapshot snapshot) {
      var values = snapshot.value;
      var keys = snapshot.value.keys;
      cartList = [];
      setState(() {});
      for (var key in keys) {
        if (values[key]["Owner"] == FirebaseAuth.instance.currentUser.uid) {
          if (values[key]["state"] == "not ordered") {
            Cart cart = Cart(
                values[key]["Cart_id"],
                values[key]["Merchant_id"],
                values[key]["Owner"],
                values[key]["Product_Image"],
                values[key]["Product_Price"],
                values[key]["Product_name"],
                values[key]["Properties"],
                values[key]["Publish_on_Date"],
                values[key]["Publish_on_Time"],
                values[key]["quantity"],
                values[key]["state"]);
            cartList.add(cart);
            setState(() {});
          }
        }
      }
    });
  }

  @override
    void dispose() {
      // TODO: implement dispose
      super.dispose();
    }

  void showDialog() {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 300,
            child: SizedBox.expand(
                child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    Center(
                        child: Text(
                      "Order Policy",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )),
                    Container(
                        child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        orderPolicy,
                        style: TextStyle(fontSize: 18),
                      ),
                    )),
                  ],
                ),
              ),
            )),
            margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget checkOutButton = InkWell(
      onTap: () {
        if (payment != null && address != null && userInfos != null) {
          if (isAgreed) {
            setState(() {
              isOrdering = true;
            });
            DateTime dateTime = DateTime.now();
            DateFormat dateFormat = DateFormat('dd-MMM-yyyy');
            String date = dateFormat.format(dateTime);
            int timeStamp = dateTime.millisecondsSinceEpoch;
            DatabaseReference orderRef =
                FirebaseDatabase.instance.reference().child("Orders").push();

            Map<String, Object> map = Map();
            map = {
              "Address_id": address.address_id,
              "Order_id": orderRef.key,
              "Ordered_on_Date": date,
              "Ordered_on_Time": timeStamp.toString(),
              "Owner": FirebaseAuth.instance.currentUser.uid,
              "Payment": payment.pymentName,
              "Payment_condition": "payed",
              "Total_Amount": totalPrice.toString(),
              "User_name": userInfos[0],
              "User_phone": userInfos[1],
              "state": "not shipped"
            };
            for (var cart in cartList) {
              cartRef.child(cart.Cart_id).child("Order_id").set(orderRef.key);
              cartRef.child(cart.Cart_id).child("state").set("ordered");

            }

            orderRef.update(map).whenComplete(() {
              Fluttertoast.showToast(
                  msg:
                      "Congratulations! We recived your order, soon we will deliver to you.");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => MainPage()));
            });
          } else {
            Fluttertoast.showToast(msg: "Please agree the order policy");
          }
        } else {
          Fluttertoast.showToast(
              msg:
                  "Please choose your address and payment and then fill your information");
        }
      },
      child: Container(
        height: 80,
        width: MediaQuery.of(context).size.width / 1.5,
        decoration: BoxDecoration(
            gradient: mainButton,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.16),
                offset: Offset(0, 5),
                blurRadius: 10.0,
              )
            ],
            borderRadius: BorderRadius.circular(9.0)),
        child: Center(
          child: Text("Order",
              style: const TextStyle(
                  color: const Color(0xfffefefe),
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  fontSize: 20.0)),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: darkGrey),
        actions: <Widget>[
          // IconButton(
          //   icon: Image.asset('assets/icons/denied_wallet.png'),
          //   onPressed: () => Navigator.of(context)
          //       .push(MaterialPageRoute(builder: (_) => UnpaidPage())),
          // )
        ],
        title: Text(
          'Checkout',
          style: TextStyle(
              color: darkGrey, fontWeight: FontWeight.w500, fontSize: 18.0),
        ),
      ),
      body: cartList == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : cartList.length == 0
              ? Center(
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => FaqPage()));
                      },
                      child: Text(
                          "You do not have product on your cart. Learn more")),
                )
              : LayoutBuilder(
                  builder: (_, constraints) => SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 32.0),
                            height: 60,
                            color: yellow,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                headers(cartList, "totalnum"),
                                SizedBox(
                                  height: 10,
                                ),
                                headers(cartList, "totalprice")
                              ],
                            ),
                          ),
                          cartList == null
                              ? SizedBox(
                                  height: 100,
                                )
                              : SizedBox(
                                  height: 300,
                                  child: Scrollbar(
                                    child: ListView.builder(
                                      itemBuilder: (_, index) => ShopItemList(
                                        cartList[index],
                                        onRemove: () {
                                          setState(() {
                                            cartRef
                                                .child(cartList[index].Cart_id)
                                                .remove()
                                                .whenComplete(() {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          MainPage()));
                                            });
                                            Fluttertoast.showToast(
                                                msg: "Item removed");
                                          });
                                        },
                                      ),
                                      itemCount: cartList.length,
                                    ),
                                  ),
                                ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  'Last Step',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: darkGrey,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(height: 24),
                              ExpansionTile(
                                leading: Icon(
                                  Icons.check_circle,
                                  color: address != null
                                      ? Colors.green
                                      : Colors.black54,
                                ),
                                title: Text("Choose Address"),
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(),
                                      ),
                                      GestureDetector(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Go To Address",
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddressList()));
                                        },
                                      )
                                    ],
                                  ),
                                  myAddresses.length == 0
                                      ? GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        FaqPage()));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(40),
                                            child: Text(
                                                "You don't have an address. Learn more"),
                                          ),
                                        )
                                      : Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 200,
                                          child: ListView.builder(
                                              itemCount: myAddresses.length,
                                              itemBuilder: (context, index) {
                                                Color color = address ==
                                                        myAddresses[index]
                                                    ? Colors.white
                                                    : Colors.black54;
                                                return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          address = myAddresses[
                                                              index];
                                                        });
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: address ==
                                                                    myAddresses[
                                                                        index]
                                                                ? Colors.orange
                                                                : Colors.white,
                                                            border: Border.all(
                                                                color: Colors
                                                                    .orange),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15)),
                                                        child: ListTile(
                                                          title: Text(
                                                            myAddresses[index]
                                                                .Address_name,
                                                            style: TextStyle(
                                                                color: color),
                                                          ),
                                                          subtitle: Text(
                                                              myAddresses[index]
                                                                      .latitude +
                                                                  ", " +
                                                                  myAddresses[
                                                                          index]
                                                                      .longitude,
                                                              style: TextStyle(
                                                                  color:
                                                                      color)),
                                                          leading: Icon(
                                                            Icons
                                                                .location_on_outlined,
                                                            color: color,
                                                          ),
                                                        ),
                                                      ),
                                                    ));
                                              }))
                                ],
                              ),
                              ExpansionTile(
                                title: Text("Choose Payment"),
                                leading: Icon(
                                  Icons.check_circle,
                                  color: payment != null
                                      ? Colors.green
                                      : Colors.black54,
                                ),
                                children: [
                                  Container(
                                    height: 200,
                                    width: MediaQuery.of(context).size.width,
                                    child: ListView.builder(
                                      itemCount: payments.length,
                                      itemBuilder: (context, index) {
                                        Color paymentColor =
                                            payment == payments[index]
                                                ? Colors.white
                                                : Colors.black54;
                                        return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    payment = payments[index];
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: payment ==
                                                              payments[index]
                                                          ? Colors.orange
                                                          : Colors.white,
                                                      border: Border.all(
                                                          color: Colors.orange),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                  child: ListTile(
                                                    title: Text(
                                                      payments[index]
                                                          .pymentName,
                                                      style: TextStyle(
                                                          color: paymentColor),
                                                    ),
                                                    leading: Icon(
                                                      payments[index]
                                                          .paymentIcon,
                                                      color: paymentColor,
                                                    ),
                                                    subtitle: Text(
                                                        payments[index]
                                                            .paymentDescription,
                                                        style: TextStyle(
                                                            color:
                                                                paymentColor)),
                                                  ),
                                                )));
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              ExpansionTile(
                                title: Text("Fill your Information"),
                                leading: Icon(
                                  Icons.check_circle,
                                  color: userInfos != null
                                      ? Colors.green
                                      : Colors.black54,
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 16.0,
                                                top: 4.0,
                                                bottom: 4.0),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              color: Colors.grey,
                                            ),
                                            child: TextField(
                                              controller: userNameController,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'User Name'),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 16.0,
                                                top: 4.0,
                                                bottom: 4.0),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              color: Colors.grey,
                                            ),
                                            child: TextField(
                                              controller: userPhoneController,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'User Phone'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: RaisedButton(
                                      color: Colors.orange,
                                      child: Text(
                                        "Save",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        if (userNameController.text.length !=
                                                0 &&
                                            userPhoneController.text.length !=
                                                0) {
                                          setState(() {
                                            userInfos = [
                                              userNameController.text,
                                              userPhoneController.text
                                            ];
                                          });
                                          Fluttertoast.showToast(msg: "Saved");
                                        } else {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Please your Name and phone");
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                    onChanged: (bool value) {
                                      setState(() {
                                        isAgreed = value;
                                      });
                                    },
                                    value: isAgreed,
                                  ),
                                  Text("I will agree on "),
                                  GestureDetector(
                                      onTap: () {
                                        showDialog();
                                      },
                                      child: Text(
                                        "order policy",
                                        style: TextStyle(color: Colors.blue),
                                      ))
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Total price : ${totalPrice}"),
                              Text("We will deliver to you in 10 to 20 hours."),
                              SizedBox(
                                height: 24,
                              ),
                              Center(
                                  child: Padding(
                                padding: EdgeInsets.only(
                                    bottom:
                                        MediaQuery.of(context).padding.bottom ==
                                                0
                                            ? 20
                                            : MediaQuery.of(context)
                                                .padding
                                                .bottom),
                                child: isOrdering
                                    ? CircularProgressIndicator()
                                    : checkOutButton,
                              ))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }

  Widget headers(List<Cart> cartList, type) {
    if (type != "totalnum") {
      totalPrice = 0;
      for (var cart in cartList) {
        totalPrice += int.parse(cart.Product_Price);
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          type == "totalnum" ? 'Subtotal' : 'TotalPrice',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          type == "totalnum"
              ? cartList.length.toString() + ' items'
              : "ETB " + totalPrice.toString(),
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        )
      ],
    );
  }
}

class Scroll extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint

    LinearGradient grT = LinearGradient(
        colors: [Colors.transparent, Colors.black26],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter);
    LinearGradient grB = LinearGradient(
        colors: [Colors.transparent, Colors.black26],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter);

    canvas.drawRect(
        Rect.fromLTRB(0, 0, size.width, 30),
        Paint()
          ..shader = grT.createShader(Rect.fromLTRB(0, 0, size.width, 30)));

    canvas.drawRect(Rect.fromLTRB(0, 30, size.width, size.height - 40),
        Paint()..color = Color.fromRGBO(50, 50, 50, 0.4));

    canvas.drawRect(
        Rect.fromLTRB(0, size.height - 40, size.width, size.height),
        Paint()
          ..shader = grB.createShader(
              Rect.fromLTRB(0, size.height - 40, size.width, size.height)));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}
