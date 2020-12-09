import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class User {
  final String uid;

  User({@required this.uid});
}

abstract class AuthBase {
  User getCurrentUser();
  Future<User> signInAnonymously();
  Future<User> signInWithGoogle();
  Future<User> signInWithFacebook();
  Future<void> signOut();
  Stream<User> get onAuthStateChange;
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
  Stream<User> get onAuthStateChange {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
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
  Future<User> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleAccount.authentication;
      if (googleAuth.idToken != null && googleAuth.accessToken != null) {
        final firebaseAuth.GoogleAuthCredential credential =
            firebaseAuth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        return _userFromFirebase(userCredential.user);
      } else {
        throw PlatformException(
            code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
            message: 'Missing google auth token');
      }
    } else {
      throw PlatformException(
          code: 'ERROR_ABORTER_BY_USER', message: 'Sign in aborted by user');
    }
  }

  @override
  Future<User> signInWithFacebook() async {
    final FacebookLogin facebookLogin = FacebookLogin();
    facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
    final FacebookLoginResult result = await facebookLogin.logIn(['email']);

    if (result.status == FacebookLoginStatus.loggedIn) {
      final FacebookAccessToken accessToken = result.accessToken;
      if (accessToken.token != null) {
        final firebaseAuth.AuthCredential credential =
            firebaseAuth.FacebookAuthProvider.credential(accessToken.token);

        final userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        return _userFromFirebase(userCredential.user);
      } else {
        throw PlatformException(
            code: 'ERROR_MISSING_FACEBOOK_AUTH_TOKEN',
            message: 'Missing facebook auth token');
      }
    } else {
      throw PlatformException(
          code: 'ERROR_ABORTER_BY_USER', message: 'Sign in aborted by user');
    }
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    final facebookSignIn = GoogleSignIn();
    await _firebaseAuth.signOut();
    googleSignIn.signOut();
    facebookSignIn.signOut();
  }
}
