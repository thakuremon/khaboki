import 'package:flutter/material.dart';
import 'package:khaboki2/helper_function.dart';
import 'package:khaboki2/login_page.dart';
import 'helper_function.dart';
import 'user_profile.dart';
import 'order_details.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'current_user.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<CurrentUser>();

    // navigate back if the user is not allowed to see this page
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Navigator.of(context).pop();
    // });
    // return SizedBox.shrink();

    return Scaffold(
      appBar: AppBar(
        title: Row(children: [Text('Home Page'), SizedBox(width: 180)]),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text(
                'Menu',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              decoration: BoxDecoration(color: Colors.teal),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () => HelperFunction.navigate(context, UserProfile()),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('about us'),
              onTap: () {
                // Navigate to settings page
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () => HelperFunction.navigate(context, LoginPage()),
              // Navigate to settings pag,
            ),
          ],
        ),
      ),

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
            child: GridView(
              padding: EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.75,
              ),
              children: [
                PostWidget(
                  userName: 'Menu1',
                  postText: 'This is a sample post text.',
                  imageUrl: 'assets/image/sample.jpg',
                ),
                PostWidget(
                  userName: 'Menu2',
                  postText: 'Another sample post text.',
                  imageUrl: 'assets/image/sample.jpg',
                ),
                PostWidget(
                  userName: 'Menu3',
                  postText: 'Yet another sample post text.',
                  imageUrl: 'assets/image/sample.jpg',
                ),
                PostWidget(
                  userName: 'Menu3',
                  postText: 'Yet another sample post text.',
                  imageUrl: 'assets/image/sample.jpg',
                ),
                PostWidget(
                  userName: 'Menu5',
                  postText: 'Yet another sample post text.',
                  imageUrl: 'assets/image/sample.jpg',
                ),

                /// can add any number of posts
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PostWidget extends StatelessWidget {
  final String userName;
  final String postText;
  final String imageUrl;

  const PostWidget({
    super.key,
    required this.userName,
    required this.postText,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => HelperFunction.navigate(context, OrderDetails()),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(8),
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(backgroundImage: AssetImage(imageUrl), radius: 60),
              SizedBox(height: 20),
              Text(
                userName,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.timer),
                  Expanded(child: Text('80min 2s')),
                  Expanded(child: Text('200৳')),
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
