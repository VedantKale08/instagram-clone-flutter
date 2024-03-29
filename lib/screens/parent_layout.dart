import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/utils/colors.dart';

class ParentContainer extends StatefulWidget {
  const ParentContainer({super.key});

  @override
  State<ParentContainer> createState() => _ParentContainerState();
}

class _ParentContainerState extends State<ParentContainer> {
  int _pageIndex = 0;
  late PageController _pageController;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int pageIndex){
    setState(() {
      _pageIndex = pageIndex;
    });
  }

  void navigate(int pageIndex){
    _pageController.jumpToPage(pageIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // app bar
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: SvgPicture.asset("assets/svgs/logos_instagram.svg",color: primaryColor,height: 35,),
        
        actions: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(Icons.favorite_border_rounded,color: primaryColor,size: 28,),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            // child: Icon(Icons.message,color: primaryColor,size: 28,)
            child: Image.asset("assets/images/chat.png",color: primaryColor,width: 28,),
          ),
        ],
      ),

      // body
      body: PageView(
        controller: _pageController,
        onPageChanged: onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: const[
          Center(child:Text("Home")),
          Center(child:Text("Search")),
          Center(child:Text("Add")),
          Center(child:Text("Reel")),
          Center(child:Text("Profile")),
        ],
      ),

      // bottom
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border:
              Border(top: BorderSide(color: Color.fromARGB(255, 35, 35, 35))),
        ),
        padding: const EdgeInsets.only(top: 8),
        child: CupertinoTabBar(
          backgroundColor: mobileBackgroundColor,
          activeColor: primaryColor,
          currentIndex: _pageIndex,
          onTap: navigate,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded,size: 30),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded, size: 30),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box_outlined, size: 30),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.video_collection_outlined, size: 30),
              label: "",
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded, size: 30), label: ""),
          ],
        ),
      ),
    );
  }
}
