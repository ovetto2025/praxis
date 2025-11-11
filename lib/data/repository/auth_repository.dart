import 'package:firebase_auth/firebase_auth.dart';
import 'package:praxis/data/models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Stream<User?> get user => _firebaseAuth.authStateChanges();
  Future<UserModel?> signUp(String email, String password) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );
      final User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        return UserModel(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          displayName: firebaseUser.displayName ?? '',
        );
      }
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<UserModel?> signIn(String name, String email, String password) async {
    try {
      final UserCredential cred = await _firebaseAuth
          .signInWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );
      final User? user = cred.user;
      if (user == null) return null;
      return UserModel(
        id: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? '',
      );
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      // Gestione/log dell\'errore
      return null;
    }
  }
  // Future<void> signUp(String name, String email, String password) async {
  //   await _firebaseAuth.createUserWithEmailAndPassword(
  //     email: email,
  //     password: password,
  //   );
  // }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      // Log o gestione dell'errore
      rethrow;
    }
  }

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }
}
