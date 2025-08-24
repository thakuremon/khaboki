import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:khaboki2/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> createUserProfile(
  User user,
  String role,
  String mail,
  String gender,
) async {
  await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
    'role': role,
    'mail': mail,
  }, SetOptions(merge: true));
}

Future<void> placeOrder({
  required String vendorId,
  required String customerId,
  required String productName,
  required String productPicture,
  required String productDetails,
  required int productCount,
  required double totalCost,
  required DateTime expireTime,
}) async {
  final db = FirebaseFirestore.instance;
  final counterRef = db.collection("counters").doc("orders");

  await db.runTransaction((transaction) async {
    // Get the current counter
    final snapshot = await transaction.get(counterRef);
    int lastId = snapshot.exists ? snapshot["lastOrderId"] : 0;
    int newId = lastId + 1;

    // Build order data
    final orderData = {
      "orderId": newId,
      "vendorId": vendorId,
      "customerId": customerId,
      "productName": productName,
      "productPicture": productPicture,
      "productDetails": productDetails,
      "productCount": productCount,
      "totalCost": totalCost,
      "expireTime": Timestamp.fromDate(expireTime),
      "createdAt": FieldValue.serverTimestamp(),
    };

    // Save order with the same newId as the docId (optional)
    final orderRef = db.collection("orders").doc(newId.toString());
    transaction.set(orderRef, orderData);

    // Update counter
    transaction.set(counterRef, {"lastOrderId": newId});
  });
}

Future<void> addProduct({
  required String vendorId,
  required String name,
  required String description,
  required double cost,
  required DateTime expireTime,
  required String photoUrl,
}) async {
  final db = FirebaseFirestore.instance;
  final counterRef = db.collection("counters").doc("products");

  await db.runTransaction((transaction) async {
    // Get current product counter
    final snapshot = await transaction.get(counterRef);
    int lastId = snapshot.exists ? snapshot["lastProductId"] : 0;
    int newId = lastId + 1;

    // Build product data
    final productData = {
      "itemId": newId,
      "vendorId": vendorId,
      "name": name,
      "description": description,
      "cost": cost,
      "expireTime": Timestamp.fromDate(expireTime),
      "photo": photoUrl,
      "createdAt": FieldValue.serverTimestamp(),
    };

    // Save product with itemId as docId
    final productRef = db.collection("products").doc(newId.toString());
    transaction.set(productRef, productData);

    // Update product counter
    transaction.set(counterRef, {"lastProductId": newId});
  });
}
