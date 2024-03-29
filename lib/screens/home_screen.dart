import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:provider/provider.dart';

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
    addData();
  }

  addData()async{
    UserProvider _userProvider = Provider.of(context,listen: false);
    return _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    // User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
        body: Center(
            child: Text("Home")
        )
    );
  }
}