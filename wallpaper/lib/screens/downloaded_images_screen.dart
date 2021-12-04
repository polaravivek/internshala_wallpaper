import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallpaper/screens/homepage_screen.dart';
import 'package:wallpaper/screens/image_viewer_screen.dart';

final Directory _photoDir =
    Directory('/storage/self/primary/Pictures/Wallpapers');

class FetchImages extends StatefulWidget {
  const FetchImages({Key? key}) : super(key: key);

  @override
  _FetchImagesState createState() => _FetchImagesState();
}

class _FetchImagesState extends State<FetchImages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    },
                    icon: Icon(Icons.arrow_back_ios),
                    iconSize: 24,
                    color: Colors.black,
                  ),
                  Text(
                    "Download",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(child: ImageGrid(directory: _photoDir)),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageGrid extends StatelessWidget {
  final Directory directory;

  const ImageGrid({Key? key, required this.directory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var imageList = directory
        .listSync()
        .map((item) => item.path)
        .where((item) => item.endsWith(".jpg"))
        .toList(growable: false);
    return (imageList.isEmpty)
        ? Container(
            alignment: Alignment.center,
            child: Text(
              'Nothing to Show...',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          )
        : StaggeredGridView.countBuilder(
            itemCount: imageList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ImageViewer(
                          path: imageList[index],
                          title: "Downloaded",
                        ),
                      ),
                    )
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(imageList[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
            staggeredTileBuilder: (int index) =>
                StaggeredTile.count(1, index.isEven ? 2 : 1),
            crossAxisCount: 2,
          );
  }
}
