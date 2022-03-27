import 'package:abyssinia_shopping/models/category.dart';
import 'package:abyssinia_shopping/models/product.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final List<Product> products;

  const CategoryCard(this.category, this.products);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
          onTap: () {},
          child: Container(
            child: Column(
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(category.CategoryImage),
                        radius: 25,
                      ),
                    ),
                    Positioned(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text(
                            category.productNumber,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    category.CategoryName,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
