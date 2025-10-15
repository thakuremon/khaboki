import 'all_files.dart';

Future<void> createUserProfile(
  User user,
  String name,
  String id,
  String mail,
  String phone,
  String role,
  String photoUrl,
) async {
  await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
    'name': name,
    'id': id,
    'mail': mail,
    'phone': phone,
    'role': role,
    'photoUrl': photoUrl,
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
    final snapshot = await transaction.get(counterRef);
    int lastId = snapshot.exists ? snapshot["lastOrderId"] : 0;
    int newId = lastId + 1;

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

    final orderRef = db.collection("orders").doc(newId.toString());
    transaction.set(orderRef, orderData);

    transaction.set(counterRef, {"lastOrderId": newId});
  });
}

Future<void> createProduct({
  required String vendoruId,
  required String productName,
  required String produceDetails,
  required double costPerUnit,
  required int quantityAvailable,
  required DateTime expireTime,
  //required String photoUrl,
}) async {
  final db = FirebaseFirestore.instance;
  final counterRef = db.collection("counters").doc("products");

  await db.runTransaction((transaction) async {
    final snapshot = await transaction.get(counterRef);
    int lastId = snapshot.exists ? snapshot["lastProductId"] : 0;
    int newId = lastId + 1;

    final productData = {
      "itemId": newId,
      "vendoruId": vendoruId,
      "productName": productName,
      "productDetails": produceDetails,
      "costPerUnit": costPerUnit,
      "quantityAvailable": quantityAvailable,
      "expireTime": Timestamp.fromDate(expireTime),
      //"photoUrl": photoUrl,
      "createdAt": FieldValue.serverTimestamp(),
    };

    final productRef = db.collection("products").doc(newId.toString());
    transaction.set(productRef, productData);

    transaction.set(counterRef, {"lastProductId": newId});
  });
}

Future<List<Map<String, dynamic>>> getProductsByVendor(User user) async {
  final querySnapshot = await FirebaseFirestore.instance
      .collection('products')
      .where('vendorId', isEqualTo: user.uid)
      .get();

  return querySnapshot.docs
      .map((doc) => {'id': doc.id, ...doc.data()})
      .toList();
}

Future<List<Map<String, dynamic>>> getOrdersByCustomer(User user) async {
  final querySnapshot = await FirebaseFirestore.instance
      .collection('orders')
      .where('customerId', isEqualTo: user.uid)
      .get();

  return querySnapshot.docs
      .map((doc) => {'id': doc.id, ...doc.data()})
      .toList();
}

Future<List<Map<String, dynamic>>> getOrdersByVendor(User user) async {
  final querySnapshot = await FirebaseFirestore.instance
      .collection('orders')
      .where('vendorId', isEqualTo: user.uid)
      .get();

  return querySnapshot.docs
      .map((doc) => {'id': doc.id, ...doc.data()})
      .toList();
}
