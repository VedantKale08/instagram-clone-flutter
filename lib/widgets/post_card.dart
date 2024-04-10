import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/comment_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/like_animation.dart';
import 'package:instagram_clone/widgets/story.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final post;
  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  
  late final _post;
  bool isLikeAnimating = false;
  int commentLength = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _post = widget.post;
    getComments();
  }

  void handleLikePost(User user) async {
      await FirebaseStoreMethods().likePost(_post['postId'], user.uid, _post['likes']);
  }

  void getComments() async {
    QuerySnapshot commentsCollection = await FirebaseFirestore.instance.collection("posts").doc(widget.post["postId"]).collection("comments").get();
    setState(() {
      commentLength = commentsCollection.docs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            children: [
              StoryImage(padding: 2, radius: 17, image: _post["profileImage"]),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(_post["username"]),
              )),
              const Icon(Icons.more_vert_rounded)
            ],
          ),
        ),
        
        GestureDetector(
          onDoubleTap: () async {
            handleLikePost(user);
            setState(() {
              isLikeAnimating = true;
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                constraints: const BoxConstraints(maxHeight: 375),
                child: Image.network(
                  _post["postUrl"],
                  fit: BoxFit.contain,
                ),
              ),
          
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isLikeAnimating ? 1 : 0,
                child: LikeAnimation(
                  isAnimating: isLikeAnimating,
                  duration: const Duration(milliseconds: 400),
                  onEnd: (){
                    setState(() {
                      isLikeAnimating = false;
                    });
                  },
                  child: SvgPicture.asset('assets/svgs/like_fill.svg', width: 100)
                ),
              )
            ]
          ),
        ),
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            children: [
              Row(
                  children: [

                    LikeAnimation(
                      isAnimating: _post["likes"].contains(user.uid),
                      smallLike: true,
                      child: GestureDetector(
                        onTap: () async {
                          handleLikePost(user);
                        },
                        child:  _post["likes"].contains(user.uid) ? 
                             SvgPicture.asset('assets/svgs/like_fill.svg', width: 23)
                            :
                             SvgPicture.asset('assets/svgs/like.svg',color: primaryColor, width: 23),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) => CommentScreen(
                            post: widget.post,
                          ),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            var begin = Offset(0.0, 1.0);
                            var end = Offset.zero;
                            var curve = Curves.ease;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));

                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                        ));
                      },
  
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: SvgPicture.asset('assets/svgs/comment.svg',
                            color: primaryColor, width: 23),
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/svgs/share.svg',
                      color: primaryColor,
                      width: 28,
                    ),
                    const Spacer(),
                    SvgPicture.asset(
                      'assets/svgs/bookmark.svg',
                      color: primaryColor,
                      width: 21,
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical:5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("${_post["likes"].length} likes", style: TextStyle(fontSize: 13))
                  ),
                ),

                _post["description"] != "" ? Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "${_post["username"]} ",
                          style:const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        TextSpan(
                          text: _post["description"],
                          style: const TextStyle(fontSize: 14),
                        ),
                      ]
                    )
                  )
                ) : Container(),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child:
                          Text("View all ${commentLength} comments", style: const TextStyle(fontSize: 13, color: secondaryColor))),
                ),
            ],
          )
        )
      ],
    );
  }
}
