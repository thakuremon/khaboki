import 'all_files.dart';

Widget buildDrawer(BuildContext context, CurrentUser currentUser) {
  return Drawer(
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
          onTap: () => HelperFunction.navigate(context, UserProfile()),
        ),

        currentUser.role == 'ventor'
            ? ListTile(
                leading: Icon(Icons.add),
                title: Text('Add Product'),
                onTap: () =>
                    HelperFunction.navigate(context, CreateProductPage()),
              )
            : SizedBox.shrink(),

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
  );
}
