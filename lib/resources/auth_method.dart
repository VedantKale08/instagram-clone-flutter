import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseStore = FirebaseFirestore.instance;

  //sign up
  Future<String> signUpUser({
    required String username,
    required String email,
    required String password,
    required String bio,
    // required Uint8List file,
  }) async {
    String result = "Some error occurred";
    try {
      if (email.isNotEmpty ||
          username.isNotEmpty ||
          password.isNotEmpty ||
          bio.isNotEmpty) {
        //register
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        //store to firestore database

        _firebaseStore.collection("users").doc(cred.user!.uid).set({
          'uid': cred.user!.uid,
          'username': username,
          'email': email,
          'bio': bio,
          'followers':[],
          'followings': [],
        });
        result = "Success";
      }
    } catch (e) {
      result = e.toString();
    }
    return result;
  }
}
