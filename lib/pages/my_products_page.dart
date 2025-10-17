import '../all_files.dart'; // your CurrentUser and getProductsByVendor
import 'package:intl/intl.dart';

class MyProductsPage extends StatefulWidget {
  const MyProductsPage({super.key});

  @override
  State<MyProductsPage> createState() => _MyProductsPageState();
}

class _MyProductsPageState extends State<MyProductsPage> {
  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<CurrentUser>();

    // Call your async function
    Future<List<Map<String, dynamic>>> productsFuture = getProductsByVendor(
      currentUser.user!,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Products"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No products found."));
          }

          final products = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              return ProductCard(product: product);
            },
          );
        },
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final Map<String, dynamic> product;
  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late TextEditingController nameController;
  late TextEditingController detailsController;
  late TextEditingController quantityController;
  late TextEditingController priceController;
  late DateTime expireTime;

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    nameController = TextEditingController(text: product['productName'] ?? '');
    detailsController = TextEditingController(
      text: product['productDetails'] ?? '',
    );
    quantityController = TextEditingController(
      text: (product['quantityAvailable'] ?? 0).toString(),
    );
    priceController = TextEditingController(
      text: (product['costPerUnit'] ?? 0).toString(),
    );
    expireTime =
        (product['expireTime'] as Timestamp?)?.toDate() ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final productId = widget.product['itemId'].toString();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Product Name"),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: detailsController,
              decoration: const InputDecoration(labelText: "Product Details"),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: quantityController,
                    decoration: const InputDecoration(
                      labelText: "Available Quantity",
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: priceController,
                    decoration: const InputDecoration(
                      labelText: "Cost Per Unit",
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text("Expire Time: "),
                Text(
                  DateFormat("yyyy-MM-dd – HH:mm").format(expireTime),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: expireTime,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(expireTime),
                      );
                      if (pickedTime != null) {
                        setState(() {
                          expireTime = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                        });
                      }
                    }
                  },
                  child: const Text("Change"),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await updateProduct(productId, {
                        'productName': nameController.text.trim(),
                        'productDetails': detailsController.text.trim(),
                        'quantityAvailable':
                            int.tryParse(quantityController.text) ?? 0,
                        'costPerUnit':
                            double.tryParse(priceController.text) ?? 0.0,
                        'expireTime': Timestamp.fromDate(expireTime),
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Product updated successfully!"),
                          backgroundColor: Colors.teal,
                        ),
                      );
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      "Update Product",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),

                SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("delete product"),
                          content: Text("are you sure "),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text('cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: Text(
                                'delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        await FirebaseFirestore.instance
                            .collection('products')
                            .doc(productId)
                            .delete();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'product deleted successfully',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 70, 191, 33),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      }
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      "Delete product",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
