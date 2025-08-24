import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CurrentUser extends ChangeNotifier {
  User? _user; // FirebaseAuth user
  Map<String, dynamic>? _profile; // Firestore profile

  User? get user => _user;
  Map<String, dynamic>? get profile => _profile;

  String? get uid => _user?.uid;
  String? get email => _user?.email;
  String? get displayName => _user?.displayName;
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
