import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(), 
            icon: const Padding(
              padding:  EdgeInsets.all(8.0),
              child: Icon(Icons.arrow_back),
            )
          ),
          leadingWidth: 30,
          title: Padding(
            padding: EdgeInsets.all(6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: const BoxDecoration(
                border:Border(bottom: BorderSide(color: Color.fromARGB(255, 35, 35, 35))),
              ),
              child: TextFormField(
                controller: _searchController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "Search",
                    border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10)),
                    fillColor:  Color.fromRGBO(26, 26, 26, 1),
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                  ),
                  onFieldSubmitted: (String _) {
                    print(_);
                  },
              )
            ),
          ),
        ),

        body: FutureBuilder(  
          future: FirebaseFirestore.instance.collection("users").where("username", isGreaterThanOrEqualTo: _searchController.text).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LinearProgressIndicator(color: blueColor);
            }

            if (!snapshot.hasData) {
              return Container();
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical:2),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data!.docs[index]["image"]),
                      radius: 35,
                    ),
                    title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(snapshot.data!.docs[index]["username"],),
                          Text(snapshot.data!.docs[index]["bio"], style: TextStyle(color: secondaryColor,fontSize: 13))
                        ],
                      ) 
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}