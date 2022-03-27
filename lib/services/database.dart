import 'package:abyssinia_shopping/models/product.dart';
import 'package:firebase_database/firebase_database.dart';

class Data {
  List<Product> productsList() {
    List<Product> products = [];
    DatabaseReference productRef =
        FirebaseDatabase.instance.reference().child("Products");
    productRef.once().then((DataSnapshot snapshot) {
      var keys = snapshot.value.keys;
      var values = snapshot.value;

      
    });
    // return products;
  }
}
