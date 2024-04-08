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
}