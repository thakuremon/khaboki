import 'all_files.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<CurrentUser>();

    return Scaffold(
      appBar: AppBar(
        title: Row(children: [Text('Home Page'), SizedBox(width: 180)]),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      drawer: buildDrawer(context, currentUser),
      body: Column(
        children: [
          Text('Find your food'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search...',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .where('expireTime', isGreaterThan: Timestamp.now())
                  //.where('quantityAvailable', isGreaterThan: 0)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No products found.'));
                }

                final products = snapshot.data!.docs.where((d) {
                  final data = d.data() as Map<String, dynamic>;
                  final q = data['quantityAvailable'] ?? 0;
                  return q is int ? q > 0 : (q is num ? q > 0 : false);
                }).toList();

                return GridView.builder(
                  padding: EdgeInsets.all(8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product =
                        products[index].data() as Map<String, dynamic>;

                    return GestureDetector(
                      onTap: () {
                        // Navigate to OrderDetailsPage and pass product data
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                OrderDetails(product: product),
                          ),
                        );
                      },
                      child: PostWidget(product: product),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
