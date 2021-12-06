import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:wallpaper/functions/useful_functions.dart';
import 'package:wallpaper/screens/downloaded_images_screen.dart';
import 'package:wallpaper/screens/homepage_screen.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ImageWithInfo extends StatefulWidget {
  final title;
  final url;
  final path;
  final url2;

  const ImageWithInfo({this.url, this.title, this.path, this.url2});

  @override
  _ImageInfoState createState() => _ImageInfoState();
}

class _ImageInfoState extends State<ImageWithInfo> {
  final TextEditingController _nameController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isFavorite = false;

  final Dio dio = Dio();

  String progress = "0 %";

  bool loading = false;

  String _getTitle(index) {
    if (index == 0) {
      return "Nature";
    } else if (index == 1) {
      return "Game";
    } else if (index == 2) {
      return "Sunset";
    } else if (index == 3) {
      return "Waterfall";
    } else {
      return "Beautiful World";
    }
  }

  String text = loremIpsum(words: 20, initWithLorem: true);

  Future<void> applyWallpaper(String locationName) async {
    int location;
    if (locationName == "Home") {
      location = WallpaperManager.HOME_SCREEN;
    } else if (locationName == "Lock") {
      location = WallpaperManager.LOCK_SCREEN;
    } else {
      location = WallpaperManager.BOTH_SCREENS;
    }

    if (widget.url2 != null) {
      await DefaultCacheManager()
          .getSingleFile(widget.url2)
          .then((value) async {
        await WallpaperManager.setWallpaperFromFile(value.path, location)
            .then((value) => showSnack(context: context, label: value));
      });
    } else {
      await WallpaperManager.setWallpaperFromFile(widget.path, location)
          .then((value) => showSnack(context: context, label: value));
    }
  }

  var uid;

  getLikedInfo() async {
    _firestore.collection('users').doc('$uid').get().then((value) {
      List<dynamic> data = value.get('likedUrls');
      if (!data.contains(widget.url)) {
        setState(() {
          isFavorite = false;
        });
      } else {
        setState(() {
          isFavorite = true;
        });
      }
    }).onError((error, stackTrace) {
      _firestore
          .collection('users')
          .doc('$uid')
          .set({'likedUrls': FieldValue.arrayUnion([])});
    });
  }

