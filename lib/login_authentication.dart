import 'user_registration_page.dart';
import 'package:flutter/material.dart';
import 'package:khaboki2/user_profile.dart';
import 'package:khaboki2/vendor_registration_page.dart';
import 'home.dart';
import 'login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'error_message.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<User?> signUp(String email, String password, ErrorMessage error) async {
  email = email + '@khaboki.com';
  try {
    UserCredential userCred = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return userCred.user;
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case 'email-already-in-use':
        error.message = 'Email is already in use.';
        break;
      case 'invalid-email':
        error.message = 'Invalid email address.';
        break;
      case 'operation-not-allowed':
        error.message = 'Email/password accounts not enabled.';
        break;
      case 'weak-password':
        error.message = 'Password is too weak.';
        break;
      case 'too-many-requests':
        error.message = 'Too many requests. Try again later.';
        break;
      case 'network-request-failed':
        error.message = 'Network error. Check your internet.';
        break;
      default:
        error.message = 'Signup failed: ${e.message}';
    }
    return null;
  } catch (e) {
    error.message = 'Unexpected error: $e';
    return null;
  }
}

Future<User?> signIn(String email, String password, ErrorMessage error) async {
  email = email + '@khaboki.com';
  try {
    UserCredential userCred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCred.user;
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case 'email-already-in-use':
        error.message = 'Email is already in use.';
        break;
      case 'invalid-email':
        error.message = 'Invalid email address.';
        break;
      case 'operation-not-allowed':
        error.message = 'Email/password accounts not enabled.';
        break;
      case 'weak-password':
        error.message = 'Password is too weak.';
        break;
      case 'too-many-requests':
        error.message = 'Too many requests. Try again later.';
        break;
      case 'network-request-failed':
        error.message = 'Network error. Check your internet.';
        break;
      default:
        error.message = 'Signup failed: ${e.message}';
    }
    return null;
  } catch (e) {
    error.message = 'Unexpected error: $e';
    return null;
  }
}

// Sign out
Future<void> signOut() async {
  await _auth.signOut();
}
