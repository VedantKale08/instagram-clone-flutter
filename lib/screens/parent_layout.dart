import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/screens/add_post_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:provider/provider.dart';

class ParentContainer extends StatefulWidget {
  const ParentContainer({super.key});

  @override
  State<ParentContainer> createState() => _ParentContainerState();
}

class _ParentContainerState extends State<ParentContainer> {

  final List<Map<String, dynamic>> items = [
    {
      'icon': 'assets/svgs/home_outline.svg',
      'activeIcon': 'assets/svgs/home.svg',
    },
    {
      'icon': 'assets/svgs/Search.svg',
      'activeIcon': 'assets/svgs/Search_fill.svg',
    },
    {
      'icon': 'assets/svgs/Add.svg',
      'activeIcon': 'assets/svgs/Add.svg',
    },
    {
      'icon': 'assets/svgs/reel.svg',
      'activeIcon': 'assets/svgs/reel.svg', // No active icon for this item
    },
    {
      'icon': 'assets/svgs/User.svg',
      'activeIcon': 'assets/svgs/User_fill.svg',
    },
  ];

  int _pageIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController();
    addData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int pageIndex) {
    setState(() {
      _pageIndex = pageIndex;
    });
  }

  void navigate(int pageIndex) {
    _pageController.jumpToPage(pageIndex);
  }


  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    return _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(_pageIndex == 2){
          setState(() {
            _pageIndex = 0;
            _pageController.jumpToPage(_pageIndex);
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        // app bar
        appBar: _pageIndex == 2 ? null :  AppBar(
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
      
        // body
        body: PageView(
          controller: _pageController,
          onPageChanged: onPageChanged,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            const Center(child: Text("Home")),
            const Center(child: Text("Search")),
            AddPostScreen(onPageChanged: onPageChanged, navigate:navigate),
            const Center(child: Text("Reel")),
            const Center(child: Text("Profile")),
          ],
        ),
      
        // bottom bar
        bottomNavigationBar: _pageIndex == 2 ? null : Container(
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
            items: items.asMap().entries.map((entry) {
              final Map<String, dynamic> item = entry.value;
      
              return BottomNavigationBarItem(
                icon: SvgPicture.asset(item['icon'],color: primaryColor),
                activeIcon:SvgPicture.asset(item['activeIcon'],color: primaryColor)
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
