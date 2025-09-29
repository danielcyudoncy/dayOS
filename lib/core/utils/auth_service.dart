// core/utils/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<AuthService> init() async {
    // Firebase is already initialized in main.dart
    return this;
  }

  Future<bool> signInWithGoogle() async {
    try {
      // For now, return false as Google Sign-In API has changed
      // TODO: Implement proper Google Sign-In with updated API
      print('Google Sign-In not implemented yet - API has changed');
      return false;
    } catch (e) {
      print('Google Sign In Error: $e');
      return false;
    }
  }

  Future<bool> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      print('Email Sign In Error: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      print('Unexpected Sign In Error: $e');
      return false;
    }
  }

  Future<bool> signUpWithEmail(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      print('Email Sign Up Error: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      print('Unexpected Sign Up Error: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Sign Out Error: $e');
    }
  }

  String getCurrentUserEmail() {
    return _auth.currentUser?.email ?? 'user@example.com';
  }

  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
