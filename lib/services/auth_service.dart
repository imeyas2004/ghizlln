import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Méthode d'inscription
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('User signed up: ${userCredential.user?.email}');
      return userCredential.user;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  // Méthode de connexion
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('User signed in: ${userCredential.user?.email}');
      return userCredential.user;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  // Déconnexion
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Utilisateur actuel
  User? get currentUser => _auth.currentUser;
}
