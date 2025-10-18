import 'package:khaboki2/flash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'all_files.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://lfqtzbxrozgwrzkslvfd.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxmcXR6Ynhyb3pnd3J6a3NsdmZkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjAzNzcxODksImV4cCI6MjA3NTk1MzE4OX0.el8A4b34RRBHPJil6Wb4rn3gqgG9bLwnco1N4PJnho0', // from dashboard
  );

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChangeNotifierProvider(create: (_) => CurrentUser(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KhaboKi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: FlashScreen(),
    );
  }
}
