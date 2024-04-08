import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/story.dart';

class StoriesSection extends StatefulWidget {
  const StoriesSection({super.key});

  @override
  State<StoriesSection> createState() => _StoriesSectionState();
}

class _StoriesSectionState extends State<StoriesSection> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: const EdgeInsets.only(bottom:4),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color.fromARGB(255, 35, 35, 35))),
        ),
        child: const Row(
          children: [
            Story(isMyStory: true),
            Story(isMyStory: false),
            Story(isMyStory: false),
            Story(isMyStory: false),
            Story(isMyStory: false),
          ],
        ),
      ),
    );
  }
}