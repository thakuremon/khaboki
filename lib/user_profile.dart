import 'package:flutter/material.dart';
import 'helper_function.dart';
import 'login_page.dart';
import 'home.dart';
import 'firebase_options.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
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
              onTap: () => HelperFunction.navigate(context, HomePage()),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
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

      body: Padding(
        padding: EdgeInsets.all(6.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 20),
                CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage('assets/image/sample.jpg'),
                ),
                SizedBox(height: 20),
                Text(
                  'Name: Emon Thakur',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Student ID: 0182220012101224',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text('Phone: 011111111111', style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text(
                  'Email: thakuremon@gmail.com',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
