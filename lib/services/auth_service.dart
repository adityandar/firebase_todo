import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future<User?> register(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      String msg = "";
      if (e.code == 'weak-password') {
        msg = "The password provided is too weak.";
      } else if (e.code == 'email-already-in-use') {
        msg = 'The account already exists for that email.';
      } else {
        msg = "Error.";
      }
      throw Exception(msg);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      String msg = "";
      if (e.code == 'user-not-found') {
        msg = "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        msg = 'Wrong password provider for that user.';
      } else {
        msg = "Error.";
      }
      throw Exception(msg);
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
