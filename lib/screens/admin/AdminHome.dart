// ignore_for_file: prefer_const_constructors

import 'package:ecommerce_shop/constants/color.dart';
import 'package:ecommerce_shop/screens/admin/addProduct.dart';
import 'package:ecommerce_shop/screens/admin/mangeproduct.dart';
import 'package:ecommerce_shop/screens/admin/orderScreen.dart';
import 'package:flutter/material.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});
  static String id = 'AdminHome';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AddProduct.id);
                },
                child: Text("Add product")),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, MangeProduct.id);
                },
                child: Text("Edit product")),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, OrdersScreen.id);
                },
                child: Text("view Orders")),
          ]),
    );
  }
}
