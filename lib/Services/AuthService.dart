import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {

  static final _auth = FirebaseAuth.instance;

  static Future<User?> login(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;

    } on FirebaseAuthException catch (e) {
      throw e.code;
    }
  }

  static Future<User?> register(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;

    } on FirebaseAuthException catch (e) {
      throw e.code;
    }
  }

  static Future<User?> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await _auth.signInWithCredential(credential);

      return result.user;

    } catch (e) {
      throw "google-signin-failed";
    }
  }

  static Future<void> logout() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }
}