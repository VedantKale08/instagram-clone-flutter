import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/story.dart';

class ProfileScreen extends StatefulWidget {
  final uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {

  late TabController _tabController;
  int _index = 0;
  var userData = {};
  var postData = [];
  bool _isLoading = false;
  User user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
  }

  void getData() async {
    try {
      setState(() {
      _isLoading = true;
      });
      DocumentSnapshot snap  = await FirebaseFirestore.instance.collection("users").doc(widget.uid).get();
      QuerySnapshot postSnap = await FirebaseFirestore.instance.collection("posts").where("uid", isEqualTo: widget.uid).get();
      setState(() {
        userData = snap.data() as Map<String, dynamic>;
        postData = postSnap.docs;
        _isLoading = false;
      });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? const Center(child: CircularProgressIndicator()) : SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.arrow_back),
            )),
          title: Text(userData["username"] ?? "", style: TextStyle(fontSize: 20)),
          actions: const [
             Padding(
              padding: EdgeInsets.symmetric(horizontal:16),
              child: Icon(Icons.more_vert_rounded),
            )
          ],
        ),

        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StoryImage(radius: 45, padding: 2, image: userData["image"]),
                      Column(
                        children: [
                          Text("${postData.length}",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const Text("Posts", style: TextStyle(fontSize: 14))
                        ],
                      ),
                      Column(
                        children: [
                          Text("${userData["followers"] != null ? userData["followers"].length : 0}",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const Text("Followers", style: TextStyle(fontSize: 14)),
                        ],
                      ),
                      Column(
                        children: [
                          Text("${userData["followings"] != null ? userData["followings"].length : 0}",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const Text("Following", style: TextStyle(fontSize: 14)),
                        ],
                      )
                    ],
                  ),
            
                  const SizedBox(height: 6),
                  Text(userData["username"] ?? ""),
                  Text(userData["bio"] ?? ""),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: (){},
                          style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(blueColor),
                            foregroundColor: MaterialStatePropertyAll(primaryColor),
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)))
                            )
                          ),
                          child: user.uid == widget.uid ? Text("Edit profile") :  Text("Follow"),
                        ),
                      ), 
            
                      const SizedBox(width: 10),
            
                      user.uid != widget.uid ? Expanded(
                        child: TextButton(
                          onPressed: () {},
                          style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(Color.fromRGBO(64, 64, 64, 1)),
                            foregroundColor: MaterialStatePropertyAll(primaryColor),
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)))
                            )
                          ),
                          child: Text("Message"),
                        ),
                      ) : Container()
                    ],
                  ),
                ],
              )
            ),

              TabBar(
                controller: _tabController,
                onTap: (index) {
                  setState(() {
                    _index = index;
                  });
                },
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: primaryColor,
                tabs: [
                  Tab(
                      icon: SvgPicture.asset(
                    'assets/svgs/post.svg',
                    color:
                        _index == 0 ? primaryColor : secondaryColor,
                  )),
                  Tab(
                      icon: SvgPicture.asset(
                    'assets/svgs/tag.svg',
                    color:
                        _index == 1 ? primaryColor : secondaryColor,
                  )),
                ]),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      GridView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: const ScrollPhysics(),
                        gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 1,
                          crossAxisSpacing: 2),
                        itemCount: postData.length,
                        itemBuilder: (context, index) {
                          return Image.network(postData[index]["postUrl"], fit: BoxFit.cover);
                        },
                      ), 
                      Text("Tag")],
                  ),
                )
          ],
        ),
      )
    );
  }
}