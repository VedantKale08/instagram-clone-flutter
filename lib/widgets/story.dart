import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class Story extends StatefulWidget {
  final bool isMyStory;
  final String? image;
  const Story({super.key, required this.isMyStory, this.image});

  @override
  State<Story> createState() => _StoryState();
}

class _StoryState extends State<Story> {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        children: [
          StoryImage(padding: 4, radius: 35,image: widget.image),
          Text(
            widget.isMyStory ? "Your story" : "aalia_12",
            style: TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }
}

class StoryImage extends StatelessWidget {
  final double radius;
  final double padding;
  final String? image;
  final bool noStory;
  const StoryImage({super.key, required this.radius, required this.padding, this.image, this.noStory = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(60),
        border:  GradientBoxBorder(
          width:  noStory ? 0 : 2,
          gradient: LinearGradient(
            colors: [
              Color(0xFF405DE6),
              Color(0xFF833AB4),
              Color(0xFFC13584),
              Color(0xFFE1306C),
              Color(0xFFFD1D1D),
              Color(0xFFFFC133),
              Color(0xFFFFC133),
              Color(0xFFFFC133),
              Color(0xFFFAD02E),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
      ),
      padding: EdgeInsets.all(padding),
      child: image != null ? 
        CircleAvatar(
          radius: radius,
          backgroundImage: NetworkImage(image!)
        ) 
          : 
        CircleAvatar(
            radius: radius,
            backgroundImage: const AssetImage("assets/images/story_image.png")),
        );
  }
}
