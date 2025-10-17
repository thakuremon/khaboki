import '../all_files.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool isVerified = false;

  @override
  void initState() {
    super.initState();
    checkVerification();
  }

  Future<void> checkVerification() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    setState(() {
      isVerified = user?.emailVerified ?? false;
    });

    if (isVerified) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Verification successful!")));
      HelperFunction.navigate(context, LoginPage());
    }
  }

  Future<void> resendEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.sendEmailVerification();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Verification email sent again!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify Your Email")),
      body: Center(
        child: isVerified
            ? const Text("Email verified! Redirecting...")
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("A verification email has been sent."),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: checkVerification,
                    child: const Text("Refresh"),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: resendEmail,
                    child: const Text("Resend Email"),
                  ),
                ],
              ),
      ),
    );
  }
}
