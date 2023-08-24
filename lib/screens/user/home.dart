// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_shop/constants/color.dart';
import 'package:ecommerce_shop/models/product.dart';
import 'package:ecommerce_shop/screens/login_screen.dart';
import 'package:ecommerce_shop/screens/user/cart_screen.dart';
import 'package:ecommerce_shop/screens/user/productinfo.dart';
import 'package:ecommerce_shop/services/auth.dart';
import 'package:ecommerce_shop/services/store.dart';
import 'package:ecommerce_shop/widgets/function.dart';
import 'package:ecommerce_shop/widgets/productview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'HomeScreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = Auth();
  late Firebase _LoggedUser;
  int _tabBarIndex = 0;
  int _bottmBarIndex = 0;
  final _store = Store();
  List<Product> _products = [];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DefaultTabController(
          length: 4,
          child: Scaffold(
            bottomNavigationBar: BottomNavigationBar(
                fixedColor: mainColor,
                type: BottomNavigationBarType.fixed,
                currentIndex: _bottmBarIndex,
                onTap: (value) async {
                  if (value == 2) {
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    pref.clear();
                    await _auth.SignOut();
                    Navigator.popAndPushNamed(context, LoginScreen.id);
                  }
                  setState(() {
                    _bottmBarIndex = value;
                  });
                },
                items: [
                  BottomNavigationBarItem(
                      label: "Home", icon: Icon(Icons.home)),
                  BottomNavigationBarItem(
                      label: "Setting",
                      icon: Icon(Icons.settings),
                      backgroundColor: mainColor),
                  BottomNavigationBarItem(
                      label: "Sign OUt", icon: Icon(Icons.logout)),
                ]),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              bottom: TabBar(
                  indicatorColor: mainColor,
                  onTap: (value) {
                    setState(() {
                      _tabBarIndex = value;
                    });
                  },
                  tabs: [
                    Text('Jackets',
                        style: TextStyle(
                          color:
                              _tabBarIndex == 0 ? Colors.black : kunActiveColor,
                          fontSize: _tabBarIndex == 0 ? 16 : 10,
                        )),
                    Text('Trouser',
                        style: TextStyle(
                          color:
                              _tabBarIndex == 1 ? Colors.black : kunActiveColor,
                          fontSize: _tabBarIndex == 1 ? 16 : 10,
                        )),
                    Text('T-Shirts',
                        style: TextStyle(
                          color:
                              _tabBarIndex == 2 ? Colors.black : kunActiveColor,
                          fontSize: _tabBarIndex == 2 ? 16 : 10,
                        )),
                    Text('Shoes',
                        style: TextStyle(
                          color:
                              _tabBarIndex == 3 ? Colors.black : kunActiveColor,
                          fontSize: _tabBarIndex == 3 ? 16 : 10,
                        )),
                  ]),
            ),
            body: TabBarView(children: [
              jacketView(),
              productsView(kTrousers, _products),
              productsView(kTshirts, _products),
              productsView(kShoes, _products),
            ]),
          ),
        ),
        Material(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: Container(
              height: MediaQuery.of(context).size.height * .1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Discover".toUpperCase(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, CartSCreen.id);
                      },
                      child: Icon(Icons.shopping_cart))
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  getCurrentUser() async {
    _LoggedUser = await _auth.getuser();
  }

  Widget jacketView() {
    return StreamBuilder<QuerySnapshot<Map>>(
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
          _products = [...products];
          products.clear();
          products = getProductByCategory(kJackets, _products);

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: .8),
            itemBuilder: (context, Index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, ProductInfo.id,
                      arguments: products[Index]);
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
    );
  }
}
