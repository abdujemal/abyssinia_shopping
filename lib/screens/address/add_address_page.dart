import 'package:abyssinia_shopping/app_properties.dart';
import 'package:abyssinia_shopping/models/city.dart';
import 'package:abyssinia_shopping/screens/address/address_form.dart';
import 'package:abyssinia_shopping/screens/faq_page.dart';
import 'package:flutter/material.dart';



class AddAddressPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: darkGrey),
        actions: [
          IconButton(
            icon: Icon(Icons.help_sharp),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => FaqPage()));
            },
          )
        ],
        title: Text(
          'Add Address',
          style: const TextStyle(
              color: darkGrey,
              fontWeight: FontWeight.w500,
              fontFamily: "Montserrat",
              fontSize: 18.0),
        ),
      ),
      body: LayoutBuilder(
        builder: (_, viewportConstraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: viewportConstraints.maxHeight),
            child: Container(
              padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: MediaQuery.of(context).padding.bottom == 0
                      ? 20
                      : MediaQuery.of(context).padding.bottom),
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.location_on_outlined,
                    size: 90,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Add Your Address",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  AddAddressForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
