import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final _auth = FirebaseAuth.instance;

  Future<User?> createUserWithEmailandPassword(
      String email, String password) async{
    try{
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return cred.user;
    }catch(e){
      log("Something went wrong");
    }
    return null;
  }

  Future<User?> loginUserWithEmailandPassword(
      String email, String password) async{
    try{
      log("$email,$password");
      /*
      UserCredential cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return cred.user;
      */
      User? user = _auth.currentUser;
      return user;
    }catch(e) {
      log("Login failed: $e");
    }
    return null;
  }

  Future<bool> logout() async {
    try {
      await _auth.signOut();
      log("User logged out");
      return true;
    } catch (e) {
      log("Logout failed: $e");
      return false;
    }
  }
}