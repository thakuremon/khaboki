import '../all_files.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});
  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<CurrentUser>();
    final photoUrl = currentUser.photoURL;

    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),

      drawer: buildDrawer(context, currentUser),

      body: Padding(
        padding: EdgeInsets.all(6.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 20),
                CircleAvatar(
                  radius: 100,
                  backgroundImage: photoUrl != null
                      ? NetworkImage(photoUrl!)
                      : AssetImage("assets/image/sample.jpg") as ImageProvider,
                ),
                SizedBox(height: 20),
                Text(
                  currentUser.displayName ?? "NULL",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'ID: ${currentUser.id ?? "NULL"}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  'phone: ${currentUser.phone ?? "NULL"}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  'Email: ${currentUser.email ?? "NULL"}',
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
