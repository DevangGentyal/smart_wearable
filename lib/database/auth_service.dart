import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign Up Method (Now Returns User Object)
  Future<User?> register(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user; // Return Firebase User Object
    } on FirebaseAuthException catch (e) {
      throw _getFirebaseAuthErrorMessage(e); // Throw Exception
    }
  }

  // Login Method
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return _getFirebaseAuthErrorMessage(e);
    }
  }

  // Logout Method
  Future<void> logout() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
    await prefs.setBool('remember_me', false);
  }

  // Firebase Auth Error Handling
  String _getFirebaseAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return "This email is already registered. Try logging in instead.";
      case 'weak-password':
        return "Your password is too weak. Please use a stronger password.";
      case 'invalid-email':
        return "The email address is not valid.";
      case 'user-not-found':
        return "No account found with this email.";
      case 'wrong-password':
        return "Incorrect password. Please try again.";
      case 'invalid-credential':
        return "Invalid Credentials";
      case 'user-disabled':
        return "This account has been disabled. Contact support.";
      case 'too-many-requests':
        return "Too many login attempts. Please try again later.";
      default:
        return "Authentication failed: ${e.message}";
    }
  }
}
