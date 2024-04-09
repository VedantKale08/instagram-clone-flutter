import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/story.dart';

class Comment extends StatefulWidget {
  final comment;
  const Comment({super.key, required this.comment});

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 13),
      child: Row(
        children: [
          StoryImage(radius: 20, padding: 0, noStory: true, image: widget.comment["profilePic"],),
          const SizedBox(width:10),
          Expanded(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.comment["name"],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              SizedBox(height: 2),
              Text(widget.comment["comment"])
            ],
          ) 
          ),
          SvgPicture.asset('assets/svgs/like.svg',color: primaryColor ,width: 16)
        ],
      ),
    );
  }
}