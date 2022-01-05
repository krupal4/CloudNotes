import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  FirebaseAuth firebaseauth = FirebaseAuth.instance;

  Future<User?> signinAuth(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await firebaseauth
          .createUserWithEmailAndPassword(email: email, password: password);

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message.toString()),
        backgroundColor: Colors.amberAccent,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.blueGrey,
      ));
    }
    return null;
  }

  Future<User?> loginAuth(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await firebaseauth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message.toString()),
        backgroundColor: Colors.red,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
    }
    return null;
  }

  //sign in with google
  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      //Trigger authentication dialoug
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        //obtain the auth details from request
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        //create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        //once sign in return user data from firebase
        UserCredential userCredential =
            await firebaseauth.signInWithCredential(credential);
        return userCredential.user;
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message.toString(),
              style: const TextStyle(backgroundColor: Colors.red))));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString(),
              style: const TextStyle(backgroundColor: Colors.red))));
    }
    return null;
  }

  Future signOut () async
  {
    await firebaseauth.signOut();
    await GoogleSignIn().signOut();
  }
}
