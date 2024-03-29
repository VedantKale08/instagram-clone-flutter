import 'package:cloud_firestore/cloud_firestore.dart';

class User {
    final String uid;
    final String username;
    final String email;
    final String bio;
    final List followers;
    final List followings;
    final String image;

    const User({
      required this.uid,
      required this.username,
      required this.email,
      required this.bio,
      required this.followings,
      required this.followers,
      required this.image
    });

    Map<String,dynamic> toJson() => {
      "uid":uid,
      "username":username,
      "email":email,
      "bio":bio,
      "followings":followings,
      "followers":followers,
      "image":image
    };

    static User fromSnap(DocumentSnapshot snapshot){
      var snap = snapshot.data() as Map<String,dynamic>;
    return User(
        uid: snap["uid"],
        username: snap["username"],
        email: snap["email"],
        bio: snap["bio"],
        followings: snap["followings"],
        followers: snap["followers"],
        image: snap["image"]);
    }
}