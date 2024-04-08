import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/parent_layout.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final List<Widget> _mediaList = [];
  final List<Uint8List?> _fileList = [];
  Uint8List? _file;
  int currentPage = 1;
  int? lastPage;
  int _index = 0;
  bool _isLoading = false;

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
          await album[0].getAssetListPaged(page: currentPage, size: 50);

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

        for (var asset in media) {
          if (asset.type == AssetType.image) {
            // Read image bytes as Uint8List
            Uint8List? imageBytes = await asset.originBytes;
            _fileList.add(imageBytes); // Add image bytes to the list
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
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.arrow_back)
          ),
          title: const Text("New post", style: TextStyle(fontSize: 20)),
          actions: [
            GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddCaptionScreen(file: _file ?? _fileList[0]))),
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
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 1),
                    itemBuilder: (context, index) {
                      return _file!=null ? Image.memory(_file!, fit: BoxFit.cover) : Image.memory(_fileList[0]!, fit: BoxFit.cover);
                    },
                  )),
              
               Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    const Text("Recents",style: TextStyle(fontSize: 18)),
                    const Spacer(),
                     GestureDetector(
                      onTap: () async {
                        Uint8List file = await pickImage(ImageSource.gallery);
                        setState(() {
                          _file = file;
                        });
                      },
                       child: Container(
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(64, 64, 64, 1),
                          borderRadius: BorderRadius.all(Radius.circular(50))
                        ),
                        padding: const EdgeInsets.all(6.0),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: const Icon(Icons.image, size: 20),
                                           ),
                     ),
                    GestureDetector(
                      onTap: () async {
                        Uint8List file = await pickImage(ImageSource.camera);
                        setState(() {
                          _file = file;
                        });
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(64, 64, 64, 1),
                          borderRadius: BorderRadius.all(Radius.circular(50))
                        ),
                        padding: const EdgeInsets.all(6.0),
                        child: const Icon(Icons.camera_alt_outlined, size: 20),
                      ),
                    ),
                  ],
                ),
              ),

              GridView.builder(
                shrinkWrap: true,
                itemCount: _mediaList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 2
                ), 
                physics: const ScrollPhysics(),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (){
                      setState(() {
                        _index = index;
                        _file = _fileList[index];
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
  final Uint8List? file;
  const AddCaptionScreen({super.key, required this.file});

  @override
  State<AddCaptionScreen> createState() => _AddCaptionScreenState();
}

class _AddCaptionScreenState extends State<AddCaptionScreen> {

  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _file = widget.file;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _descriptionController.dispose();
    super.dispose();
  }

  void postImage(
    String uid,
    String username,
    String profileImage,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirebaseStoreMethods().uploadPost(
        _descriptionController.text, 
        _file, 
        uid, 
        username, 
        profileImage
      );

      setState(() {
        _isLoading = false;
      });
      if(res == "success"){
        showSnackBar(context, "Successfully posted");
        Navigator.of(context).popUntil((route) => route.isFirst);
      }else{
        showSnackBar(context, res);
      }
    } catch (e) {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return  Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(Icons.arrow_back)),
          title: const Text("New post", style: TextStyle(fontSize: 20)),
          actions: [
            GestureDetector(
              onTap: () => postImage(
                userProvider.getUser.uid,
                userProvider.getUser.username, 
                userProvider.getUser.image
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Post",
                  style: TextStyle(color: blueColor, fontSize: 16),
                ),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [

                _isLoading ? const LinearProgressIndicator() : Container(),

                const Divider(color: mobileBackgroundColor,),

                 SizedBox(
                    height: 340,
                    child: _file != null ? Image.memory(_file!,fit: BoxFit.contain,) : Container(),
                ),
          
                 Container(
                  height: 100,
                  decoration: const BoxDecoration(
                    border:Border(
                        bottom: BorderSide(color: Color.fromARGB(255, 35, 35, 35))),
                  ),
                  child: TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      hintText: "Write a caption...",
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
                ),
          
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 15.0),
                  decoration: const BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(color: Color.fromARGB(255, 35, 35, 35))),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 25),
                      SizedBox(width: 10),
                      Text("Add Location", style: TextStyle(fontSize: 15)),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios_rounded, size: 20, color: secondaryColor),
                    ],
                  ),
                ),
          
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 15.0),
                  decoration: const BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(color: Color.fromARGB(255, 35, 35, 35))),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.music_note, size: 25),
                      SizedBox(width: 10),
                      Text("Add Music", style: TextStyle(fontSize: 15)),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios_rounded,
                          size: 20, color: secondaryColor),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}
