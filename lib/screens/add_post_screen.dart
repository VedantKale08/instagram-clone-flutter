import 'dart:ffi';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:photo_manager/photo_manager.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final List<Widget> _mediaList = [];
  int currentPage = 1;
  int? lastPage;
  int _index = 0;
  bool _isLoading = false;


    ScrollController _scrollController = ScrollController();


_fetchMediaImages() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth) {
      List<AssetPathEntity> album =
          await PhotoManager.getAssetPathList(onlyAll: true);

      if (album.isEmpty) {
        return;
      }

      List<AssetEntity> media =
          await album[0].getAssetListPaged(page: currentPage, size: 60);

      currentPage++;

      if (media.isNotEmpty) {
        List<Widget> temp = [];
        for (var asset in media) {
          if (asset.type == AssetType.image) {
          temp.add(FutureBuilder(
            future: asset.thumbnailDataWithSize(ThumbnailSize(
                    MediaQuery.of(context).size.width.toInt(), 375)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Container(
                  child: Stack(
                    children: [
                      Positioned.fill(
                          child:
                              Image.memory(snapshot.data!, fit: BoxFit.cover))
                    ],
                  ),
                );
              }
              return Container();
            },
          ));
          }
        }

        setState(() {
          _mediaList.addAll(temp);
          _isLoading = false;
        });
      } else {
        // If no images were fetched, handle accordingly (e.g., show a message)
        print("No images fetched from page $currentPage");
      }
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchMediaImages();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    // Check if the user has reached the end of the grid
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // If yes, fetch the next page of images
      print("Reached end of grid, fetching more images...");
      _fetchMediaImages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          leading: const Icon(Icons.arrow_back),
          title: const Text("New post", style: TextStyle(fontSize: 20)),
          actions: [
            GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AddCaptionScreen())),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Next",
                  style: TextStyle(color: blueColor, fontSize: 16),
                ),
              ),
            )
          ],
        ),
        body: SafeArea(
            child: _isLoading ? const Center(child:CircularProgressIndicator()) : SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                  height: 375,
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 1),
                    itemBuilder: (context, index) {
                      return _mediaList.isNotEmpty ?_mediaList[_index] : Container();
                    },
                  )),
              
               Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    const Text("Recents",style: TextStyle(fontSize: 18)),
                    const Spacer(),
                    Container(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(64, 64, 64, 1),
                        borderRadius: BorderRadius.all(Radius.circular(50))
                      ),
                      padding: const EdgeInsets.all(6.0),
                      child: const Icon(Icons.camera_alt_outlined, size: 20),
                    )
                  ],
                ),
              ),

              GridView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: _mediaList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 2
                ), 
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (){
                      setState(() {
                        _index = index;
                      });
                    },
                    child: _mediaList[index],
                  );
                },
              )
            ],
          ),
        )));
  }
}

class AddCaptionScreen extends StatefulWidget {
  const AddCaptionScreen({super.key});

  @override
  State<AddCaptionScreen> createState() => _AddCaptionScreenState();
}

class _AddCaptionScreenState extends State<AddCaptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(Icons.arrow_back)),
          title: const Text("New post", style: TextStyle(fontSize: 20)),
          actions: [
            GestureDetector(
              onTap: () => {},
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Next",
                  style: TextStyle(color: blueColor, fontSize: 16),
                ),
              ),
            )
          ],
        ),
        body: Text("Caption"));
  }
}
