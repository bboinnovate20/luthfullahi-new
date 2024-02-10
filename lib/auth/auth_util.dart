import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

import 'package:babaloworo/firebase_options.dart';
import 'package:babaloworo/main.dart';
import 'package:babaloworo/shared/notification_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';


 class UserInfoI {
    final String displayName;
    final String email;
    UserInfoI(this.displayName, this.email);
  }

class AuthProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<User?> get authStateChange => _auth.authStateChanges();
  bool notificationPermission = false;
  bool permission = false;
  
 

  UserInfoI? getCurrentUser() {
    User? getUser = _auth.currentUser;
    UserInfoI user = UserInfoI(getUser?.displayName ?? getUser?.providerData[0].displayName ?? "User", getUser?.email ?? "");
    return user;
  }

  showUser(User? user) {
    return {
      'email': user?.email ?? "", 
      'displayName': user?.displayName ?? user?.providerData[0].displayName ?? "User"
    };
  }


  // getToken()async{
  //   return await FirebaseMessaging.instance.getToken();
  // }
  changePermission(bool value) {

    print("permission changed");
    notificationPermission = value;
    
  }   

  checkisAdmin() async {
    try {
      final getUser = getCurrentUser();
      if (getUser != null) {
        final db = Database();
        return await db.getAdmin(getUser.email ?? "");
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  googleSignIn() async {
    try {

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final getData = await _auth.signInWithCredential(credential);
      return getData;
      // final userData = {
      //   'name': getData.user?.displayName ?? "",
      //   'email': getData.user?.email ?? ""
      // };

      // final db = Database();
      // db.addUser(user)

      //add to database;
    } catch (e) {
      print(e);
      rethrow;
      // authenticationLoading = false;
      // return 
      // return;
    } finally {}
  }

  String generateNonce([int length = 32]) {
  const charset =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)])
      .join();
  }

    /// Returns the sha256 hash of [input] in hex notation.
    String sha256ofString(String input) {
      final bytes = utf8.encode(input);
      final digest = sha256.convert(bytes);
      return digest.toString();
    }


    appleSignIn() async {
        final rawNonce = generateNonce();
        final nonce = sha256ofString(rawNonce);
    try {

        final credential = await SignInWithApple.getAppleIDCredential(
        nonce: nonce,
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: "com.octramarket.luthfullahi",
          redirectUri: Uri.parse("https://luthfullahi-new.firebaseapp.com/__/auth/handler")
        ),
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: credential.identityToken,
      rawNonce: rawNonce);

       return await FirebaseAuth.instance.signInWithCredential(oauthCredential);


    } catch (e) {
      rethrow;
      // authenticationLoading = false;
      // return 
      // return;
    } finally {}
  }

  googleSignOut() async {
    await _auth.signOut();
  }
}
