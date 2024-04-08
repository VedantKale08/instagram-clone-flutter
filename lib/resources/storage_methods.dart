import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class StorageMethods{
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //adding image to firebase storage
  Future<String> uploadImageToStorage(String childName, Uint8List file, bool isPost) async {

    Reference ref =  _firebaseStorage.ref().child(childName).child(_firebaseAuth.currentUser!.uid);
    
    if(isPost){
      String id = const Uuid().v1();
      ref = ref.child(id);
    }
    
    TaskSnapshot snap = await ref.putData(file);

    return await snap.ref.getDownloadURL();
  }
}