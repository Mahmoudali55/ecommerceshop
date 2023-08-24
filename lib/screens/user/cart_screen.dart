// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_shop/constants/color.dart';
import 'package:ecommerce_shop/models/product.dart';
import 'package:ecommerce_shop/provider/cartitem.dart';
import 'package:ecommerce_shop/screens/user/productinfo.dart';
import 'package:ecommerce_shop/services/store.dart';
import 'package:ecommerce_shop/widgets/custom_meun.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartSCreen extends StatelessWidget {
  static String id = 'CartSCreen';

  @override
  Widget build(BuildContext context) {
    List<Product> products = Provider.of<CartItem>(context).products;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double appBarHeight = AppBar().preferredSize.height;
    final double stateBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: mainColor,
        elevation: 0,
        title: Text(
          "My Cart",
        ),
      ),
      body: Column(
        children: [
          LayoutBuilder(builder: (context, constraints) {
            if (products.isNotEmpty) {
              return Container(
                height: screenHeight -
                    stateBarHeight -
                    appBarHeight -
                    (screenHeight * .08),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(15),
                      child: GestureDetector(
                        onTapUp: (details) {
                          showCustomMenu(details, context, products[index]);
                        },
                        child: Container(
                          height: screenHeight * .15,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: screenHeight * .15 / 2,
                                backgroundImage:
                                    AssetImage(products[index].pLocation!),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 80),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            products[index].pName!,
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            '\$ ${products[index].pPrice}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: Text(
                                        products[index].pQuantity.toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          color: secondaryColor,
                        ),
                      ),
                    );
                  },
                  itemCount: products.length,
                ),
              );
            } else {
              return Container(
                height: screenHeight -
                    (screenHeight * .08) -
                    appBarHeight -
                    stateBarHeight,
                child: Center(
                  child: Text(
                    "cart is Empty",
                    style: TextStyle(fontSize: 40),
                  ),
                ),
              );
            }
          }),
          Builder(builder: (context) {
            return ButtonTheme(
              minWidth: screenWidth,
              height: screenHeight * .08,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10))),
                onPressed: () {
                  showCUstomDialog(products, context);
                },
                child: Text('order'.toUpperCase()),
                color: mainColor,
              ),
            );
          })
        ],
      ),
    );
  }

  void showCustomMenu(details, context, product) async {
    double dx = details.globalPosition.dx;
    double dy = details.globalPosition.dy;
    double dx2 = MediaQuery.of(context).size.width - dx;
    double dy2 = MediaQuery.of(context).size.width - dy;
    await showMenu(
        context: context,
        position: RelativeRect.fromLTRB(dx, dy, dx2, dy2),
        items: [
          MyPopupMenuItem(
            onClick: () {
              Navigator.pop(context);
              Provider.of<CartItem>(context, listen: false)
                  .deleteProduct(product);
              Navigator.pushNamed(context, ProductInfo.id, arguments: product);
            },
            child: Text("Edit"),
          ),
          MyPopupMenuItem(
            onClick: () {
              Navigator.pop(context);
              Provider.of<CartItem>(context, listen: false)
                  .deleteProduct(product);
            },
            child: Text("Delete"),
          )
        ]);
  }

  void showCUstomDialog(List<Product> products, context) async {
    var price = getTotallPrice(products);
    var address;
    AlertDialog alertDialog = AlertDialog(
      actions: [
        MaterialButton(
          onPressed: () {
            try {
              Store _story = Store();
              _story.storeOrders({
                kTotallPrice: price,
                kAddress: address,
              }, products);
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Ordered successfull')));
              Navigator.pop(context);
            } catch (ex) {
              print(ex);
            }
          },
          child: Text('Confirm'),
        ),
      ],
      content: TextField(
        onChanged: (value) {
          address = value;
        },
        decoration: InputDecoration(hintText: 'Enter your Address'),
      ),
      title: Text('Total Price =\$ $price'),
    );
    await showDialog(
        context: context,
        builder: (context) {
          return alertDialog;
        });
  }

  getTotallPrice(List<Product> products) {
    var price = 0;
    for (var product in products) {
      price += product.pQuantity! * int.parse(product.pPrice!);
    }
    return price;
  }
}
