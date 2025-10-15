import 'all_files.dart';

class UserRegistrationPage extends StatefulWidget {
  const UserRegistrationPage({super.key});

  @override
  State<UserRegistrationPage> createState() => _UserRegistrationPage();
}

class _UserRegistrationPage extends State<UserRegistrationPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController studentIdController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  ErrorMessage error = ErrorMessage();

  ErrorMessage nameError = ErrorMessage();
  ErrorMessage studentIdError = ErrorMessage();
  ErrorMessage phoneError = ErrorMessage();
  ErrorMessage emailError = ErrorMessage();
  ErrorMessage passwordError = ErrorMessage();
  ErrorMessage confirmPasswordError = ErrorMessage();

  bool get isFormValid {
    return nameError.message == null &&
        studentIdError.message == null &&
        phoneError.message == null &&
        emailError.message == null &&
        passwordError.message == null &&
        confirmPasswordError.message == null;
  }

  @override
  void initState() {
    super.initState();

    nameController.addListener(() {
      final text = nameController.text;
      setState(() {
        if (text.isEmpty) {
          nameError.message = "Enter your name";
        } else {
          nameError.message = null;
        }
      });
    });

    studentIdController.addListener(() {
      final text = studentIdController.text;
      setState(() {
        if (text.isEmpty) {
          studentIdError.message = "id contains only digits";
        } else if (!KhabokiRegex.validUserId(text)) {
          studentIdError.message = 'invalid id format';
        } else {
          studentIdError.message = null;
        }
      });
    });

    phoneController.addListener(() {
      final text = phoneController.text;
      setState(() {
        if (text.isEmpty) {
          phoneError.message = "11 digit phone number";
        } else if (!KhabokiRegex.phone.hasMatch(text)) {
          phoneError.message = 'Phone number must be 11 digits';
        } else {
          phoneError.message = null;
        }
      });
    });

    emailController.addListener(() {
      final text = emailController.text;
      setState(() {
        if (!KhabokiRegex.email.hasMatch(text)) {
          emailError.message = 'Invalid email format';
        } else {
          emailError.message = null;
        }
      });
    });

    passwordController.addListener(() {
      final text = passwordController.text;
      setState(() {
        if (text.isEmpty) {
          passwordError.message = "Enter your password";
        } else if (!KhabokiRegex.validPassword(text)) {
          passwordError.message =
              'Password must be at least 8 characters, with letters and numbers';
        } else {
          passwordError.message = null;
        }
      });
    });

    confirmPasswordController.addListener(() {
      final text = confirmPasswordController.text;
      setState(() {
        if (text.isEmpty) {
          confirmPasswordError.message = "must match with password";
        } else if (text != passwordController.text) {
          confirmPasswordError.message = 'Passwords do not match';
        } else {
          confirmPasswordError.message = null;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Registration'),
        backgroundColor: Colors.teal,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                  errorText: nameError.message,
                ),
              ),

              SizedBox(height: 20),

              TextFormField(
                controller: studentIdController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.badge),
                  labelText: 'student ID',
                  border: OutlineInputBorder(),
                  errorText: studentIdError.message,
                ),
              ),

              SizedBox(height: 20),

              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone),
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                  errorText: phoneError.message,
                ),
                keyboardType: TextInputType.phone,
              ),

              SizedBox(height: 20),

              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  errorText: emailError.message,
                ),
              ),

              SizedBox(height: 20),

              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  errorText: passwordError.message,
                ),
                obscureText: false,
              ),

              SizedBox(height: 20),

              TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.password),
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                  errorText: confirmPasswordError.message,
                ),
                obscureText: false,
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  if (passwordController.text !=
                          confirmPasswordController.text ||
                      !isFormValid) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Registration failed. Please check your inputs.',
                        ),
                      ),
                    );
                    return;
                  }

                  User? user = await signUp(
                    emailController.text,
                    passwordController.text,
                    error,
                  );

                  if (user != null) {
                    // Registration successful
                    createUserProfile(
                      user,
                      nameController.text,
                      studentIdController.text,
                      emailController.text,
                      phoneController.text,
                      'user',
                      user.photoURL ?? '',
                    );
                    HelperFunction.navigate(context, VerifyEmailScreen());
                  } else {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(error.message!)));
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200, 50),
                  backgroundColor: Colors.teal,
                ),

                child: Text('Register', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account? '),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () => HelperFunction.navigate(context, LoginPage()),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
