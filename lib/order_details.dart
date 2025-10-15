import 'all_files.dart';

class OrderDetails extends StatefulWidget {
  final Map<String, dynamic> product;
  const OrderDetails({super.key, required this.product});

  @override
  State<OrderDetails> createState() => _OrderDetails();
}

class _OrderDetails extends State<OrderDetails> {
  Map<String, dynamic> get product => widget.product;
  String get productName => product['productName'] ?? 'Unknown Product';
  String get costPerUnit => product['costPerUnit']?.toString() ?? '0';
  DateTime get expireTime =>
      (product['expireTime'] as Timestamp?)?.toDate() ?? DateTime.now();
  String get photoUrl => product['photoUrl'] ?? 'assets/image/sample.jpg';
  String get productDetails =>
      product['productDetails'] ?? 'No details available';
  int get availableQuantity => product['quantityAvailable'] ?? 0;

  int orderQuantity = 1;
  double totalPrice = 0;

  @override
  void initState() {
    super.initState();
    totalPrice = orderQuantity * double.parse(costPerUnit);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<CurrentUser>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: currentUser.role == 'user'
              ? Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Image.network(photoUrl),
                    ),

                    SizedBox(height: 20),

                    Text(
                      productName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(productDetails),

                    SizedBox(height: 10),

                    Row(
                      children: [
                        Text('quantity:'),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (orderQuantity > 1) orderQuantity--;
                              totalPrice =
                                  orderQuantity * double.parse(costPerUnit);
                            });
                          },
                          icon: CircleAvatar(
                            backgroundColor: Colors.red,
                            child: Icon(Icons.remove, color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text('$orderQuantity'),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              orderQuantity++;
                              if (orderQuantity > availableQuantity) {
                                orderQuantity = availableQuantity;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'no more product available ($availableQuantity)',
                                    ),
                                  ),
                                );
                              }
                              totalPrice =
                                  orderQuantity * double.parse(costPerUnit);
                            });
                          },
                          icon: CircleAvatar(
                            backgroundColor: Colors.red,
                            child: Icon(Icons.add, color: Colors.white),
                          ),
                        ),
                      ],
                    ),

                    Text(
                      'Total Price: \$$totalPrice',
                      style: TextStyle(fontSize: 20),
                    ),

                    SizedBox(height: 50),

                    ElevatedButton(
                      onPressed: () {
                        placeOrder(
                          vendoruId: product['vendoruId'],
                          customeruId: currentUser.uid!,
                          productName: productName,
                          productPicture: photoUrl,
                          productDetails: productDetails,
                          productCount: orderQuantity,
                          totalCost: totalPrice,
                          expireTime: expireTime,
                          orderStatus: 'pending',
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Order Placed succesfully',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 70, 191, 33),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );

                        HelperFunction.navigate(context, HomePage());
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),

                      child: Text(
                        'Place Order',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ],
                )
              : SizedBox.shrink(),
        ),
      ),
    );
  }
}
