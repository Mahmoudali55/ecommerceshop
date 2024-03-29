import 'package:ecommerce_shop/models/product.dart';
import 'package:ecommerce_shop/screens/user/productinfo.dart';
import 'package:ecommerce_shop/widgets/function.dart';
import 'package:flutter/material.dart';

Widget productsView(String pCategory, List<Product> allProducts) {
  List<Product> products;
  products = getProductByCategory(pCategory, allProducts);
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
}
