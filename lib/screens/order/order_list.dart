import 'package:abyssinia_shopping/custom_background.dart';
import 'package:abyssinia_shopping/models/order.dart';
import 'package:abyssinia_shopping/screens/faq_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OrderList extends StatefulWidget {
  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  List<Order> orderList;

  bool haveDriver = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    DatabaseReference orderRef =
        FirebaseDatabase.instance.reference().child("Orders");
    orderRef.once().then((DataSnapshot snapshot) {
      orderList = [];
      setState(() {});

      var values = snapshot.value;
      var keys = snapshot.value.keys;
      for (var key in keys) {
        if (values[key]["Owner"] == FirebaseAuth.instance.currentUser.uid) {
          if (values[key]["driver_id"] == null) {
            Order order = Order(
                values[key]["Address_id"],
                values[key]["Order_id"],
                values[key]["Ordered_on_Date"],
                values[key]["Ordered_on_Time"],
                values[key]["Owner"],
                values[key]["Payment"],
                values[key]["Payment_condition"],
                values[key]["Total_Amount"],
                values[key]["User_name"],
                values[key]["User_phone"],
                values[key]["state"],
                "null",
                "null",
                "null",
                "null");

            orderList.add(order);
            setState(() {});
          } else {
            haveDriver = true;
            DatabaseReference driverRef =
                FirebaseDatabase.instance.reference().child("Drivers");
            driverRef.once().then((DataSnapshot snapshot) {
              haveDriver = false;
              var vals = snapshot.value;
              var kes = snapshot.value.keys;
              for (var ky in kes) {
                if (vals[ky]["driver_id"] == values[key]["driver_id"]) {
                  Order order = Order(
                      values[key]["Address_id"],
                      values[key]["Order_id"],
                      values[key]["Ordered_on_Date"],
                      values[key]["Ordered_on_Time"],
                      values[key]["Owner"],
                      values[key]["Payment"],
                      values[key]["Payment_condition"],
                      values[key]["Total_Amount"],
                      values[key]["User_name"],
                      values[key]["User_phone"],
                      values[key]["state"],
                      values[key]["driver_id"],
                      vals[ky]["driver_image"],
                      vals[ky]["driver_name"],
                      vals[ky]["driver_phone"]);

                  orderList.add(order);
                  setState(() {});
                }
              }
            });
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget appBar = Container(
      height: kToolbarHeight + MediaQuery.of(context).padding.top,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.keyboard_backspace_outlined)),
          Expanded(
              child: Center(
                  child: Text(
            "My Orders",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ))),
        ],
      ),
    );

    return CustomPaint(
      painter: MainBackground(),
      child: Scaffold(
        body: orderList == null
            ? Center(child: CircularProgressIndicator())
            : orderList.length == 0
                ? Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => FaqPage()));
                      },
                      child: Text("You do not have an order. Learn more"),
                    ),
                  )
                : Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      appBar,
                      Flexible(
                        child: ListView.builder(
                          itemCount: orderList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: orderList[index].driver_id != "null"
                                  ? Container(
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.orange),
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Image.network(
                                                    orderList[index]
                                                        .driver_image,
                                                    height: 100,
                                                    width: 100,
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text("Driver name: " +
                                                      orderList[index]
                                                          .driver_name),
                                                  Text("Driver phone: " +
                                                      orderList[index]
                                                          .driver_phone)
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            orderList[index]
                                                                .User_name),
                                                      ),
                                                      Text(
                                                          orderList[index]
                                                              .Ordered_on_Date,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 15))
                                                    ]),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.orange,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      orderList[index].state,
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  )),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : ListTile(
                                      tileColor: Colors.white,
                                      title: Text(orderList[index].User_name),
                                      subtitle: Text(
                                          orderList[index].Ordered_on_Date),
                                      leading: Icon(FontAwesomeIcons.truck),
                                      trailing: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.orange,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              orderList[index].state,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )),
                                    ),
                            );
                          },
                        ),
                      ),
                      haveDriver
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            )
                          : SizedBox()
                    ],
                  ),
      ),
    );
  }
}
