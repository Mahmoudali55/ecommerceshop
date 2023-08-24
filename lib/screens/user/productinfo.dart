// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'package:ecommerce_shop/constants/color.dart';
import 'package:ecommerce_shop/models/product.dart';
import 'package:ecommerce_shop/provider/cartitem.dart';
import 'package:ecommerce_shop/screens/user/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductInfo extends StatefulWidget {
  const ProductInfo({super.key});
  static String id = 'ProductInfo';

  @override
  State<ProductInfo> createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  int _quantity = 1;
  @override
  Widget build(BuildContext context) {
    Product? product = ModalRoute.of(context)!.settings.arguments as Product?;
    return Scaffold(
      body: Stack(
        children: [
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image(
                  fit: BoxFit.fill, image: AssetImage(product!.pLocation!))),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: Container(
              height: MediaQuery.of(context).size.height * .1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back_ios)),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, CartSCreen.id);
                      },
                      child: Icon(Icons.shopping_cart))
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Column(
              children: [
                Opacity(
                  opacity: 0.5,
                  child: Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * .3,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.pName!,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              product.pDescription!,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w800),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '  \$${product.pPrice}',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w800),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipOval(
                                  child: Material(
                                    color: secondaryColor,
                                    child: GestureDetector(
                                      onTap: add,
                                      child: SizedBox(
                                        child: Icon(Icons.add),
                                        height: 28,
                                        width: 28,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  _quantity.toString(),
                                  style: TextStyle(
                                    fontSize: 60,
                                  ),
                                ),
                                ClipOval(
                                  child: Material(
                                    color: secondaryColor,
                                    child: GestureDetector(
                                      onTap: subtract,
                                      child: SizedBox(
                                        child: Icon(Icons.remove),
                                        height: 28,
                                        width: 28,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ]),
                    ),
                  ),
                ),
                ButtonTheme(
                  minWidth: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * .08,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                  )),
                  child: Builder(builder: (context) {
                    return MaterialButton(
                      color: mainColor,
                      onPressed: () {
                        addToCart(context, product);
                      },
                      child: Text(
                        "Add to cart".toUpperCase(),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    );
                  }),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  subtract() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  add() {
    setState(() {
      _quantity++;
    });
  }

  void addToCart(context, product) {
    CartItem cartItem = Provider.of<CartItem>(context, listen: false);
    product.pQuantity = _quantity;
    bool exist = false;
    var productsInCart = cartItem.products;
    for (var productInCart in productsInCart) {
      if (productInCart.pLocation == product.pLocation) {
        exist = true;
      }
    }
    if (exist) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('you\ve added this item before')));
    } else {
      cartItem.addProduct(product);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Added to cart')));
    }
  }
}
