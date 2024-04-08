import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class Story extends StatefulWidget {
  final bool isMyStory;
  const Story({super.key, required this.isMyStory});

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
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
              border: const GradientBoxBorder(
                width: 2,
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
            padding: EdgeInsets.all(4),
            child: const CircleAvatar(
              radius: 35,
              backgroundImage: AssetImage("assets/images/story_image.png")
              ),
          ),
          Text(widget.isMyStory ? "Your story" : "aalia_12" , style: TextStyle(fontSize: 12),)
        ],
      ),
    );
  }
}