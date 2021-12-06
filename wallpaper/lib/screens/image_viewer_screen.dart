import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:wallpaper/screens/image_with_info.dart';

class ImageViewer extends StatefulWidget {
  final url;
  final title;
  final path;
  final url2;

  const ImageViewer({this.url, this.title, this.path, this.url2});

  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Color(0x903B4071), Colors.white10],
              ),
            ),
          ),
          SizedBox(
            height: double.infinity,
            child: (widget.path != null)
                ? Hero(
                    tag: widget.path,
                    child: Image.file(
                      File(widget.path),
                      fit: BoxFit.cover,
                    ),
                  )
                : Hero(
                    tag: widget.url,
                    child: CachedNetworkImage(
                      imageUrl: widget.url,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
          Positioned(
            bottom: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => (widget.path == null)
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImageWithInfo(
                              url2: widget.url2,
                              url: widget.url,
                              title: widget.title,
                            ),
                          ),
                        )
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImageWithInfo(
                              path: widget.path,
                              title: widget.title,
                            ),
                          ),
                        ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                    child: Text(
                      'More',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ],
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
        ],
      ),
    );
  }
}
