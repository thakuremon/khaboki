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
  TextEditingController dateTimeController = TextEditingController();
  DateTime? selectedDateTime;
  String? photoUrl;

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<CurrentUser>();

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

              DateTimeInputField(
                controller: dateTimeController,
                onDateTimeSelected: (dt) {
                  selectedDateTime = dt;
                },
              ),
              // Image upload section
              SizedBox(height: 10),

              ElevatedButton(
                onPressed: () async {
                  photoUrl = await pickAndUploadImage(context);
                },
                child: const Text('Upload Image'),
              ),

              SizedBox(height: 20),

              //if (imageFile != null) Image.file(imageFile!, height: 150),
              ElevatedButton(
                onPressed: () async {
                  String name = nameController.text;
                  String details = detailsController.text;
                  double? price = double.tryParse(priceController.text);
                  int? quantity = int.tryParse(quantityController.text);

                  if (name.isNotEmpty &&
                      details.isNotEmpty &&
                      price != null &&
                      quantity != null &&
                      photoUrl != null &&
                      selectedDateTime != null) {
                    try {
                      await createProduct(
                        vendoruId: currentUser.uid!,
                        productName: name,
                        produceDetails: details,
                        costPerUnit: price,
                        quantityAvailable: quantity,
                        expireTime: selectedDateTime!,
                        photoUrl: photoUrl!,
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '$e',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 70, 191, 33),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Product Created Successfully')),
                    );

                    // Clear fields after creation
                    nameController.clear();
                    detailsController.clear();
                    priceController.clear();
                    quantityController.clear();

                    HelperFunction.navigate(context, HomePage());
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please fill all fields correctly'),
                      ),
                    );
                  }
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
