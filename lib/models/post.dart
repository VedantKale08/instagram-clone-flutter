import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String uid;
  final String username;
  final String profileImage;
  final String postId;
  final String description;
  final String postUrl;
  final List likes;
  final uploaded_at; 

  const Post(
      {required this.uid,
      required this.username,
      required this.profileImage,
      required this.postId,
      required this.description,
      required this.postUrl,
      required this.likes,
      required this.uploaded_at
      });

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "username": username,
        "profileImage": profileImage,
        "postId": postId,
        "description": description,
        "postUrl": postUrl,
        "likes": likes,
        "uploaded_at": uploaded_at,
      };

  static Post fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return Post(
        uid: snap["uid"],
        username: snap["username"],
        profileImage: snap["profileImage"],
        postId: snap["postId"],
        description: snap["description"],
        postUrl: snap["postUrl"],
        likes: snap["likes"],
        uploaded_at: snap["uploaded_at"]
        );
  }
}
