// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_shop/constants/color.dart';
import 'package:ecommerce_shop/models/product.dart';
import 'package:ecommerce_shop/screens/admin/Editproduct.dart';
import 'package:ecommerce_shop/services/store.dart';
import 'package:ecommerce_shop/widgets/custom_meun.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MangeProduct extends StatefulWidget {
  static String id = 'MangeProduct';

  @override
  State<MangeProduct> createState() => _MangeProductState();
}

class _MangeProductState extends State<MangeProduct> {
  final _store = Store();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<QuerySnapshot<Map>>(
      stream: _store.loadProducts(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Product> products = [];
          for (var doc in snapshot.data!.docs) {
            var data = doc.data();
            products.add(Product(
                pId: doc.id,
                pName: data[kProductName],
                pPrice: data[kProductPrice],
                pDescription: data[kProductDescription],
                pLocation: data[kProductlocation],
                pCategory: data[kProductCategory]));
          }
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: .8),
            itemBuilder: (context, Index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: GestureDetector(
                onTapUp: (details) {
                  double dx = details.globalPosition.dx;
                  double dy = details.globalPosition.dy;
                  double dx2 = MediaQuery.of(context).size.width - dx;
                  double dy2 = MediaQuery.of(context).size.width - dy;
                  showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(dx, dy, dx2, dy2),
                      items: [
                        MyPopupMenuItem(
                          onClick: () {
                            Navigator.pushNamed(context, EditProduct.id,
                                arguments: products[Index]);
                          },
                          child: Text("Edit"),
                        ),
                        MyPopupMenuItem(
                          onClick: () {
                            _store.deleteProduct(products[Index].pId);
                            Navigator.pop(context);
                          },
                          child: Text("Delete"),
                        )
                      ]);
                },
                child: Stack(
                  children: [
                    Positioned.fill(
                        child: Image(
                            fit: BoxFit.fill,
                            image: AssetImage(products[Index].pLocation!))),
                    Positioned(
                      bottom: 0,
                      child: Opacity(
                        opacity: .6,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  products[Index].pName!,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('\$ ${products[Index].pPrice}')
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            itemCount: products.length,
          );
        } else {
          return Center(child: Text("loadding......."));
        }
      },
    ));
  }
}
