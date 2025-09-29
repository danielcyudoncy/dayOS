// core/utils/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

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

  Future<bool> userExists(String email) async {
    try {
      // Try to sign in with a dummy password to check if user exists
      // This is a simple and reliable approach
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: 'dummy_password_12345',
      );
      // If we get here without exception, the user exists
      await _auth.signOut(); // Sign out the dummy session
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return false; // User doesn't exist
      } else if (e.code == 'wrong-password') {
        return true; // User exists but password is wrong
      } else if (e.code == 'invalid-credential') {
        return true; // User exists but credential is invalid
      }
      print('Error checking if user exists: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      print('Unexpected error checking if user exists: $e');
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

  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print('Password reset email sent successfully to: $email');
      return true;
    } on FirebaseAuthException catch (e) {
      print('Password Reset Email Error: ${e.code} - ${e.message}');
      if (e.code == 'invalid-email') {
        print('The email address is not valid');
      } else if (e.code == 'user-not-found') {
        print('No user found with this email address');
      } else {
        print('Firebase Auth Error: ${e.code}');
      }
      return false;
    } catch (e) {
      print('Unexpected Password Reset Error: $e');
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
