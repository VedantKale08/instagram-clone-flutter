import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseStore = FirebaseFirestore.instance;

  //get user
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap = await _firebaseStore.collection("users").doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  //sign up
  Future<String> signUpUser({
    required String username,
    required String email,
    required String password,
    required String bio,
    required Uint8List file,
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

        //upload image to storage
        String imageUrl = await StorageMethods().uploadImageToStorage("profilePics", file, false);

        //store to firestore database
        model.User user = model.User(
            uid: cred.user!.uid,
            username: username.toLowerCase(),
            email: email,
            bio: bio,
            followers: [],
            followings: [],
            image: imageUrl
        );

        _firebaseStore.collection("users").doc(cred.user!.uid).set(user.toJson());
        
        result = "Registered successfully";
      }
    } on FirebaseAuthException catch(err){
      if(err.code == "invalid-email"){
        result = "Email is invalid";
      }
      else if(err.code == "weak-password"){
        result= "Password must contain at least six characters";
      } else if (err.code == "email-already-in-use") {
        result = "Email already exists";
      }
    } catch (e) {
      result = e.toString();
    }
    return result;
  }


  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String result = "Some error occurred";
    try {
      if(email.isNotEmpty || password.isNotEmpty){
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        result = "Login successful";
      }
    } on FirebaseAuthException catch(err){
      if(err.code == "invalid-email"){
        result = "Email is invalid";
      }
      else if(err.code == "weak-password"){
        result= "Password must contain at least six characters.";
      } else if (err.code == "invalid-credential"){
        result = "Invalid credential";
      }
    } catch (e) {
      result = e.toString();
    }
    return result;
  }

  Future<void> logOut() async {
    await _auth.signOut();
  }
}
