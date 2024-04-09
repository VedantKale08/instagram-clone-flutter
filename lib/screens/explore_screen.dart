import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/utils/colors.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 2),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(26, 26, 26, 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  SvgPicture.asset('assets/svgs/Search.svg', color: primaryColor, width: 18,),
                  const SizedBox(width: 10),
                  const Text("Search", style: TextStyle(fontSize: 16, color: secondaryColor))
                ],
              ),
            ),
          ),
        ),

        body: FutureBuilder(
          future: FirebaseFirestore.instance.collection("posts").get(), 
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LinearProgressIndicator(color: blueColor);
            }

            if (!snapshot.hasData) {
              return Container();
            }

            return Container();
          },
        )
      ) 
    );
  }
}