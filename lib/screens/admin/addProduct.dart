// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_field

import 'package:ecommerce_shop/models/product.dart';
import 'package:ecommerce_shop/services/store.dart';
import 'package:ecommerce_shop/widgets/customer_textfield.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProduct extends StatelessWidget {
  static String id = 'AddProduct';
  String? name, price, description, category, imagelocation;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final _store = Store();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _globalKey,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          CustomTextField(
              icon: Icons.person,
              hint: "Product Name",
              OnClick: (value) {
                name = value!;
              }),
          SizedBox(
            height: 10,
          ),
          CustomTextField(
              icon: Icons.price_change,
              hint: " Product price",
              OnClick: (value) {
                price = value!;
              }),
          SizedBox(
            height: 10,
          ),
          CustomTextField(
              icon: Icons.description,
              hint: "Product Description",
              OnClick: (value) {
                description = value!;
              }),
          SizedBox(
            height: 10,
          ),
          CustomTextField(
              icon: Icons.list,
              hint: "product Gategory",
              OnClick: (value) {
                category = value!;
              }),
          SizedBox(
            height: 10,
          ),
          CustomTextField(
              icon: Icons.location_on,
              hint: "product Location",
              OnClick: (value) {
                imagelocation = value!;
              }),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () {
                if (_globalKey.currentState!.validate()) {
                  _globalKey.currentState!.save();
                  _store.addProduct(Product(
                    pId: id,
                    pName: name!,
                    pPrice: price!,
                    pCategory: category!,
                    pDescription: description!,
                    pLocation: imagelocation!,
                  ));
                }
              },
              child: Text("Add Product"))
        ]),
      ),
    );
  }
}
