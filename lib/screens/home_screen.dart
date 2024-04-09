import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/post_card.dart';
import 'package:instagram_clone/widgets/stories_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // User user = Provider.of<UserProvider>(context).getUser;

    final Stream<QuerySnapshot> _postStream = FirebaseFirestore.instance.collection("posts")
                    .orderBy('uploaded_at', descending: true)
                    .snapshots();

    return Scaffold(
      appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: SvgPicture.asset(
            "assets/svgs/logos_instagram.svg",
            color: primaryColor,
            height: 35,
          ),
          actions: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                Icons.favorite_border_rounded,
                color: primaryColor,
                size: 28,
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SvgPicture.asset('assets/svgs/chat.svg',
                    color: primaryColor)),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              StoriesSection(),
              
              StreamBuilder(
                stream: _postStream, 
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(
                      child: LinearProgressIndicator(color: blueColor),
                    );
                  }
                  print(snapshot.data!.docs[0].data());
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) => PostCard(post:snapshot.data!.docs[index].data())
                  );
                },
              )
            ],
          ),
        )
    );
  }
}