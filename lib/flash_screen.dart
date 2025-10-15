import 'all_files.dart';

class FlashScreen extends StatefulWidget {
  const FlashScreen({Key? key}) : super(key: key);

  @override
  State<FlashScreen> createState() => _FlashScreenState();
}

class _FlashScreenState extends State<FlashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf5f5f5),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.jpeg', width: 200, height: 200),
            const SizedBox(height: 25),

            // const Text(
            //   'KhaboKi',
            //   style: TextStyle(
            //     fontSize: 36,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.black87,
            //     letterSpacing: 1.2,
            //   ),
            // ),

            // const SizedBox(height: 8),

            // const Text(
            //   'Smart Food, Fast',
            //   style: TextStyle(fontSize: 16, color: Colors.grey),
            // ),
            const SizedBox(height: 40),

            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
