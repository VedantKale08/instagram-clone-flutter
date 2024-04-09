import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/story.dart';
import 'package:provider/provider.dart';

class StoriesSection extends StatefulWidget {
  const StoriesSection({super.key});

  @override
  State<StoriesSection> createState() => _StoriesSectionState();
}

class _StoriesSectionState extends State<StoriesSection> {
  @override
  Widget build(BuildContext context) {

    final User user = Provider.of<UserProvider>(context).getUser;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(decelerationRate: ScrollDecelerationRate.fast),
      child: Container(
        padding: const EdgeInsets.only(bottom:4),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color.fromARGB(255, 35, 35, 35))),
        ),
        child: Row(
          children: [
            Story(isMyStory: true, image: user.image),
            const Story(isMyStory: false),
            const Story(isMyStory: false),
            const Story(isMyStory: false),
            const Story(isMyStory: false),
          ],
        ),
      ),
    );
  }
}