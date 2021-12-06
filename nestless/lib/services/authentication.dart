import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Global authentication handler
abstract class BaseAuth {
  // Sign in the user with email and password
  Future<User> signIn(String email, String password);

  // Register the user with email and password
  Future<User> signUp(String email, String password);

  // Get the current user from the FirebaseAuth instance
  Future<User?> getCurrentUser();

  Future<void> setupUser(User user, List<Map<String, dynamic>> birdsSeen,
      Map<String, dynamic> latestSeen);

  // Future<void> sendEmailVerification();

  // Sends sign in email
  // Future<void> sendSignInLink(String email);

  // Sign in with dynamic link
  // Future<User> signInWithLink(String email, String link);

  // Sign in with google
  Future<User> signInWithGoogle();

  // Sign out the user
  Future<void> signOut();

  
  // Future<bool> isEmailVerified();
}

class Auth implements BaseAuth {
  // Create a FirebaseAuth instance
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<User> signIn(String email, String password) async {
    // Sign in the user with email and password
    UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    User? user = result.user;
    // Return the user
    return user!;
  }

  @override
  Future<User> signUp(String email, String password) async {
    // Register the user with email and password
    UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    User? user = result.user;
    // Return the user
    return user!;
  }

  @override
  Future<User?> getCurrentUser() async {
    // Get the current user from the FirebaseAuth instance
    User? user = _firebaseAuth.currentUser;
    return user;
  }

  @override
  Future<void> setupUser(User user, List<Map<String, dynamic>> birdsSeen,
      Map<String, dynamic> latestSeen) async {
    String uid = await getCurrentUser().then((user) => user!.uid);

    // Create a new document for the user with the uid
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'uid': uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoUrl': user.photoURL,
      'birdsSeen': birdsSeen,
      'latestSeen': latestSeen,
      'lastSeen': DateTime.now(),
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
    });
  }

  @override
  Future<void> signOut() async {
    // Sign out the user
    return _firebaseAuth.signOut();
  }

  // @override
  // Future<void> sendSignInLink(String email) async {
  //   // Sends sign in email
  //   return await _firebaseAuth.sendSignInLinkToEmail(
  //       email: email,
  //       actionCodeSettings: ActionCodeSettings(
  //           url: 'https://nestless.page.link', // URL you want to redirect to
  //           handleCodeInApp: true,
  //           iOSBundleId: 'com.example.nestless', // iOS
  //           androidPackageName: 'com.example.nestless', // Android
  //           androidMinimumVersion: '1'));
  // }

  // @override
  // Future<User> signInWithLink(String email, String link) async {
  //   // Sign in with dynamic link
  //   UserCredential result =
  //       await _firebaseAuth.signInWithEmailLink(email: email, emailLink: link);
  //   User? user = result.user;
  //   // Return the user
  //   return user!;
  // }

  @override
  Future<User> signInWithGoogle() async {
    // Sign in with google
    GoogleSignIn googleSignIn = GoogleSignIn();
    // Get the google account
    GoogleSignInAccount? account = await googleSignIn.signIn();
    // Get the credentials and error check
    if (account != null) {
      GoogleSignInAuthentication googleAuth = await account.authentication;
      if (googleAuth.idToken != null && googleAuth.accessToken != null) {
        // Sign in the user with credentials
        UserCredential result = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.credential(
                idToken: googleAuth.idToken,
                accessToken: googleAuth.accessToken));
        User? user = result.user;
        // Return the user
        return user!;
      } else {
        // Throw an error if the credentials are null (should never happen)
        throw PlatformException(
            code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
            message: 'Missing Google Auth Token');
      }
    } else {
      // Throw an error if the account is null (only happens if the user cancels the sign in)
      throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
    }
  }

  /*@override
  Future<void> sendEmailVerification() async {
    User? user = _firebaseAuth.currentUser;
    user!.sendEmailVerification();
  }

  @override
  Future<bool> isEmailVerified() async {
    User? user = _firebaseAuth.currentUser;
    return user!.emailVerified;
  }*/
}
