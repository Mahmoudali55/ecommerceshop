// ignore_for_file: unused_import, prefer_const_constructors

import 'package:ecommerce_shop/constants/color.dart';
import 'package:ecommerce_shop/provider/adminMode.dart';
import 'package:ecommerce_shop/provider/cartitem.dart';
import 'package:ecommerce_shop/provider/modelHud.dart';
import 'package:ecommerce_shop/screens/admin/AdminHome.dart';
import 'package:ecommerce_shop/screens/admin/Editproduct.dart';
import 'package:ecommerce_shop/screens/admin/addProduct.dart';
import 'package:ecommerce_shop/screens/admin/mangeproduct.dart';
import 'package:ecommerce_shop/screens/admin/orderScreen.dart';
import 'package:ecommerce_shop/screens/admin/ordersdetails.dart';
import 'package:ecommerce_shop/screens/user/cart_screen.dart';
import 'package:ecommerce_shop/screens/user/home.dart';
import 'package:ecommerce_shop/screens/login_screen.dart';
import 'package:ecommerce_shop/screens/signup_screen.dart';
import 'package:ecommerce_shop/screens/user/productinfo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  bool isUserLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return MaterialApp(
            home: Scaffold(
                body: Center(
              child: Text("Loading......."),
            )),
          );
        } else {
          isUserLoggedIn = snapshot.data!.getBool(kKeepMeLoggedIN) ?? false;
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<ModelHud>(
                create: (context) => ModelHud(),
              ),
              ChangeNotifierProvider<AdminMode>(
                create: (context) => AdminMode(),
              ),
              ChangeNotifierProvider<CartItem>(
                create: (context) => CartItem(),
              )
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: isUserLoggedIn ? HomeScreen.id : LoginScreen.id,
              routes: {
                LoginScreen.id: (context) => LoginScreen(),
                SignupScreen.id: (context) => SignupScreen(),
                HomeScreen.id: (context) => HomeScreen(),
                AdminHome.id: (context) => AdminHome(),
                AddProduct.id: (context) => AddProduct(),
                MangeProduct.id: (context) => MangeProduct(),
                EditProduct.id: (context) => EditProduct(),
                ProductInfo.id: (context) => ProductInfo(),
                CartSCreen.id: (context) => CartSCreen(),
                OrdersScreen.id: (context) => OrdersScreen(),
                OrdersDetails.id: (context) => OrdersDetails(),
              },
            ),
          );
        }
      },
    );
  }
}
