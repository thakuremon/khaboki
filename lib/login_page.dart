import 'all_files.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  bool studentLoginPage = true;
  final TextEditingController userId = TextEditingController();
  final TextEditingController userPassword = TextEditingController();
  final TextEditingController vendorPassword = TextEditingController();
  final TextEditingController vendorPhone = TextEditingController();

  ErrorMessage error = ErrorMessage();

  @override
  void dispose() {
    userId.dispose();
    userPassword.dispose();
    vendorPassword.dispose();
    vendorPhone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Login'),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          studentLoginPage = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 70),
                        backgroundColor: () {
                          if (studentLoginPage) return Colors.tealAccent;
                        }(),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Text('User'),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          studentLoginPage = false;
                        });
                      },

                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 70),
                        backgroundColor: () {
                          if (!studentLoginPage) {
                            return const Color.fromARGB(255, 136, 233, 223);
                          }
                        }(),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Text('Vendor'),
                    ),
                  ),
                  //SizedBox(height: 20),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: () {
                return (studentLoginPage)
                    /// this card is for user login
                    ? Card(
                        elevation: 5,
                        child: Padding(
                          padding: EdgeInsets.all(16),

                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: TextField(
                                  controller: userId,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.badge),
                                    labelText: 'student/faculty/staff id',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: TextField(
                                  controller: userPassword,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    labelText: 'password',
                                    prefixIcon: Icon(Icons.lock),

                                    border: OutlineInputBorder(),
                                  ),
                                  obscureText: true,
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    User? user = await signIn(
                                      userId.text,
                                      userPassword.text,
                                      error,
                                    );

                                    if (user != null) {
                                      HelperFunction.navigate(
                                        context,
                                        HomePage(),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(content: Text(error.message!)),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(200, 50),
                                    backgroundColor: Colors.teal,
                                  ),

                                  child: Text(
                                    'login',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),

                              Text('or'),

                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ElevatedButton(
                                  onPressed: () => HelperFunction.navigate(
                                    context,
                                    UserRegistrationPage(),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(200, 50),
                                    backgroundColor: Colors.teal,
                                  ),

                                  child: Text(
                                    'Create new account',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    :
                      /// this card is for vendor login
                      Card(
                        elevation: 5,
                        child: Padding(
                          padding: EdgeInsets.all(16),

                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: TextField(
                                  controller: vendorPhone,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.phone),
                                    labelText: 'phone',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: TextField(
                                  controller: vendorPassword,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    labelText: 'password',
                                    prefixIcon: Icon(Icons.lock),

                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    User? user = await signIn(
                                      vendorPhone.text,
                                      vendorPassword.text,
                                      error,
                                    );

                                    if (user != null) {
                                      HelperFunction.navigate(
                                        context,
                                        HomePage(),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(content: Text(error.message!)),
                                      );
                                    }
                                  },

                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(200, 50),
                                    backgroundColor: Colors.teal,
                                  ),

                                  child: Text(
                                    'login',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),

                              Text('or'),

                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ElevatedButton(
                                  onPressed: () => HelperFunction.navigate(
                                    context,
                                    VendorRegistrationPage(),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(200, 50),
                                    backgroundColor: Colors.teal,
                                  ),

                                  child: Text(
                                    'Create new account',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
              }(),
            ),
          ],
        ),
      ),
    );
  }
}
