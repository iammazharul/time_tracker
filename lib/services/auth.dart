import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:flutter/cupertino.dart';

class User {
  final String uid;

  User({@required this.uid});
}

abstract class AuthBase {
  User getCurrentUser();
  Future<User> signInAnonymously();
  Future<void> signOut();
}

class Auth implements AuthBase {
  final _firebaseAuth = firebaseAuth.FirebaseAuth.instance;

  User _userFromFirebase(firebaseAuth.User user) {
    if (user == null) {
      return null;
    }
    return User(uid: user.uid);
  }

  @override
  User getCurrentUser() {
    final user = _firebaseAuth.currentUser;
    return _userFromFirebase(user);
  }

  @override
  Future<User> signInAnonymously() async {
    final userCredential = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(userCredential.user);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
