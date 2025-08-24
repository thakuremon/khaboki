import 'package:flutter/material.dart';
import 'firebase_options.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({super.key});

  @override
  State<OrderDetails> createState() => _OrderDetails();
}

class _OrderDetails extends State<OrderDetails> {
  int order_quantity = 1;
  int item_price = 10;
  int total_price = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Image.asset('assets/image/sample.jpg'),
              ),

              SizedBox(height: 20),

              Text(
                'item name ',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10),

              Text('product details here '),

              SizedBox(height: 10),

              Row(
                children: [
                  Text('quantity:'),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (order_quantity > 1) order_quantity--;
                        total_price = order_quantity * item_price;
                      });
                    },
                    icon: CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Icon(Icons.remove, color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('$order_quantity'),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        order_quantity++;
                        total_price = order_quantity * item_price;
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
                'Total Price: \$$total_price',
                style: TextStyle(fontSize: 20),
              ),

              SizedBox(height: 50),

              ElevatedButton(
                onPressed: () {
                  // Handle order confirmation
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
          ),
        ),
      ),
    );
  }
}
