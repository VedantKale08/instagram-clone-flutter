import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/screens/add_post_screen.dart';
import 'package:instagram_clone/screens/home_screen.dart';
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
    if (pageIndex == 2) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => AddPostScreen()));
      return;
    }
    _pageController.jumpToPage(pageIndex);
  }


  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    return _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // body
        body: PageView(
          controller: _pageController,
          onPageChanged: onPageChanged,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            HomeScreen(),
            Center(child: Text("Search")),
            SizedBox(),
            Center(child: Text("Reel")),
            Center(child: Text("Profile")),
          ],
        ),
      
        // bottom bar
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
            items: items.asMap().entries.map((entry) {
              final Map<String, dynamic> item = entry.value;
      
              return BottomNavigationBarItem(
                icon: SvgPicture.asset(item['icon'],color: primaryColor),
                activeIcon:SvgPicture.asset(item['activeIcon'],color: primaryColor)
              );
            }).toList(),
          ),
        ),
    );
  }
}
