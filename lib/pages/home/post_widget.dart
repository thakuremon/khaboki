import '../../all_files.dart';

class PostWidget extends StatelessWidget {
  final Map<String, dynamic> product;

  const PostWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    String productName = product['productName'] ?? 'Unknown Product';
    String costPerUnit = product['costPerUnit']?.toString() ?? '0';
    DateTime expireTime =
        (product['expireTime'] as Timestamp?)?.toDate() ?? DateTime.now();
    String photoUrl = product['photoUrl'] ?? 'assets/image/sample.jpg';

    return InkWell(
      onTap: () =>
          HelperFunction.navigate(context, OrderDetails(product: product)),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(8),
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage:
                    (photoUrl.isNotEmpty &&
                        Uri.tryParse(photoUrl)?.hasAbsolutePath == true)
                    ? NetworkImage(photoUrl)
                    : const AssetImage('assets/image/sample.jpg'),
              ),
              SizedBox(height: 20),
              Text(
                productName,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.timer),
                  Expanded(
                    child: Text(
                      '${expireTime.difference(DateTime.now()).inHours} hrs',
                    ),
                  ),
                  Expanded(child: Text('$costPerUnit৳')),
                ],
              ),
              //Image.network(imageUrl, height: 100, width: 150),
            ],
          ),
        ),
      ),
    );
  }
}
