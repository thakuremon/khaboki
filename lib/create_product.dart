import 'all_files.dart';

class CreateProductPage extends StatefulWidget {
  const CreateProductPage({super.key});

  @override
  State<CreateProductPage> createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Product'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: detailsController,
                decoration: InputDecoration(labelText: 'Product Details'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              TextField(
                controller: quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              TextField(
                controller: imageUrlController,
                decoration: InputDecoration(labelText: 'Image URL'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  String name = nameController.text;
                  String details = detailsController.text;
                  double? price = double.tryParse(priceController.text);
                  int? quantity = int.tryParse(quantityController.text);
                  String imageUrl = imageUrlController.text;

                  // if (name.isNotEmpty &&
                  //     details.isNotEmpty &&
                  //     price != null &&
                  //     quantity != null &&
                  //     imageUrl.isNotEmpty) {
                  //   await createProduct(
                  //     name,
                  //     details,
                  //     price,
                  //     quantity,
                  //     imageUrl,
                  //   );
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(content: Text('Product Created Successfully')),
                  //   );
                  //   // Clear fields after creation
                  //   nameController.clear();
                  //   detailsController.clear();
                  //   priceController.clear();
                  //   quantityController.clear();
                  //   imageUrlController.clear();
                  // } else {
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(content: Text('Please fill all fields correctly')),
                  //   );
                  // }
                },
                child: Text('Create Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
