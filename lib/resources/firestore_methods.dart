import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirebaseStoreMethods{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload Post
  Future<String> uploadPost(
    String description,
    Uint8List? file,
    String uid,
    String username,
    String profileImage
  ) async{
    String res = "Some error occurred";
    try {
      String photoUrl = await StorageMethods().uploadImageToStorage("posts", file!, true);

      String postId = const Uuid().v1();
      Post post = Post(
        uid: uid,
        username: username,
        profileImage: profileImage,
        postId: postId,
        description: description,
        postUrl: photoUrl,
        likes: [],
        uploaded_at: DateTime.now(),
      );

      _firestore.collection("posts").doc(postId).set(post.toJson());

      res = "success";

    } catch (e) {
      res = e.toString();
    }
    return res;
  }


  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if(likes.contains(uid)){
         await _firestore.collection("posts").doc(postId).update({
          'likes':FieldValue.arrayRemove([uid]),
         });
      }else{
        await _firestore.collection("posts").doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> commentPost(String postId, String uid, String comment, String name, String profilePic) async {
    try {
      if(comment.isNotEmpty){
        String commentId = const Uuid().v1();
        await _firestore.collection("posts").doc(postId).collection("comments").doc(commentId).set({
          'commentId':commentId,
          'uid':uid,
          'name':name,
          'profilePic':profilePic,
          'comment':comment,
          'commented_at':DateTime.now()
        });
        print("Success");
      }else{
        print("Text is empty");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap = await _firestore.collection("users").doc(uid).get();
      List followings = (snap.data() as dynamic)["followings"];

      if(followings.contains(followId)){
        await _firestore.collection("users").doc(followId).update({
          'followers':FieldValue.arrayRemove([uid])
        });

        await _firestore.collection("users").doc(uid).update({
          'followings': FieldValue.arrayRemove([followId])
        });
      }else{
        await _firestore.collection("users").doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection("users").doc(uid).update({
          'followings': FieldValue.arrayUnion([followId])
        });
      }

    } catch (e) {
      print(e.toString());
    }
  }
}