  @override
  void initState() {
    uid = auth.currentUser!.uid;
    getLikedInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    openDialog() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          title: Text(
            "For which you want to apply?",
            style: TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  applyWallpaper("Home")
                      .then((value) => Navigator.of(context).pop());
                },
                child: Text(
                  "Home",
                  style: TextStyle(color: Color(0xff3B4071)),
                )),
            TextButton(
                onPressed: () {
                  applyWallpaper("Lock")
                      .then((value) => Navigator.of(context).pop());
                },
                child:
                    Text("Lock", style: TextStyle(color: Color(0xff3B4071)))),
            TextButton(
                onPressed: () {
                  applyWallpaper("Both")
                      .then((value) => Navigator.of(context).pop());
                },
                child: Text("Both", style: TextStyle(color: Color(0xff3B4071))))
          ],
        ),
      );
    }

    Future<bool> _requestPermission(Permission permission) async {
      if (await permission.isGranted) {
        print("permission granted");
        return true;
      } else {
        var result = await permission.request();
        if (result == PermissionStatus.granted) {
          print("permission granted");
          return true;
        } else {
          print("permission not granted");
          return false;
        }
      }
    }

    Future<bool> saveFile(
        BuildContext context, String url, String fileName) async {
      Directory directory;

      ProgressDialog pr;
      pr = ProgressDialog(context, type: ProgressDialogType.Normal);
      pr.style(message: "Downloading file....");

      try {
        await pr.show();
        if (Platform.isAndroid) {
          if (await _requestPermission(Permission.storage)) {
            directory = (await getExternalStorageDirectory())!;
            String newPath = "";
            List<String> folders = directory.path.split("/");

            for (int x = 1; x < folders.length; x++) {
              String folder = folders[x];
              if (folder != "emulated") {
                newPath += "/" + folder;
              } else {
                break;
              }
            }

            newPath = newPath + "/self/primary/Pictures/Wallpapers";
            directory = Directory(newPath);
            directory.create(recursive: true);
          } else {
            return false;
          }
        } else {
          if (await _requestPermission(Permission.photos)) {
            directory = await getTemporaryDirectory();
          } else {
            return false;
          }
        }
        bool t = await directory.exists();
        if (!await directory.exists()) {
          Directory di = await directory.create(recursive: true);
          if (await di.exists()) {
          } else {}
        }
        if (await directory.exists()) {
          File saveFile = File(directory.path + "/$fileName.jpg");
          print("here in directory");
          await dio.download(url, saveFile.path,
              onReceiveProgress: (rec, total) {
            setState(() {
              loading = true;
              progress = ((rec / total) * 100).toStringAsFixed(0) + "%";

              pr.update(message: "Please wait : $progress");
            });
          });
        }
        pr.hide().then((value) => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => FetchImages())));
      } catch (e) {}

      return false;
    }

    downloadFile(BuildContext context) async {
      setState(() {
        loading = true;
      });

      bool downloaded =
          await saveFile(context, widget.url2, _nameController.text)
              .then((value) => showSnack(
                    context: context,
                    label: "download successful",
                  ));

      if (downloaded) {
        print("file downloaded");
      } else {
        print("problem downloading file");
      }
      setState(() {
        loading = false;
      });
    }

    openDialogForName() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          title: Text(
            "Enter image name ",
            style: TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: "Name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                downloadFile(context);
                // applyWallpaper("")
                //     .then((value) => Navigator.of(context).pop());
              },
              child: Text(
                "Submit",
                style: TextStyle(color: Color(0xff3B4071)),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 1.7,
              child: Stack(
                children: [
                  Positioned(
                    height: MediaQuery.of(context).size.height / 1.8,
                    top: 0,
                    left: 0,
                    right: 0,
                    child: (widget.path != null)
                        ? Hero(
                            tag: widget.path,
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height / 1.7,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                                child: Image.file(
                                  File(widget.path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        : Hero(
                            tag: widget.url,
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height / 1.7,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: widget.url,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                  ),
                  Positioned(
                    top: 50,
                    left: 30,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                  (widget.path != null)
                      ? Container()
                      : Positioned(
                          bottom: 0,
                          right: 30,
                          child: ElevatedButton(
                            onPressed: () async {
                              var docref =
                                  _firestore.collection('users').doc('$uid');
                              if (isFavorite) {
                                docref.update({
                                  'likedUrls':
                                      FieldValue.arrayRemove([widget.url])
                                }).then(
                                  (value) {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage()),
                                        (route) => false);
                                    showSnack(
                                        context: context,
                                        label: "Disliked successfully");
                                  },
                                );
                                setState(() {
                                  isFavorite = false;
                                });
                              } else {
                                docref.update({
                                  'likedUrls':
                                      FieldValue.arrayUnion([widget.url])
                                }).then(
                                  (value) => showSnack(
                                      context: context,
                                      label: "Liked successfully"),
                                );
                                setState(() {
                                  isFavorite = true;
                                });
                              }
                            },
                            child: Icon(
                              (isFavorite)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 28,
                              color: (isFavorite) ? Colors.red : Colors.black,
                            ),
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(6),
                              shape: MaterialStateProperty.all(CircleBorder()),
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.all(16)),
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.white), // <-- Button color
                            ),
                          ),
                        ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getTitle(widget.title),
                          style: TextStyle(
                              color: Color(0xff3B4071),
                              fontWeight: FontWeight.w500,
                              fontSize: 26),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          _getTitle(widget.title) + ", Beach, Water",
                          style: TextStyle(
                              fontFamily: 'poppinsThin',
                              fontStyle: FontStyle.italic,
                              color: Colors.black45,
                              fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      text,
                      style: TextStyle(color: Colors.black45),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      "28th Aug 2021",
                      style: TextStyle(
                          color: Colors.black45, fontStyle: FontStyle.italic),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      children: [
                        (widget.path == null)
                            ? Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    openDialogForName();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 15),
                                    child: Center(
                                      child: Text(
                                        "Download",
                                        style: TextStyle(
                                            color: Color(0xff3B4071),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Color(0xff3B4071),
                                            width: 2)),
                                  ),
                                ),
                              )
                            : Container(),
                        SizedBox(
                          width: 30,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              openDialog();
                              // applyWallpaper().then(
                              //     (value) => print("your wallpaper is set"));
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 15),
                              child: Center(
                                child: Text(
                                  "Apply",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              decoration: BoxDecoration(
                                  color: Color(0xff3B4071),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Color(0xff3B4071), width: 2)),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
