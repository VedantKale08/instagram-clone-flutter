import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/comment.dart';
import 'package:instagram_clone/widgets/story.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final post;
  const CommentScreen({super.key, required this.post});

  @override
  State<CommentScreen> createState() => _CommentStateScreen();
}

class _CommentStateScreen extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    final Stream<QuerySnapshot> stream =  FirebaseFirestore.instance.collection("posts").doc(widget.post["postId"]).collection("comments").orderBy("commented_at", descending: true).snapshots();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.arrow_back)),
        title: const Text("Comments", style: TextStyle(fontSize: 20)),
      ),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  StreamBuilder(
                    stream:stream, 
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return const LinearProgressIndicator(color: blueColor);
                      }

                      if(!snapshot.hasData){
                        return Container();
                      }

                      return ListView.builder(
                        key: UniqueKey(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) => Comment(comment:snapshot.data!.docs[index].data()),
                      );
                    },
                  )
                ],
              ),
            )),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                    top: BorderSide(color: Color.fromARGB(255, 35, 35, 35))),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 1),
              child: Row(
                children: [
                  StoryImage(
                      radius: 20, noStory: true, padding: 0, image: user.image),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: "Add comment for ${widget.post["username"]}",
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        await FirebaseStoreMethods().commentPost(
                            widget.post["postId"],
                            user.uid,
                            _commentController.text,
                            user.username,
                            user.image);
                        _commentController.clear();
                      },
                      color: blueColor,
                      icon: Icon(Icons.send))
                ],
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar:
    );
  }
}
