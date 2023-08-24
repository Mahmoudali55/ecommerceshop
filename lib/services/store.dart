// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_shop/constants/color.dart';
import 'package:ecommerce_shop/models/product.dart';

class Store {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  addProduct(Product product) {
    _firebaseFirestore.collection(kProductCollection).add({
      kProductName: product.pName,
      kProductPrice: product.pPrice,
      kProductCategory: product.pCategory,
      kProductDescription: product.pDescription,
      kProductlocation: product.pLocation
    });
  }

  Stream<QuerySnapshot<Map>> loadProducts() {
    return _firebaseFirestore.collection(kProductCollection).snapshots();
  }

  Stream<QuerySnapshot> loadOrders() {
    return _firebaseFirestore.collection(kOrders).snapshots();
  }

  Stream<QuerySnapshot> loadOrderDetails(documentId) {
    return _firebaseFirestore
        .collection(kOrders)
        .doc(documentId)
        .collection(kOrderDetails)
        .snapshots();
  }

  deleteProduct(documentId) {
    _firebaseFirestore.collection(kProductCollection).doc(documentId).delete();
  }

  editProduct(date, documentId) {
    _firebaseFirestore
        .collection(kProductCollection)
        .doc(documentId)
        .update(date);
  }

  storeOrders(data, List<Product> products) {
    var documentRef = _firebaseFirestore.collection(kOrders).doc();
    documentRef.set(data);
    for (var product in products) {
      documentRef.collection(kOrderDetails).doc().set({
        kProductName: product.pName,
        kProductPrice: product.pPrice,
        kProductlocation: product.pLocation,
        kProductQuantity: product.pQuantity,
        kProductCategory: product.pCategory,
      });
    }
  }
}
