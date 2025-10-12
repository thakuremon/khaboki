import 'all_files.dart';

class CurrentUser extends ChangeNotifier {
  User? _user; // FirebaseAuth user
  Map<String, dynamic>? _profile; // Firestore profile

  User? get user => _user;
  Map<String, dynamic>? get profile => _profile;

  String? get displayName => _profile?['name'];
  String? get id => _profile?['id'];
  String? get phone => _profile?['phone'];
  String? get uid => _user?.uid;
  String? get email => _profile?['mail'];
  String? get photoURL => _user?.photoURL;
  String? get role => _profile?['role'];

  CurrentUser() {
    // Listen to authentication state changes
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) async {
      _user = firebaseUser;

      if (_user != null) {
        // Fetch Firestore profile
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid)
            .get();
        _profile = doc.exists ? doc.data() : null;
      } else {
        _profile = null;
      }

      notifyListeners(); // notify widgets listening to this provider
    });
  }

  /// Optional: manually refresh Firestore profile
  Future<void> refreshProfile() async {
    if (_user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .get();
      _profile = doc.exists ? doc.data() : null;
      notifyListeners();
    }
  }
}
