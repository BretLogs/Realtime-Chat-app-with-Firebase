import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService() {
    _firebaseAuth.authStateChanges().listen(authStateChangesStreamListener);
  }
  User? _user;
  User? get user {
    return _user;
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<bool> login(String email, String password) async {
    try {
      final UserCredential credential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        _user = credential.user;
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print(e);
    }
    return false;
  }

  void authStateChangesStreamListener(User? user) {
    if (user != null) {
      _user = user;
    } else {
      _user = null;
    }
  }
}
