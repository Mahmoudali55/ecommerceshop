import 'package:ecommerce_shop/constants/color.dart';
import 'package:ecommerce_shop/models/product.dart';
import 'package:ecommerce_shop/services/store.dart';
import 'package:ecommerce_shop/widgets/customer_textfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EditProduct extends StatelessWidget {
  static String id = 'EditProduct.id';
  String? name, price, description, category, imagelocation;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final _store = Store();

  @override
  Widget build(BuildContext context) {
    Product? product = ModalRoute.of(context)!.settings.arguments as Product?;
    return Scaffold(
      body: Form(
        key: _globalKey,
        child: ListView(children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * .2,
          ),
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                    _store.editProduct(
                        ({
                          kProductName: name,
                          kProductCategory: category,
                          kProductDescription: description,
                          kProductlocation: imagelocation,
                          kProductPrice: price,
                        }),
                        product!.pId);
                  }
                },
                child: Text("Add Product"))
          ]),
        ]),
      ),
    );
  }
}
